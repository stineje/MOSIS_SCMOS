
----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------
-- Entity: 	leon
-- File:	leon.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Complete processor
------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Modified: 9/18/02 dtk  removed pads
-- Modified: 9/26/02 dtk  modified to match ks
-- Modified: 9/30/02 dtk  modified to move proc up to leon level
-- Modified: 10/09/02 dtk added half speed clock and clock enable
-- Modified: 12/03/02 dtk changed AHB masters from 4 to 2
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_map.all;
-- pragma translate_off
use work.debug.all;
-- pragma translate_on

-- dtk 9/26/02
use work.amba.all;
use work.ambacomp.all;

entity leon is
  port (
    resetn   : in    std_logic; 			-- system signals
    clk      : in    std_logic;

-- dtk 10/09/02
    clk_half : in    std_logic;  -- half speed clock
    clk_ena  : in    std_logic;  -- half speed clock used as enable

    errorn   : out   std_logic;
    address  : out   std_logic_vector(27 downto 0); 	-- memory bus

-- dtk 9/18/02
--    data     : inout std_logic_vector(31 downto 0);
-- dtk 9/26/02
    data_2core : in std_logic_vector(31 downto 0);  -- data in
    data_2pad  : out std_logic_vector(31 downto 0); -- data out
    data_en_n  : out std_logic_vector(3 downto 0);  -- data dir

    ramsn    : out   std_logic_vector(4 downto 0);
    ramoen   : out   std_logic_vector(4 downto 0);
-- dtk 9/18/02
--    rwen     : inout std_logic_vector(3 downto 0);
-- dtk 9/26/02
--    rweni     : in std_logic_vector(3 downto 0);  -- rwen in
    rwen_2pad   : out std_logic_vector(3 downto 0); -- rwen out
--    rwend     : out std_logic;                    -- rwen dir
    romsn    : out   std_logic_vector(1 downto 0);
    iosn     : out   std_logic;
    oen      : out   std_logic;
    read     : out   std_logic;
-- dtk 9/18/02
--    writen   : inout std_logic;
-- dtk 9/26/02
--    writeni   : in std_logic;   -- writen in
    writen_2pad : out std_logic;  -- writen out
--    writend   : out std_logic;  -- writen dir

    brdyn    : in    std_logic;
    bexcn    : in    std_logic;

-- dtk 9/18/02
--    pio      : inout std_logic_vector(15 downto 0); 	-- I/O port
-- dtk 9/26/02
    pio_2core  : in  std_logic_vector(15 downto 0); 	-- pio in
    pio_2pad   : out std_logic_vector(15 downto 0); 	-- pio out
    pio_en_n   : out std_logic_vector(15 downto 0); 	-- pio dir

    wdogn    : out   std_logic;				-- watchdog output

-- dtk 9/26/02
--    dsuen    : in    std_logic;
--    dsutx    : out   std_logic;
--    dsurx    : in    std_logic;
--    dsubre   : in    std_logic;
--    dsuact   : out   std_logic;
    test     : in    std_logic;

-- dtk 12/03/02
    ahbmi_out  : out ahb_mst_in_vector(1 to AHB_MST_MAX-1);
    ahbmo_in   : in  ahb_mst_out_vector(1 to AHB_MST_MAX-1);
    -- 0 used by proc; removed unused pci 1, 2
-- dtk 9/26/02
--    ahbmi_out  : out ahb_mst_in_vector(3 to AHB_MST_MAX-1);
--    ahbmo_in   : in  ahb_mst_out_vector(3 to AHB_MST_MAX-1);
    -- 0 used by proc; 1, 2 used by pci
    ahbsi_out  : out ahb_slv_in_vector(4 to AHB_SLV_MAX-1);
    ahbso_in   : in  ahb_slv_out_vector(4 to AHB_SLV_MAX-1);
    -- 0, 1 used by mctrl; 2, 3 used by pci
    ext_irq    : in  std_logic  -- irq(11)
  );
end; 

architecture rtl of leon is

