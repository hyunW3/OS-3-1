#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
// it is sharing data with ptable in proc.c? -> yes
extern struct ptable{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

void runtime_overflow_handle(){
  	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		//cprintf("pid :%d, state:%s\n",p->pid,p->state);
//		p->runtime /= 1000;
		p->runtime = (p->runtime >> 10);
		p->vruntime = (p->vruntime >>10); // p->vruntime /= 1000;
		p->start_time = (p->start_time >>10); // ;p->start_time /= 1000;;
		//if(p->pid != 0) cprintf("pid :%d -> %d %d %d\n",p->pid,p->runtime,p->vruntime,p->start_time);
	}
	release(&ptable.lock);
};
// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER: // timer interrupt
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
//  case T_IRQ0 + IRQ_IDE2:
//	ide2intr();
//	lpaiceoi();
//	break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  // hyunwoong
  // when timer interrupt occurs, runtime of certain process increases.
	if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    {
		//int inc = 10000000;
		int inc = 1000;
		if((myproc()->runtime+inc) <0 || (myproc()->vruntime+inc) <0){ //overflow handling
			if((myproc()->runtime+inc) <0)	myproc()->runtime = MAX_INT;
			if((myproc()->vruntime+inc) <0)	myproc()->vruntime = MAX_INT;
			runtime_overflow_handle();
		}else {
			myproc()->runtime +=inc;
    		myproc()->vruntime += (int)inc*1024/(myproc()->weight); 
		}
		// yield or not
		if(myproc()->time_slice >0){
			//myproc()->time_slice -=1000;
			myproc()->time_slice -=inc;

		}else {
			// time_slice to be reset
			setnice(myproc()->pid,myproc()->nice); // should be change to set_time_slice
		//	ps();
			yield();
		}
	}	
  
	// Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
