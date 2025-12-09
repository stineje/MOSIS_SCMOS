
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
-- Entity: 	tech_tsmc
-- File:	tech_tsmc.vhd
-- Author: Ben Yeung	
-- Description:	Contains TSMC specific pads and ram generators
------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Modified: 6/27/02 dtk  removed regfile bypass
--                        removed regfile read enable, always enabled
-- Modified: 10/10/02 dtk  mods for simulation
-----------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package tech_tsmc is

-- sync ram generator

  component tsmc_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in clk_type;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic
   );
  end component;

-- regfile generator

component tsmc_regfile
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    clkn     : in clk_type;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type
    );
  end component;

-- pads

  component tsmc_inpad port (pad : in std_logic; q : out std_logic); end component; 
  component tsmc_smpad port (pad : in std_logic; q : out std_logic); end component;
  component tsmc_outpad1 port (d : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_outpad2 port (d : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_outpad3 port (d : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_toutpad1u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_toutpad2u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_toutpad3u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component tsmc_iopad1 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iopad2 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iopad3 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iopad1u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iopad2u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iopad3u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_iodpad 
    port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc_odpad port ( d : in std_logic; pad : out std_logic); end component;

end;

-- component declarations from true tech library

LIBRARY ieee;
use IEEE.std_logic_1164.all;
package tech_tsmc_syn is

  -- various two-port rams (used for regfile)
  component RAM2P_136X32 port (
    AA     : in std_logic_vector(7 downto 0);
    DA     : in std_logic_vector(31 downto 0);
    QA     : out std_logic_vector(31 downto 0);
    CLKA, CENA, WENA : in std_logic;
    AB     : in std_logic_vector(7 downto 0);
    DB     : in std_logic_vector(31 downto 0);
    QB     : out std_logic_vector(31 downto 0);
    CLKB, CENB, WENB : in std_logic 
   );
  end component;
  component RAM2P_168X32 port (
      AA, AB   : in  std_logic_vector(7 downto 0);
      DA   : in  std_logic_vector(31 downto 0);
      QA   : out std_logic_vector(31 downto 0);
      CENA, WENA  : in  std_logic );
  end component;

  -- various single-port asynchronous ram cells (used for caches)
  component RAM_256x32 port (
    A     : in std_logic_vector(7 downto 0);
    D     : in std_logic_vector(31 downto 0);
    Q     : out std_logic_vector(31 downto 0);
    CLK, CEN, WEN : in std_logic);
  end component;
-- dtk 7/01/02 added 128x32 dual port substitute for 128x32 ram
  component RAM2P_128X32 port (
    AA     : in std_logic_vector(6 downto 0);
    DA     : in std_logic_vector(31 downto 0);
    QA     : out std_logic_vector(31 downto 0);
    CLKA, CENA, WENA : in std_logic;
    AB     : in std_logic_vector(6 downto 0);
    DB     : in std_logic_vector(31 downto 0);
    QB     : out std_logic_vector(31 downto 0);
    CLKB, CENB, WENB : in std_logic 
   );
  end component;
--  component RAM2P_1024X32 port (
--    AA     : in std_logic_vector(9 downto 0);
--    DA     : in std_logic_vector(31 downto 0);
--    QA     : out std_logic_vector(31 downto 0);
--    CLKA, CENA, OENA, WENA : in std_logic;
--    AB     : in std_logic_vector(9 downto 0);
--    DB     : in std_logic_vector(31 downto 0);
--    QB     : out std_logic_vector(31 downto 0);
--    CLKB, CENB, OENB, WENB : in std_logic );
--  end component;
--  component RAM2P_2048X32 port (
--    AA     : in std_logic_vector(10 downto 0);
--    DA     : in std_logic_vector(31 downto 0);
--    QA     : out std_logic_vector(31 downto 0);
--    CLKA, CENA, OENA, WENA : in std_logic;
--    AB     : in std_logic_vector(10 downto 0);
--    DB     : in std_logic_vector(31 downto 0);
--    QB     : out std_logic_vector(31 downto 0);
--    CLKB, CENB, OENB, WENB : in std_logic );
--  end component;

  -- input pad
  component pdidgz port (pad : in std_logic; c : out std_logic); end component; 
  -- input pad with pull-up
  component pdudgz port (pad : in std_logic; c : out std_logic); end component; 
  -- schmitt input pad
  component pddsdgz port (pad : in std_logic; c : out std_logic); end component; 
  -- schmitt input pad with pull-up
  -- configure bidirectional schmitt input pad with pull-up as input only
  component pdu04sdgz port (pad : inout std_logic; c : out std_logic); end component; 
  -- output pads
  component pdo04cdg port (i : in std_logic; pad : out std_logic); end component; 
  component pdo08cdg port (i : in std_logic; pad : out std_logic); end component; 
  component pdo12cdg port (i : in std_logic; pad : out std_logic); end component; 
  component pdo24cdg port (i : in std_logic; pad : out std_logic); end component; 
  -- tri-state output pads 
   component pdt04dgz port (i, oen : in std_logic; pad : out std_logic); end component; 
  -- component pdu08dgz port (i, oen : in std_logic; pad : out std_logic); end component; 
  -- component pdu12dgz port (i, oen : in std_logic; pad : out std_logic); end component; 
  -- component pdu24dgz port (i, oen : in std_logic; pad : out std_logic); end component; 
  -- bidirectional pads
  component pdb04dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdb08dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdb12dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdb24dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  -- bidirectional pads with pull-up
  component pdu04dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdu08dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdu12dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
  component pdu24dgz
    port (i, oen : in std_logic; c : out std_logic; pad : inout std_logic);
  end component; 
end;
------------------------------------------------------------------
-- sync ram generator --------------------------------------------
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
use work.iface.all;


entity tsmc_syncram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in clk_type;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic
  );
end;

architecture rtl of tsmc_syncram is
  signal wr, cs, gnd, pwr   : std_logic;
  signal a    : std_logic_vector(19 downto 0);
  signal d, q : std_logic_vector(34 downto 0);
-- dtk 7/01/02
  signal qdump : std_logic_vector(31 downto 0);
-- dtk 10/10/02
  signal AB : std_logic_vector(6 downto 0);
  signal DB : std_logic_vector(31 downto 0);

  constant synopsys_bug : std_logic_vector(37 downto 0) := (others => '0');
begin

  cs <= not enable; 
  wr <= not write;
  gnd <= '0'; pwr <= '1';
  a(abits -1 downto 0) <= address; 
  a(abits+1 downto abits) <= synopsys_bug(abits+1 downto abits);

  d(dbits -1 downto 0) <= datain;
  d(dbits+1 downto dbits) <= synopsys_bug(dbits+1 downto dbits);

  dataout <= q(dbits -1 downto 0);

  a8d26 : if (abits <= 8) and (dbits <= 32) generate
    id0 : RAM_256x32 

	  port map (A => a(7 downto 0), 
                    D => d(31 downto 0), 
                    Q => q(31 downto 0), 
                    CLK => clk, 
                    CEN => cs, 
                    --atong for .13 lib OEN => gnd, 
                    WEN => wr
                   );

  end generate;
--  a10d32 : if (abits > 8) and (abits <= 10) and (dbits <= 32) generate
--    id0 : RAM2P_1024X32 
--
--	  port map ( AA   => a(9 downto 0), 
--                     DA   => d(31 downto 0), 
--                     QA   => q(31 downto 0), 
--                     CLKA => clk, 
--                     CENA => cs, 
--                     OENA => pwr, 
--                     WENA => wr,
--                     AB   => a2(9 downto 0)  ,
--                     DB   => d2(31 downto 0)  ,
--                     QB     =>   q2(31 downto 0),
--                     CLKB   =>   clk2,
--                     CENB   =>   enable2,
--                     OENB   =>   gnd,
--                     WENB   =>   write2
--                   );
--
--  end generate;
--  a11d32 : if (abits = 11) and (dbits <= 32) generate
--    id0 : RAM2P_2048X32 
--
--	  port map (AA   => a(10 downto 0), 
--                    DA   => d(31 downto 0), 
--                    QA   => q(31 downto 0), 
--                    CLKA => clk, 
--                    CENA => cs, 
--                    OENA => pwr, 
--                    WENA => wr,
--                    AB   => a2(10 downto 0)  ,
--                    DB   => d2(31 downto 0)  ,
--                    QB   => q2(31 downto 0), 
--                    CLKB   =>   clk2,
--                    CENB   =>   enable2,
--                    OENB   =>   gnd,
--                    WENB   =>   write2
--                   );
--
--  end generate;
end rtl;

------------------------------------------------------------------
-- regfile generator  --------------------------------------------
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;
use work.tech_tsmc_syn.all;
use work.iface.all;

entity tsmc_regfile is
  generic ( 
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    clkn     : in clk_type;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type
  );
end;

architecture rtl of tsmc_regfile is

signal din0, qq1, qq2, qdump : std_logic_vector(31 downto 0);

signal ren1, ren2, wen, vcc, gnd, pwr : std_logic;

-- dtk 10/10/02 to delay address and data
  signal wraddr : std_logic_vector(abits -1 downto 0);
  signal wrdata : std_logic_vector(dbits -1 downto 0);

begin

  din0 <= (others => '0');
  gnd  <= '0';
  pwr  <= '1'; 

  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;
  wen  <= not rfi.wren;
  
-- dtk 10/10/02 to delay address and data
  wraddr <= rfi.wraddr(abits -1 downto 0) after 1 ns;
  wrdata <= rfi.wrdata(dbits -1 downto 0) after 1 ns;

  dp136x32 : if (words = 136) and (dbits = 32) generate
    u0: RAM2P_136X32
	  port map (AA   => rfi.rd1addr(abits -1 downto 0),
                    DA   => din0,
                    QA   => qq1,
                    CLKA => clkn,
-- dtk 6/27/02 removed enable, always enabled
                    -- CENA => ren1,
                    CENA => gnd,
                    --atong for .13 lib OENA => ren1,
                    WENA => pwr,
-- dtk 10/10/02 to delay address and data
                  --  AB     => rfi.wraddr(abits -1 downto 0),
                  --  DB     => rfi.wrdata(dbits -1 downto 0),
                    AB     => wraddr,
                    DB     => wrdata,
                    QB     => qdump,
-- dtk 6/28/02 changed clock to positive edge
                    -- CLKB   => clkn,
                    CLKB   => clk,
                    CENB   => wen,
                    --atong for .13 lib OENB   => pwr,
                    WENB   => wen 
                   );
    u1: RAM2P_136X32
	  port map (AA   => rfi.rd2addr(abits -1 downto 0),
                    DA   => din0,
                    QA   => qq2,
                    CLKA => clkn,
-- dtk 6/27/02 removed enable, always enabled
                    -- CENA => ren2,
                    CENA => gnd,
                    --atong for .13 lib OENA => ren2,
                    WENA => pwr,
-- dtk 10/10/02 to delay address and data
                  --  AB     => rfi.wraddr(abits -1 downto 0),
                  --  DB     => rfi.wrdata(dbits -1 downto 0),
                    AB     => wraddr,
                    DB     => wrdata,
                    QB     => qdump,
-- dtk 6/28/02 changed clock to posive edge
                    -- CLKB   => clkn,
                    CLKB   => clk,
                    CENB   => wen,
                    --atong for .13 lib OENB   => pwr,
                    WENB   => wen 
                   );
-- dtk 6/27/02 uncommented
-- dtk 6/28/02 re-commented out
-- dtk 6/27/02 uncommented
  rfo.data1 <= qq1(dbits -1 downto 0);
  rfo.data2 <= qq2(dbits -1 downto 0);


  end generate;

-- dtk 6/27/02 removed rf bypass
-- dtk 6/28/02 put rf bypass back in
-- dtk 6/27/02 removed rf bypass again
--  wb : rfbypass generic map (abits, dbits)
--       --atong port map (clk, write, datain, raddr1, raddr2, waddr, qq1, qq2, dataout1, dataout2);
--       port map (clk, rfi.wren, rfi.wrdata, rfi.rd1addr, rfi.rd2addr, rfi.wraddr, qq1, qq2, rfo.data1, rfo.data2);
end;

------------------------------------------------------------------
-- mapping generic pads on tech pads ---------------------------------
------------------------------------------------------------------

-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_inpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of tsmc_inpad is begin 
  i0 : pdidgz port map (pad => pad, c => q); 
end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_smpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of tsmc_smpad is begin 
  i0 : pddsdgz port map (pad => pad, c => q); 
end;

-- output pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_outpad1 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of tsmc_outpad1 is begin 
  i0 : pdo04cdg port map (pad => pad, i => d);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_outpad2 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of tsmc_outpad2 is begin 
  i0 : pdo08cdg port map (pad => pad, i => d);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_outpad3 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of tsmc_outpad3 is begin 
  i0 : pdo12cdg port map (pad => pad, i => d);
end;

-- tri-state output pads with pull-up, oen active low
-- configure bidirectional tri-state output pads with pull-up as output only
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_toutpad1u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of tsmc_toutpad1u is 
begin 
  i0 : pdu04dgz port map (pad => pad, i => d, oen => en, c => open);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_toutpad2u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of tsmc_toutpad2u is 
begin 
  i0 : pdu08dgz port map (pad => pad, i => d, oen => en, c => open);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_toutpad3u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of tsmc_toutpad3u is 
begin 
  i0 : pdu12dgz port map (pad => pad, i => d, oen => en, c => open);
end;

-- bidirectional pad, oen active low
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad1 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad1 is 
begin 
  i0 : pdb04dgz port map (pad => pad, i => d, oen => en, c => q);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad2 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad2 is 
begin 
  i0 : pdb08dgz port map (pad => pad, i => d, oen => en, c => q);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad3 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad3 is 
begin 
  i0 : pdb12dgz port map (pad => pad, i => d, oen => en, c => q);
end;

-- bidirectional pad with pull-up, oen active low
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad1u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad1u is 
begin 
  i0 : pdu04dgz port map (pad => pad, i => d, oen => en, c => q);
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad2u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad2u is 
begin 
  i0 : pdu08dgz port map (pad => pad, i => d, oen => en, c => q);
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iopad3u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iopad3u is 
begin 
  i0 : pdu12dgz port map (pad => pad, i => d, oen => en, c => q);
end;

-- bidirectional pad with open-drain
-- connect 3 state bidirectional pad with output enable as follows
-- d to oe, gnd to i
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_iodpad is
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc_iodpad is 
signal gnd : std_logic;
begin 
  gnd <= '0';
  i0 : pdb04dgz port map (pad => pad, i => gnd, oen => d, c => q);
end;

-- output pad with open-drain
-- connect 3 state bidirectional pad with output enable as follows
-- d to oe, gnd to i, and disconnect c
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc_syn.all;
entity tsmc_odpad is port (d : in std_logic; pad : out std_logic); end;
architecture syn of tsmc_odpad is 
signal gnd : std_logic;
begin 
  gnd <= '0';
  i0 : pdt04dgz port map (pad => pad, i => gnd, oen => d);
end;