component mcore
  port (
    resetn   : in  std_logic;
    clk      : in  std_logic;
    memi     : in  memory_in_type;
    memo     : out memory_out_type;
    ioi      : in  io_in_type;
    ioo      : out io_out_type;
    pcii     : in  pci_in_type;
    pcio     : out pci_out_type;
    dsi      : in  dsuif_in_type;
    dso      : out dsuif_out_type;
    test     : in  std_logic;
-- dtk 10/09/02
    clk_half : in  std_logic;  -- half speed clock
    clk_ena  : in  std_logic;  -- half speed clock used as enable
-- dtk 9/30/02 proc interface
    rst_proc   : out  std_logic;
    clki       : in clkgen_in_type;
    clko_proc  : out  clkgen_out_type;
    mcii       : in memory_ic_in_type;
    mcio       : out  memory_ic_out_type;
    mcdi       : in memory_dc_in_type;
    mcdo       : out  memory_dc_out_type;
    ahbsi_proc : out  ahb_slv_in_type;
    iui        : out  iu_in_type;
    iuo        : in iu_out_type;
-- dtk 12/03/02
    ahbmi_out  : out ahb_mst_in_vector(1 to AHB_MST_MAX-1);
    ahbmo_in   : in  ahb_mst_out_vector(1 to AHB_MST_MAX-1);
-- dtk 9/26/02
--    ahbmi_out  : out ahb_mst_in_vector(3 to AHB_MST_MAX-1);
--    ahbmo_in   : in  ahb_mst_out_vector(3 to AHB_MST_MAX-1);
    ahbsi_out  : out ahb_slv_in_vector(4 to AHB_SLV_MAX-1);
    ahbso_in   : in  ahb_slv_out_vector(4 to AHB_SLV_MAX-1);
    ext_irq    : in  std_logic  -- irq(11)
);
end component; 
-- dtk 9/30/02 proc moved up here
component proc
  port (
    rst    : in  std_logic;
    clki   : out clkgen_in_type;
    clko   : in  clkgen_out_type;
    mcii   : out memory_ic_in_type;
    mcio   : in  memory_ic_out_type;
    mcdi   : out memory_dc_in_type;
    mcdo   : in  memory_dc_out_type;
    ahbsi  : in  ahb_slv_in_type;
    iui    : in  iu_in_type;
    iuo    : out iu_out_type
  );
end component; 

signal gnd, clko, resetno : std_logic;
signal memi     : memory_in_type;
signal memo     : memory_out_type;
signal ioi      : io_in_type;
signal ioo      : io_out_type;
signal pcii     : pci_in_type;
signal pcio     : pci_out_type;
signal dsi      : dsuif_in_type;
signal dso      : dsuif_out_type;
-- dtk 9/30/02 proc interface
signal rst_proc   : std_logic;
signal clki       : clkgen_in_type;
signal clko_proc  : clkgen_out_type;
signal mcii       : memory_ic_in_type;
signal mcio       : memory_ic_out_type;
signal mcdi       : memory_dc_in_type;
signal mcdo       : memory_dc_out_type;
signal ahbsi_proc : ahb_slv_in_type;
signal iui        : iu_in_type;
signal iuo        : iu_out_type;

begin

  gnd <= '0';

-- main processor core

  mcore0  : mcore  
  port map ( 
    resetn => resetno, clk => clko, 
    memi => memi, memo => memo, ioi => ioi, ioo => ioo,
    pcii => pcii, pcio => pcio, dsi => dsi, dso => dso, test => test,
-- dtk 10/09/02
    clk_half => clk_half, clk_ena => clk_ena, 
-- dtk 9/30/02 proc interface
    rst_proc => rst_proc, clki => clki, clko_proc => clko_proc, 
    mcii => mcii, mcio => mcio, mcdi => mcdi, mcdo => mcdo, 
    ahbsi_proc => ahbsi_proc, iui => iui, iuo => iuo,
    ahbmi_out => ahbmi_out, ahbmo_in => ahbmo_in, 
    ahbsi_out => ahbsi_out, ahbso_in => ahbso_in, 
    ext_irq => ext_irq
  );
-- dtk 9/30/02 proc moved up here
  proc0 : proc port map (
    rst => rst_proc, clki =>clki, clko => clko_proc, 
    mcii => mcii, mcio => mcio, mcdi => mcdi, mcdo => mcdo, 
    ahbsi => ahbsi_proc, iui => iui, iuo =>iuo
  );

-- pads
-- dtk 9/18/02

--  clk_pad   : inpad port map (clk, clko);	-- clock
  clko <= clk;					-- avoid buffering during synthesis
