//------------------------------------------------------------------------------
//-----------------------      JTA Research Inc          -----------------------
//--------------------- Copyright (c) JTA Research Inc     ---------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//-- Title         : AMBA/DMA DEFINITION MNEMONICS 
//------------------------------------------------------------------------------
//-- File          : defines.v
//-- Designer      : S. COLE
//-- Created       : 2001/02
//-- Last Modified : 2001/02
//------------------------------------------------------------------------------
//-- Description   :
//-- VERILOG       : reusable definition file for AMBA bus signals
//                 : also contains DMA CONFIGURATION PARAMETERS
//------------------------------------------------------------------------------
//-- Modification history :
//-- 2001/02/15    : Created - S.COLE
//------------------------------------------------------------------------------

`define CYCLE_60   16.7
`define HALF_CYCLE_60 8.35
`define CYCLE_100   10
`define HALF_CYCLE_100 5

`define masters             3
`define defmast             0
`define AHB_SLV_MAX        10

`define HAMAX              32
`define HDMAX              32
`define AHB_SLV_ADDR_MSB    4  //MSB in address to decode slaves
`define ahbmin             `AHB_SLV_ADDR_MSB - 1

`define AHB_CACHE_ADDR_MSB  3
`define AHB_SPLIT           0

`define mo_HWDATA_base      0 
`define mo_HADDR_base      `HDMAX
`define mo_HPROT_base      `mo_HADDR_base + `HAMAX
`define mo_HBURST_base     `mo_HADDR_base  + `HAMAX + 4
`define mo_HSIZE_base      `mo_HBURST_base + 3
`define mo_HTRANS_base     `mo_HSIZE_base + 3
`define mo_HWRITE_base     `mo_HTRANS_base + 2
`define mo_HLOCK_base      `mo_HTRANS_base + 3
`define mo_HBUSREQ_base    `mo_HTRANS_base + 4
 
`define mi_HRDATA_base     `HDMAX - 1 : 0
`define mi_HRESP_base      `HDMAX + 1 : `HDMAX
`define mi_HCACHE_base     `HDMAX + 2
`define mi_HREADY_base     `HDMAX + 3
`define mi_HGRANT_base     `HDMAX + 4

`define so_HRDATA_base     (`HDMAX + 19)
`define so_HRESP_base      `so_HRDATA_base + `HDMAX + 16
`define so_HREADY_base     `so_HRESP_base + 2

`define si_HWDATA_base     `HDMAX -1 : 0
`define si_HADDR_base      `HAMAX -1 + `HDMAX : `HDMAX
`define si_HMASTLOCK_base  `HDMAX + `HAMAX 
`define si_HMASTER_base    `si_HMASTLOCK_base + 4 : `si_HMASTLOCK_base + 1
`define si_HPROT_base      `si_HMASTLOCK_base + 8 : `si_HMASTLOCK_base + 5
`define si_HBURST_base     `si_HMASTLOCK_base + 11 : `si_HMASTLOCK_base + 9             
`define si_HSIZE_base      `si_HMASTLOCK_base + 14 : `si_HMASTLOCK_base + 12
`define si_HTRANS_base     `si_HMASTLOCK_base + 16 : `si_HMASTLOCK_base + 15
`define si_HREADY_base     `si_HMASTLOCK_base + 17
`define si_HWRITE_base     `si_HMASTLOCK_base + 18
`define si_HSEL_base       `si_HMASTLOCK_base + 19
 
`define msti_width         (`HDMAX + 5)
`define slvi_width         (`HDMAX + `HAMAX + 20)
`define msto_width         (`HDMAX + `HAMAX + 15)

/*********************************************************/
// DMA CONFIGURATION PARAMETERS

  //-----------------------------------------------------
  // hard-wired start/stop channel boundary's 
  // [12'h000-12'h7FF] {64k}
  //-----------------------------------------------------

   //--------------------------------
   `define CH1_START       16'h0000
   `define CH1_STOP        16'h01FF
   //--------------------------------
   `define CH2_START       16'h0200
   `define CH2_STOP        16'h03FF
   //--------------------------------
   `define CH3_START       16'h0400
   `define CH3_STOP        16'h05FF
   //--------------------------------
   `define CH4_START       16'h0600
   `define CH4_STOP        16'h07FF
   //--------------------------------

  //-----------------------------------------------------

/*********************************************************/

