
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
-- Entity: 	tech_gscl
-- File:	tech_gscl.vhd
-- Author:      Johannes Grad
-- Description:	Contains GSCLib specific pads and ram generators
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package tech_gscl is

-- sync ram generator

  component gscl_syncram
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

component gscl_regfile
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

  component gscl_inpad port (pad : in std_logic; q : out std_logic); end component; 
  component gscl_smpad port (pad : in std_logic; q : out std_logic); end component;
  component gscl_outpad1 port (d : in  std_logic; pad : out  std_logic); end component; 
  component gscl_outpad2 port (d : in  std_logic; pad : out  std_logic); end component; 
  component gscl_outpad3 port (d : in  std_logic; pad : out  std_logic); end component; 
  component gscl_toutpad1u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component gscl_toutpad2u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component gscl_toutpad3u port (d, en : in  std_logic; pad : out  std_logic); end component; 
  component gscl_iopad1 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iopad2 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iopad3 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iopad1u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iopad2u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iopad3u 
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_iodpad 
    port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component gscl_odpad port ( d : in std_logic; pad : out std_logic); end component;

end;

-- component declarations from true tech library

LIBRARY ieee;
use IEEE.std_logic_1164.all;
package tech_gscl_syn is

  -- various two-port rams (used for regfile)
  component RAM2P_136X8 port (
    adr_a     : in std_logic_vector(7 downto 0);
    wda_a     : in std_logic_vector(7 downto 0);
    rda_a     : out std_logic_vector(7 downto 0);
    ck_a, ena_a, wri_a : in std_logic;
    oe_a      : in std_logic;
    adr_b     : in std_logic_vector(7 downto 0);
    wda_b     : in std_logic_vector(7 downto 0);
    rda_b     : out std_logic_vector(7 downto 0);
    ck_b, ena_b, wri_b : in std_logic ;
    oe_b      : in std_logic
   );
  end component;

  component RAM2P_168X32 port (
      adr_a, adr_b       : in  std_logic_vector(7 downto 0);
      wda_a, wda_b       : in  std_logic_vector(31 downto 0);
      ck_a, ena_a, wri_a : in  std_logic;
      rda_a, rda_b       : out std_logic_vector(31 downto 0);
      ck_b, ena_b, wri_b : in  std_logic;
      oe_a, oe_b         : in  std_logic);
  end component;

  -- various single-port asynchronous ram cells (used for caches)
  component RAM_256x32 port (
    adr      : in std_logic_vector(7 downto 0);
    rda      : out std_logic_vector(31 downto 0);
    wda      : in std_logic_vector(31 downto 0);
    ena, wri : in std_logic);
  end component;

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
use work.tech_gscl_syn.all;
use work.iface.all;


entity gscl_syncram is
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

architecture rtl of gscl_syncram is
  signal WRI, ENA, ENQ, gnd, pwr   : std_logic;
  signal ADR, a    : std_logic_vector(19 downto 0);
  signal WDA, d, RDA, Q : std_logic_vector(34 downto 0);
  constant synopsys_bug : std_logic_vector(37 downto 0) := (others => '0');
begin

  gnd <= '0'; pwr <= '1';
  a(abits -1 downto 0) <= address; 
  a(abits+1 downto abits) <= synopsys_bug(abits+1 downto abits);

  d(dbits -1 downto 0) <= datain;
  d(dbits+1 downto dbits) <= synopsys_bug(dbits+1 downto dbits);

  dataout <= Q(dbits -1 downto 0);
                 
       RAM_in_reg: process(clk)  -- Synchronous Interface for RAM
       begin
         if rising_edge(clk) then
           WRI <= write;
           ADR <= a;
           WDA <= d;
         end if;
         if (clk='0') then
           ENQ <= enable;
         end if;
       end process RAM_in_reg;

       ENA <= ENQ and clk;
       
--       RAM_out_latch: process(ENQ)        -- Latch RAM output data
--         begin
--           if (ENA='1') then
--             Q(31 downto 0) <= RDA(31 downto 0);
--           end if;
--         end process RAM_out_latch;
       
  a8d26 : if (abits <= 8) and (dbits <= 32) generate
    id0 :  RAM_256x32
         port map (
           ENA => ENA,
           WRI => WRI,
           ADR => ADR(7 downto 0), 
           WDA => WDA(31 downto 0), 
           RDA => Q(31 downto 0)
          );
  end generate;
end rtl;

------------------------------------------------------------------
-- regfile generator  --------------------------------------------
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;
use work.tech_gscl_syn.all;
use work.iface.all;

entity gscl_regfile is
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

architecture rtl of gscl_regfile is