--  reset_pad   : smpad port map (resetn, resetno);	-- reset
  resetno <= resetn;
--  brdyn_pad   : inpad port map (brdyn, memi.brdyn);	-- bus ready
  memi.brdyn <= brdyn;
--  bexcn_pad   : inpad port map (bexcn, memi.bexcn);	-- bus exception
  memi.bexcn <= bexcn ;

--    error_pad   : odpad generic map (2) port map (ioo.errorn, errorn);	-- cpu error mode
  errorn <= ioo.errorn;

--    d_pads: for i in 0 to 31 generate			-- data bus
--      d_pad : iopad generic map (3) port map (memo.data(i), memo.bdrive((31-i)/8), memi.data(i), data(i));
--    end generate;
-- dtk 9/26/02
  memi.data <= data_2core;
  data_2pad <= memo.data;
  data_en_n <= memo.bdrive;


--    pio_pads : for i in 0 to 15 generate		-- parallel I/O port
--      pio_pad : smiopad generic map (2) port map (ioo.piol(i), ioo.piodir(i), ioi.piol(i), pio(i));
--    end generate;
-- dtk 9/26/02
  ioi.piol <= pio_2core;
  pio_2pad <= ioo.piol;
  pio_en_n <= ioo.piodir;

--    rwen_pads : for i in 0 to 3 generate			-- ram write strobe
--      rwen_pad : iopad generic map (2) port map (memo.wrn(i), gnd, memi.wrn(i), rwen(i));
--    end generate;
-- dtk 9/26/02
  memi.wrn <= memo.wrn;
  rwen_2pad <= memo.wrn;
--  rwend <= gnd;
     							-- I/O write strobe
--    writen_pad : iopad generic map (2) port map (memo.writen, gnd, memi.writen, writen);
-- dtk 9/26/02
  memi.writen <= memo.writen;
  writen_2pad <= memo.writen;
--  writend <= gnd;

--    a_pads: for i in 0 to 27 generate			-- memory address
--      a_pad : outpad generic map (3) port map (memo.address(i), address(i));
--    end generate;
  address <= memo.address;

--    ramsn_pads : for i in 0 to 4 generate		-- ram oen/rasn
--      ramsn_pad : outpad generic map (2) port map (memo.ramsn(i), ramsn(i));
--    end generate;
  ramsn <= memo.ramsn;

--    ramoen_pads : for i in 0 to 4 generate		-- ram chip select
--      eamoen_pad : outpad generic map (2) port map (memo.ramoen(i), ramoen(i));
--    end generate;
  ramoen <= memo.ramoen;

--    romsn_pads : for i in 0 to 1 generate			-- rom chip select
--      romsn_pad : outpad generic map (2) port map (memo.romsn(i), romsn(i));
--    end generate;
  romsn <= memo.romsn;

--    read_pad : outpad generic map (2) port map (memo.read, read);	-- memory read
  read <= memo.read;
--    oen_pad  : outpad generic map (2) port map (memo.oen, oen);	-- memory oen
  oen <= memo.oen;
--    iosn_pad : outpad generic map (2) port map (memo.iosn, iosn);	-- I/O select
  iosn <= memo.iosn;
--    wd : if WDOGEN generate
--      wdogn_pad : odpad generic map (2) port map (ioo.wdog, wdogn);	-- watchdog output
--    end generate;
  wdogn <= ioo.wdog;

--    ds : if DEBUG_UNIT generate
--      dsuen_pad   : inpad port map (dsuen, dsi.dsui.dsuen);	-- DSU enable
--      dsutx_pad   : outpad generic map (1) port map (dso.dcomo.dsutx, dsutx);
--      dsurx_pad   : inpad port map (dsurx, dsi.dcomi.dsurx);	-- DSU receive data
--      dsubre_pad  : inpad port map (dsubre, dsi.dsui.dsubre);	-- DSU break
--      dsuact_pad  : outpad generic map (1) port map (dso.dsuo.dsuact, dsuact);
--    end generate;
-- dtk 9/26/02
--  dsi.dsui.dsuen <= dsuen;
--  dsutx <= dso.dcomo.dsutx;
--  dsi.dcomi.dsurx <= dsurx;
--  dsi.dsui.dsubre <= dsubre;
--  dsuact <= dso.dsuo.dsuact;

end ;


