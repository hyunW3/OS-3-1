#include "types.h"
#include "stat.h"
#include "user.h"


void testcfs()
{
	int parent = getpid();
	int child;
	int i;
	double x = 0, z;
	child = fork();
	//if((child = fork()) == 0) { // child
	if(child==0){
		//printf(1, "setnice val of parent(pid:%d) : %d\n",parent,setnice(parent, 5));		
		setnice(parent, 5);
		// if you set parent's priority lower than child, 
		// 2nd ps will only printout parent process,
		// since child finished its job earlier & exit
		//printf(1,"parent's nice value : %d\n",getnice(parent));
		for(i = 0; i < 3000; i++){
//			if(i%1000 == 0) ps();
			for ( z = 0; z < 30000.0; z += 0.1 )
				x =  x + 3.14 * 89.64;
		}
		//printf(1,"%d child - %d - child proces\n",parent,child);
		ps();
		exit();
	} else {	
		setnice(child, 0);	  //parent
		printf(1,"parent'pid :%d, child'pid :%d\n",parent,child);
	
		for(i = 0; i < 3000; i++){
//			if(i%1000 == 0) ps();
			for ( z = 0; z < 30000.0; z += 0.1 )
				x =  x + 3.14 * 89.64;
		}
		//printf(1,"parent - %d %d - parent proces\n",parent,child);
		ps();
		wait();
	}
}
int main(int argc, char **argv)
{
		printf(1, "=== TEST START ===\n");
		testcfs();
		printf(1, "=== TEST   END ===\n");
		ps();
		exit();
		//ps(); // available?
}
