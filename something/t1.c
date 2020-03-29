int 
ps()
{
	struct proc *p;
	sti(); // enable interrupts

	//lookup
	aquire(&ptable.lock);
	cprintf("name \t pid \t state \t \n");
	for(p =ptable.proc; p< &ptable.proc[NPROC]; p++){
		if(p->state == SLEEPING) cprintf("%s \t %d  \t SLEEPING \t \n",p->name,p->pid);
		else if(p->state == RUNNING) cprintf("%s \t %d  \t RUNNING \t \n",p->name,p->pid);
		else if(p->state == RUNNALBE) cprintf("%s \t %d  \t RUNNABLE \t \n",p->name,p->pid);
	}
	release(&ptable.lock);

	return 24;
}
