#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct ptable{
  struct spinlock lock;
  struct proc proc[NPROC];
  int total_weight;
} ptable;

static struct proc *initproc;
int weight_val[11] = { 3121, 2501, 1991, 1586, 1277, 1024, 820, 655, 526, 423, 355 };

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
	initlock(&ptable.lock, "ptable");
}	

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  
  p->runtime =0;
  p->vruntime =0;
  p->start_time=ticks;
  release(&ptable.lock);
  // setnice include lock
  setnice(p->pid,0); // include set weight,time_slice
  
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  p->runtime=0;
  p->vruntime=0;
  release(&ptable.lock);
  // setnice include lock
  setnice(p->pid,0);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
  // setnice include lock
  setnice(np->pid,curproc->nice);
  
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  //add value
  np->vruntime = curproc->vruntime;
  np->start_time = curproc->start_time;
  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct proc *smallest;
  int min_vruntime; // is no use of min_vruntime = -1; not initialize
  //int flag=0;
  struct cpu *c = mycpu();
  c->proc = 0;
 
  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
	smallest = ptable.proc;
	min_vruntime = -1;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if((p->state != RUNNABLE) && (p->state != RUNNING))   continue;
	  else {
		if(min_vruntime == -1){
			//cprintf("found!\n");
			min_vruntime = p->vruntime;
			smallest = p;
			//flag = 1;
		} else {
			//cprintf("not found\n");
			if(min_vruntime > p->vruntime){
				min_vruntime = p->vruntime;
				smallest = p;
			} //else continue;
		}	
		
	  }
	}
	p = smallest;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
	  p->start_time = ticks;
      swtch(&(c->scheduler), p->context);
      switchkvm();
	  c->proc = 0;
	release(&ptable.lock);
  }

}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  int min_vruntime=-1;

  // find min_vruntime in runnable process
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
	if(p->state == RUNNABLE || p->state == RUNNING){
		if(min_vruntime == -1){
			min_vruntime = p->vruntime;	
		}else { // if
			if(min_vruntime > p->vruntime){
				min_vruntime = p->vruntime;
			}
		}
	}
  }

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
	  // cal vruntime =  minimum vruntime of processes in the ready queue - vruntime(1tick)
	  int vruntime_1tick= (int)1000*(1024/p->weight);
	  if(min_vruntime == -1) p->vruntime = 0;
	  else  p->vruntime = min_vruntime - vruntime_1tick; 
	  //cprintf("wake up! pid:%d\n",p->pid);
	}
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
// own syscall
void print_state(const struct proc *p){
	int len_name=0;
	for(len_name=0; p->name[len_name] != '\0'; len_name++);
	if(len_name >2){
		if(p->runtime <100000000){
			if(p->state == SLEEPING)      cprintf("%s     \t %d  \t SLEEPING \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNING)  cprintf("%s     \t %d  \t RUNNING \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNABLE) cprintf("%s     \t %d  \t RUNNABLE \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == ZOMBIE)   cprintf("%s     \t %d  \t ZOMBIE \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
		} else {
			if(p->state == SLEEPING) 	  cprintf("%s     \t %d  \t SLEEPING \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNING)  cprintf("%s     \t %d  \t RUNNING \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNABLE) cprintf("%s     \t %d  \t RUNNABLE \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == ZOMBIE)   cprintf("%s     \t %d  \t ZOMBIE \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
		}
	} else { // short ps name
		if(p->runtime <1000000000){
			if(p->state == SLEEPING)      cprintf("%s \t\t %d  \t SLEEPING \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNING)  cprintf("%s \t\t %d  \t RUNNING \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNABLE) cprintf("%s \t\t %d  \t RUNNABLE \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == ZOMBIE)   cprintf("%s \t\t %d  \t ZOMBIE \t %d      \t %d      \t %d      \t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
		} else {
			if(p->state == SLEEPING) 	  cprintf("%s \t\t %d  \t SLEEPING \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNING)  cprintf("%s \t\t %d  \t RUNNING \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == RUNNABLE) cprintf("%s \t\t %d  \t RUNNABLE \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
			else if(p->state == ZOMBIE)   cprintf("%s \t\t %d  \t ZOMBIE \t %d      \t %d      \t %d\t%d \t \n",p->name,p->pid,p->nice,p->runtime/p->weight,p->runtime,p->vruntime);
		}
	}

//else if(p->state == EMBRYO) cprintf("%s \t %d  \t %d  \t EMBRYO \t %d \t \n",p->name,p->nice,p->pid,p->runtime);
//else if(p->state == UNUSED) cprintf("%s \t %d  \t %d  \t UNUSED \t %d \t \n",p->name,p->nice,p->pid,p->runtime);

}
int 
ps(void)
{
	struct proc *p;
	sti(); // enable interrupts

	//lookup
	acquire(&ptable.lock);
	cprintf("current ticks : %d\nname \t\t pid \t state \t\t priority\t runtime/weight\t runtime\tvruntime \n",ticks*1000);
	// start_time should be changed to runtime/weight
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
		print_state(p);
	}
	release(&ptable.lock);
	//yield();
	return 24;
}

int 
setnice(int pid,int nice_val)
{
	//exec only not acquire(&ptable);
	struct proc* p;
	int total_weight=0;
  	int write=0;
	if(nice_val>=-5 && nice_val <=5){
		// cal total weight of runnable process & nice,weight
		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			// set nice weight
			if(p->pid == pid) {	
				p->nice = nice_val;
				p->weight = weight_val[nice_val+5];
				write=1;
			}
			// cal total weight
			if(p->state != RUNNABLE && p->state != RUNNING) continue;
			else {
//				cprintf("pid : %d, weight :%d\n",p->pid,p->weight);
				total_weight += p->weight;
			}
		}
        ptable.total_weight = total_weight;
  		release(&ptable.lock);
		//total_weight == 0 when start xv6 & start process
//		cprintf("process's total_weight : %d\n\n",ptable.total_weight);
		if(total_weight != 0) {
//			cprintf("total_weight : %d\n",total_weight);
  			acquire(&ptable.lock);
  			// cal time_slice
			for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
				if(p->state != RUNNABLE && p->state != RUNNING) continue;
				p->time_slice = (10000*p->weight/total_weight); // 10tick(*1000 mili tick) x weigth / total_weight 
//				cprintf("time_slice : %d(10000*(%d/%d)\n",p->time_slice,p->weight,total_weight);
  			}
  			release(&ptable.lock);
		}
	}
	if(write == 1) return 0;
	else return -1; // fail
}
int 
getnice(int pid)
{
	int val;
	struct proc* p;
	
  	acquire(&ptable.lock);
  	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    	if(p->pid == pid){
			val = p->nice;
			release(&ptable.lock);
			if(val >=-5 && val<=5) return val;	
    		else return -10; // default : -1 since nice : -5~5, should be change
		}
  	}
  	release(&ptable.lock);
	return -10;
}

