-- IEEE754 FP Single to FP Double Converter
-- Author: John Moskal
--  Created: 11-05-2004
-- Modified: 11-19-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity sng2dbl is
port
(
        S:   in std_logic_vector(31 downto 0);
        D:   out std_logic_vector(63 downto 0)
);
end entity sng2dbl;
--------------------------------------------

architecture stuff of sng2dbl is

signal s_e:   std_logic_vector(7 downto 0);
signal s_m:   std_logic_vector(22 downto 0);

signal d_e:   std_logic_vector(10 downto 0);
signal d_m:   std_logic_vector(51 downto 0);

begin

-- split S into exp and mantissa
s_e <= S(30 downto 23);
s_m <= S(22 downto 0);

-- Convert Exponent
expconv: process (s_e) 
begin 
  if (s_e = "00000000") then d_e <= "00000000000";
  elsif(s_e = "11111111") then d_e <= "11111111111";
  else
      d_e(10) <= s_e(7);
      d_e(9)  <= not s_e(7);
      d_e(8)  <= not s_e(7);
      d_e(7)  <= not s_e(7);
      d_e(6 downto 0) <= s_e(6 downto 0);
  end if; 
end process expconv; 

-- Convert Mantissa
d_m(51 downto 29) <= s_m(22 downto 0);
d_m(28 downto 0) <= "00000000000000000000000000000";

-- Merge sign, exp and mantissa into one signal
D(63) <= S(31);
D(62 downto 52) <= d_e;
D(51 downto 0) <= d_m;

end stuff;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

--signal zer:   std_logic;
--signal one:  std_logic;
--signal val:  std_logic;

--zer <= not(s_e(7) or s_e(6) or s_e(5) or s_e(4) or s_e(3) or s_e(2) or s_e(1) or s_e(0));
--one <= s_e(7) and s_e(6) and s_e(5) and s_e(4) and s_e(3) and s_e(2) and s_e(1) and s_e(0);
--val <= not(zer or one);
--d_e(10) <= (val and s_e(7)) or one;
--d_e(9) <= (val and (not s_e(7))) or one;
--d_e(8) <= (val and (not s_e(7))) or one;
--d_e(7) <= (val and (not s_e(7))) or one;
--d_e(6) <= (val and s_e(6)) or one;
--d_e(5) <= (val and s_e(5)) or one;
--d_e(4) <= (val and s_e(4)) or one;
--d_e(3) <= (val and s_e(3)) or one;
--d_e(2) <= (val and s_e(2)) or one;
--d_e(1) <= (val and s_e(1)) or one;
--d_e(0) <= (val and s_e(0)) or one;

