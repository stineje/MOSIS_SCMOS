#include "leon.h"
#include "test.h"

// leon_test() is like void main()
//
// custom-> is a pointer to the custom logic
//          address space on the AMBA bus
//
// To compile, run "make" on the command line
//
// The result will be in "ram.dat"
//
// For the RTL simulation:
// 1) cd socks/sim
// 2) ../exe/socks_sim my_prog
// where "my_prog" is the name of your firmware folder
//
// Johannes Grad, IIT
//

int nums[10]={2,1,3,5,4,7,6,9,8,0};
char text[20]="Bubblesort:";

int i,j,flag,helper;

void printstr(char * c){
  while(*c) print_scr(*c++);
  print_scr('\n');
}

leon_test()
{
  // Write some text to the TXT.OUT file
  print_txt('J');
  print_txt('G');

  // Write some text to the INT.OUT file
  print_int(1234);
  print_int(5678);

  // Now start the real program
  // First print a nice header
  printstr(text);
  
  do{
    for(i=0;i<10;i++) {
      print_scr('0'+nums[i]);
      print_scr(' ');
    }
    print_scr('\n');
    flag=0;
    for(j=0;j<9;j++)
      if(nums[j]>nums[j+1]){
	flag=1;
	helper=nums[j];
	nums[j]=nums[j+1];
	nums[j+1]=helper;
      }
  }while(flag==1);

  // Exit Simulation
  exit_sim();
  while (1) {};
  
}
