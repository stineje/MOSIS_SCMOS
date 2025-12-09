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
// 2) ../exe/socks_sim cube
//
// Johannes Grad, IIT
//

int nums[10]={0,1,2,3,4,5,39,40,41,42};

int j;

leon_test()
{
  for(j=0;j<10;j++)
    {
      custom[0]=nums[j];
      print_int(custom[0]);
    }
  

  // Exit Simulation
  exit_sim();
  while (1) {};
  
}