signal din0, qq1, qq2, qdump : std_logic_vector(31 downto 0);

signal ren1, ren2, wen, vcc, gnd, pwr : std_logic;
begin

  din0 <= (others => '0');
  gnd  <= '0';
  pwr  <= '1'; 

  ren1 <= rfi.ren1;
  ren2 <= rfi.ren2;
  wen  <= rfi.wren;
  

  dp136x32 : if (words = 136) and (dbits = 32) generate
    u0: RAM2P_136X8
	  port map (adr_a   => rfi.rd1addr(abits -1 downto 0),
                    wda_a   => din0(7 downto 0),
                    rda_a   => qq1(7 downto 0),
                    ck_a    => clkn,
                    oe_a    => pwr,
                    ena_a   => ren1,
                    wri_a   => gnd,
                    adr_b   => rfi.wraddr(abits -1 downto 0),
                    wda_b   => rfi.wrdata(7 downto 0),
                    rda_b   => qdump(7 downto 0),
                    ck_b    => clkn,
                    ena_b   => wen,
                    oe_b    => pwr,
                    wri_b   => wen 
                   );
    u1: RAM2P_136X8
	  port map (adr_a   => rfi.rd1addr(abits -1 downto 0),
                    wda_a   => din0(15 downto 8),
                    rda_a   => qq1(15 downto 8),
                    ck_a    => clkn,
                    oe_a    => pwr,
                    ena_a   => ren1,
                    wri_a   => gnd,
                    adr_b   => rfi.wraddr(abits -1 downto 0),
                    wda_b   => rfi.wrdata(15 downto 8),
                    rda_b   => qdump(15 downto 8),
                    ck_b    => clkn,
                    ena_b   => wen,
                    oe_b    => pwr,
                    wri_b   => wen 
                   );
    u2: RAM2P_136X8
	  port map (adr_a   => rfi.rd1addr(abits -1 downto 0),
                    wda_a   => din0(23 downto 16),
                    rda_a   => qq1(23 downto 16),
                    ck_a    => clkn,
                    oe_a    => pwr,
                    ena_a   => ren1,
                    wri_a   => gnd,
                    adr_b   => rfi.wraddr(abits -1 downto 0),
                    wda_b   => rfi.wrdata(23 downto 16),
                    rda_b   => qdump(23 downto 16),
                    ck_b    => clkn,
                    ena_b   => wen,
                    oe_b    => pwr,
                    wri_b   => wen 
                   );
    u3: RAM2P_136X8
	  port map (adr_a   => rfi.rd1addr(abits -1 downto 0),
                    wda_a   => din0(31 downto 24),
                    rda_a   => qq1(31 downto 24),
                    ck_a    => clkn,
                    oe_a    => pwr,
                    ena_a   => ren1,
                    wri_a   => gnd,
                    adr_b   => rfi.wraddr(abits -1 downto 0),
                    wda_b   => rfi.wrdata(31 downto 24),
                    rda_b   => qdump(31 downto 24),
                    ck_b    => clkn,
                    ena_b   => wen,
                    oe_b    => pwr,
                    wri_b   => wen 
                   );
    u4: RAM2P_136X8
	  port map (adr_a  => rfi.rd2addr(abits -1 downto 0),
                    wda_a  => din0(7 downto 0),
                    rda_a  => qq2(7 downto 0),
                    ck_a   => clkn,
                    oe_a   => pwr,
                    ena_a  => ren2,
                    wri_a  => gnd,
                    adr_b  => rfi.wraddr(abits -1 downto 0),
                    wda_b  => rfi.wrdata(7 downto 0),
                    rda_b  => qdump(7 downto 0),
                    ck_b   => clkn,
                    oe_b   => pwr,
                    ena_b  => wen,
                    wri_b  => wen 
                   );
    u5: RAM2P_136X8
	  port map (adr_a  => rfi.rd2addr(abits -1 downto 0),
                    wda_a  => din0(15 downto 8),
                    rda_a  => qq2(15 downto 8),
                    ck_a   => clkn,
                    oe_a   => pwr,
                    ena_a  => ren2,
                    wri_a  => gnd,
                    adr_b  => rfi.wraddr(abits -1 downto 0),
                    wda_b  => rfi.wrdata(15 downto 8),
                    rda_b  => qdump(15 downto 8),
                    ck_b   => clkn,
                    oe_b   => pwr,
                    ena_b  => wen,
                    wri_b  => wen 
                   );
    u6: RAM2P_136X8
	  port map (adr_a  => rfi.rd2addr(abits -1 downto 0),
                    wda_a  => din0(23 downto 16),
                    rda_a  => qq2(23 downto 16),
                    ck_a   => clkn,
                    oe_a   => pwr,
                    ena_a  => ren2,
                    wri_a  => gnd,
                    adr_b  => rfi.wraddr(abits -1 downto 0),
                    wda_b  => rfi.wrdata(23 downto 16),
                    rda_b  => qdump(23 downto 16),
                    ck_b   => clkn,
                    oe_b   => pwr,
                    ena_b  => wen,
                    wri_b  => wen 
                   );
    u7: RAM2P_136X8
	  port map (adr_a  => rfi.rd2addr(abits -1 downto 0),
                    wda_a  => din0(31 downto 24),
                    rda_a  => qq2(31 downto 24),
                    ck_a   => clkn,
                    oe_a   => pwr,
                    ena_a  => ren2,
                    wri_a  => gnd,
                    adr_b  => rfi.wraddr(abits -1 downto 0),
                    wda_b  => rfi.wrdata(31 downto 24),
                    rda_b  => qdump(31 downto 24),
                    ck_b   => clkn,
                    oe_b   => pwr,
                    ena_b  => wen,
                    wri_b  => wen 
                   );
  --rfo.data1 <= qq1(dbits -1 downto 0);
  --rfo.data2 <= qq2(dbits -1 downto 0);

  end generate;

  wb : rfbypass generic map (abits, dbits)
       --atong port map (clk, write, datain, raddr1, raddr2, waddr, qq1, qq2, dataout1, dataout2);
       port map (clk, rfi.wren, rfi.wrdata, rfi.rd1addr, rfi.rd2addr, rfi.wraddr, qq1, qq2, rfo.data1, rfo.data2);
