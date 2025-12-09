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

int nums[33]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32};

int a,b,c;

leon_test()
{

// cd1dfffe00000000 3f80047e00000000 op 00 cd1e058a00000000 10000 0
  custom->fp10 = 0xCD1DFFFE;
  custom->fp20 = 0x3F80047e;
  custom->fpscr = 0x07A8A;
  print_int(custom->fp30);
  print_int(custom->fpscr);

// def77ffe00000000 ec00037f00000000 op 10 7f80000000000000 10100 0
  custom->fp10 = 0xDEF77FFE;
  custom->fp20 = 0xEC00037F;
  custom->fpscr = 0x47A8A;
  print_int(custom->fp30);
  print_int(custom->fpscr);

// C0100010003FFFFF C1EFEFFFFFBFFFFF op 00 420FF01FF03FBFBD 10000 0
  custom->fp0 = 0xC0100010;
  custom->fp1 = 0x003FFFFF;
  custom->fp2 = 0xC1EFEFFF;
  custom->fp3 = 0xFFBFFFFF;
  custom->fpscr = 0x11040;
  print_int(custom->fp4);
  print_int(custom->fp5);
  print_int(custom->fpscr);

// BFFED3F255B447EA BE20007F7FFFFFFE op 01 3E2ED4E7FEA762DA 10000 0
  custom->fp0 = 0xBFFED3F2;
  custom->fp1 = 0x55B447EA;
  custom->fp2 = 0xBE20007F;
  custom->fp3 = 0x7FFFFFFE;
  custom->fpscr = 0x31040;
  print_int(custom->fp4);
  print_int(custom->fp5);
  print_int(custom->fpscr);

// 757FFFFC0000007F 6AC0100040000000 op 11 7FEFFFFFFFFFFFFF 10100 0
  custom->fp0 = 0x757FFFFC;
  custom->fp1 = 0x0000007F;
  custom->fp2 = 0x6AC01000;
  custom->fp3 = 0x40000000;
  custom->fpscr = 0x71040;
  print_int(custom->fp4);
  print_int(custom->fp5);
  print_int(custom->fpscr);

// 228FFFC00FFFFFFF 802FFFFE00000001 op 10 8000000000000000 11000 0
  custom->fp0 = 0x228FFFC0;
  custom->fp1 = 0x0FFFFFFF;
  custom->fp2 = 0x802FFFFE;
  custom->fp3 = 0x00000001;
  custom->fpscr = 0x51040;
  print_int(custom->fp4);
  print_int(custom->fp5);
  print_int(custom->fpscr);

// res= 390C_E000_0000_0000 exact
  custom->fp0 = 0x78050000;
  custom->fp1 = 0x00000000;
  custom->fp2 = 0x00F60000;
  custom->fp3 = 0x00000000;
  custom->fpscr = 0x11040;
  print_int(custom->fp4);
  print_int(custom->fp5);
  print_int(custom->fpscr);

//res= 4E5C_8000_0000_0000 exact
  custom->fp10 = 0x0FA80000;
  custom->fp20 = 0x7E280000;
  custom->fpscr = 0x07A8A;
  print_int(custom->fp30);
  print_int(custom->fpscr);

//res= 5EDC_8000_0000_0000 OVF exact
  custom->fp10 = 0x7F280000;
  custom->fp20 = 0x7F280000;
  custom->fpscr = 0x87A8A;
  print_int(custom->fp30);
  print_int(custom->fpscr);

  exit_sim();
  while (1) {};
  
}
