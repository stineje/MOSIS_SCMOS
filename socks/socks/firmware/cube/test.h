/* @(#) test.h 1.1@(#)
*  ==================================================================
*  SCCS Path and File Name: /projects/ks/.sccs/s.test.h
*  File Name: test.h
*  SCCS File Release: 1 at Version: 1
*  Last Modified: 03/05/02 at 13:33:11
*  SCCS-get Executed on 03/19/02 at 13:38:33 to Get this File
*
*  Description: defines and externs used by the C source
*
*  Level: Header
*
*  Class: TBD
*
*  Revision History:
*  Date          By        Change
*  -----------   --------  ----------------------------------------
*  Mar 05 2002   mcynar    Initial version
*  EOL
*  =========================================================================
*/

#define MSGAREA      IOAREA

#define PRINT(X)     set MSGAREA, %o0; ld [%o0 + X*4], %g0
#define FAIL(X)      set MSGAREA, %o0; st %g0, [%o0 + X*4]
#define SYS_TEST     0
#define CACHE_TEST   1
#define REG_TEST     2
#define MUL_TEST     3
#define DIV_TEST     4
#define WATCH_TEST   5
#define FPU_TEST     7
#define PCI_TEST     8
#define RAM_INIT     9
#define IRQ_TEST     10
#define TIMER_TEST   11
#define UART_TEST    12
#define PIO_TEST     13
#define EDAC_TEST    14
#define DMA_TEST     15
#define DPRAM_TEST   16
#define CRAM_TEST    17
#define MEM_TEST     18

#define ITAG_VALID_MASK  ((1 << ILINESZ) -1)
#define ITAG_MAX_ADDRESS ((1 << ITAG_BITS) -1) << (ILINEBITS + 2)
#define DTAG_VALID_MASK  ((1 << DLINESZ) -1)
#define DTAG_MAX_ADDRESS ((1 << DTAG_BITS) -1) << (DLINEBITS + 2)

#ifndef __ASSEMBLER__
extern struct lregs *lr;
extern int *custom;
#endif
