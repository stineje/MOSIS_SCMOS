-- Postnormalization Unit
-- Author: John Moskal
--  Created: 11-12-2004
-- Modified: 11-16-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity postnorm is
port
(
   I:   in std_logic_vector(53 downto 0);   -- Input
   SEL: in std_logic;                       -- mux Select
   SDP: in std_logic;                       -- Single (0) or Double (1) Precision Select
   O:   out std_logic_vector(51 downto 0);  -- Normalized Result
   L:   out std_logic;                      -- LSB
   G:   out std_logic                       -- Guard bit
);
end entity postnorm;
--------------------------------------------

architecture stuff of postnorm is

begin

outtype: process(SEL, SDP, I)
begin
   if (SEL='0') then
      if (SDP='1') then
          G <= I(0);
          L <= I(1);
          O <= I(52 downto 1);
      else
          G <= I(29);
          L <= I(30);
          O(51 downto 29) <= I(52 downto 30);
          O(28 downto 0) <= "11111111111111111111111111111";  -- (SP ulp addition in rounding unit)
--          O(28 downto 0) <= "00000000000000000000000000000";
      end if;
   else    
      if (SDP='1') then
          G <= I(1);
          L <= I(2);
          O <= I(53 downto 2);
      else
          G <= I(30);
          L <= I(31);
          O(51 downto 29) <= I(53 downto 31);
          O(28 downto 0) <= "11111111111111111111111111111";  -- (SP ulp addition in rounding unit)
--          O(28 downto 0) <= "00000000000000000000000000000";
      end if;
   end if;
   end process outtype;

end stuff;

   
-------------------------------------------------------
-------------------------------------------------------
--component mux2to1 is
--port
--(
--   Input1:   in std_logic;
--   Input2:   in std_logic;
--   Sel:      in std_logic;
--   Output:   out std_logic
--);
--end component mux2to1;

-------------------------------------------------------

--signal O_w:   std_logic_vector(52 downto 0);

-------------------------------------------------------
   
--   if (SDP='1') then
--       G <= O_w(0);
--       L <= O_w(1);
--       O <= O_w(52 downto 1);
--   else
--       G <= O_w(29);
--       L <= O_w(30);
--       O(51 downto 29) <= O_w(52 downto 30);
--       O(28 downto 0) <= "00000000000000000000000000000";
--   end if;

----mux00:   --mux2to1 port map(I(0), I(1) , SEL, O_w(0));
--mux01:   --mux2to1 port map(I(1), I(2) , SEL, O_w(1));
--mux02:   --mux2to1 port map(I(2), I(3) , SEL, O_w(2));
--mux03:   --mux2to1 port map(I(3), I(4) , SEL, O_w(3));
--mux04:   --mux2to1 port map(I(4), I(5) , SEL, O_w(4));
--mux05:   --mux2to1 port map(I(5), I(6) , SEL, O_w(5));
--mux06:   --mux2to1 port map(I(6), I(7) , SEL, O_w(6));
--mux07:   --mux2to1 port map(I(7), I(8) , SEL, O_w(7));
--mux08:   --mux2to1 port map(I(8), I(9) , SEL, O_w(8));
--mux09:   --mux2to1 port map(I(9), I(10) , SEL, O_w(9));
--mux10:   --mux2to1 port map(I(10), I(11) , SEL, O_w(10));
--mux11:   --mux2to1 port map(I(11), I(12) , SEL, O_w(11));
--mux12:   --mux2to1 port map(I(12), I(13) , SEL, O_w(12));
--mux13:   --mux2to1 port map(I(13), I(14) , SEL, O_w(13));
--mux14:   --mux2to1 port map(I(14), I(15) , SEL, O_w(14));
--mux15:   --mux2to1 port map(I(15), I(16) , SEL, O_w(15));
--mux16:   --mux2to1 port map(I(16), I(17) , SEL, O_w(16));
--mux17:   --mux2to1 port map(I(17), I(18) , SEL, O_w(17));
--mux18:   --mux2to1 port map(I(18), I(19) , SEL, O_w(18));
--mux19:   --mux2to1 port map(I(19), I(20) , SEL, O_w(19));
--mux20:   --mux2to1 port map(I(20), I(21) , SEL, O_w(20));
--mux21:   --mux2to1 port map(I(21), I(22) , SEL, O_w(21));
--mux22:   --mux2to1 port map(I(22), I(23) , SEL, O_w(22));
--mux23:   --mux2to1 port map(I(23), I(24) , SEL, O_w(23));
--mux24:   --mux2to1 port map(I(24), I(25) , SEL, O_w(24));
--mux25:   --mux2to1 port map(I(25), I(26) , SEL, O_w(25));
--mux26:   --mux2to1 port map(I(26), I(27) , SEL, O_w(26));
--mux27:   --mux2to1 port map(I(27), I(28) , SEL, O_w(27));
--mux28:   --mux2to1 port map(I(28), I(29) , SEL, O_w(28));
--mux29:   --mux2to1 port map(I(29), I(30) , SEL, O_w(29));
--mux30:   --mux2to1 port map(I(30), I(31) , SEL, O_w(30));
--mux31:   --mux2to1 port map(I(31), I(32) , SEL, O_w(31));
--mux32:   --mux2to1 port map(I(32), I(33) , SEL, O_w(32));
--mux33:   --mux2to1 port map(I(33), I(34) , SEL, O_w(33));
--mux34:   --mux2to1 port map(I(34), I(35) , SEL, O_w(34));
--mux35:   --mux2to1 port map(I(35), I(36) , SEL, O_w(35));
--mux36:   --mux2to1 port map(I(36), I(37) , SEL, O_w(36));
--mux37:   --mux2to1 port map(I(37), I(38) , SEL, O_w(37));
--mux38:   --mux2to1 port map(I(38), I(39) , SEL, O_w(38));
--mux39:   --mux2to1 port map(I(39), I(40) , SEL, O_w(39));
--mux40:   --mux2to1 port map(I(40), I(41) , SEL, O_w(40));
--mux41:   --mux2to1 port map(I(41), I(42) , SEL, O_w(41));
--mux42:   --mux2to1 port map(I(42), I(43) , SEL, O_w(42));
--mux43:   --mux2to1 port map(I(43), I(44) , SEL, O_w(43));
--mux44:   --mux2to1 port map(I(44), I(45) , SEL, O_w(44));
--mux45:   --mux2to1 port map(I(45), I(46) , SEL, O_w(45));
--mux46:   --mux2to1 port map(I(46), I(47) , SEL, O_w(46));
--mux47:   --mux2to1 port map(I(47), I(48) , SEL, O_w(47));
--mux48:   --mux2to1 port map(I(48), I(49) , SEL, O_w(48));
--mux49:   --mux2to1 port map(I(49), I(50) , SEL, O_w(49));
--mux50:   --mux2to1 port map(I(50), I(51) , SEL, O_w(50));
--mux51:   --mux2to1 port map(I(51), I(52) , SEL, O_w(51));
--mux52:   --mux2to1 port map(I(52), I(53) , SEL, O_w(52));