end;

------------------------------------------------------------------
-- mapping generic pads on tech pads ---------------------------------
------------------------------------------------------------------

-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_inpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of gscl_inpad is begin 
  i0 : pdidgz port map (pad => pad, c => q); 
end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_smpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of gscl_smpad is begin 
  i0 : pddsdgz port map (pad => pad, c => q); 
end;

-- output pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_outpad1 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of gscl_outpad1 is begin 
  i0 : pdo04cdg port map (pad => pad, i => d);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_outpad2 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of gscl_outpad2 is begin 
  i0 : pdo08cdg port map (pad => pad, i => d);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_outpad3 is port (d : in std_logic; pad : out std_logic); end; 
architecture syn of gscl_outpad3 is begin 
  i0 : pdo12cdg port map (pad => pad, i => d);
end;

-- tri-state output pads with pull-up, oen active low
-- configure bidirectional tri-state output pads with pull-up as output only
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_toutpad1u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of gscl_toutpad1u is 
begin 
  i0 : pdu04dgz port map (pad => pad, i => d, oen => en, c => open);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_toutpad2u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of gscl_toutpad2u is 
begin 
  i0 : pdu08dgz port map (pad => pad, i => d, oen => en, c => open);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_toutpad3u is 
port (d, en : in  std_logic; pad : inout  std_logic); end; 
architecture syn of gscl_toutpad3u is 
begin 
  i0 : pdu12dgz port map (pad => pad, i => d, oen => en, c => open);
end;

-- bidirectional pad, oen active low
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad1 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad1 is 
begin 
  i0 : pdb04dgz port map (pad => pad, i => d, oen => en, c => q);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad2 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad2 is 
begin 
  i0 : pdb08dgz port map (pad => pad, i => d, oen => en, c => q);
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad3 is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad3 is 
begin 
  i0 : pdb12dgz port map (pad => pad, i => d, oen => en, c => q);
end;

-- bidirectional pad with pull-up, oen active low
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad1u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad1u is 
begin 
  i0 : pdu04dgz port map (pad => pad, i => d, oen => en, c => q);
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad2u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad2u is 
begin 
  i0 : pdu08dgz port map (pad => pad, i => d, oen => en, c => q);
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iopad3u is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iopad3u is 
begin 
  i0 : pdu12dgz port map (pad => pad, i => d, oen => en, c => q);
end;

-- bidirectional pad with open-drain
-- connect 3 state bidirectional pad with output enable as follows
-- d to oe, gnd to i
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_gscl_syn.all;
entity gscl_iodpad is
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of gscl_iodpad is 
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
use work.tech_gscl_syn.all;
entity gscl_odpad is port (d : in std_logic; pad : out std_logic); end;
architecture syn of gscl_odpad is 
signal gnd : std_logic;
begin 
  gnd <= '0';
  i0 : pdt04dgz port map (pad => pad, i => gnd, oen => d);
end;

