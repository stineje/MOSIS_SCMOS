-- Special Case Detection
--   Author: John Moskal
--  Created: 11-19-2004
-- Modified: 11-20-2004
--
-- /------+-------+-------+-------+-------+-------\
-- |      | Zero  |  OK   | SNaN  | QNaN  |  Inf  |
-- |------+-------+-------+-------+-------+-------|
-- | Zero | Zero  | Zero  | QNaN* | QNaN  | QNaN* |
-- |------+-------+-------+-------+-------+-------|
-- |  OK  | Zero  |  OK   | QNaN* | QNaN  |  Inf  |
-- |------+-------+-------+-------+-------+-------|
-- | SNaN | QNaN* | QNaN* | QNaN* | QNaN* | QNaN* |
-- |------+-------+-------+-------+-------+-------|
-- | QNaN | QNaN  | QNaN  | QNaN* | QNaN  | QNaN  |
-- |------+-------+-------+-------+-------+-------|
-- | Inf  | QNaN* |  Inf  | QNaN* | QNaN  |  Inf  |
-- \------+-------+-------+-------+-------+-------/
--
-- * Invalid Operatio Exception
--
-- Denormalized numbers are not implemented, and treated as ZERO.
--
-- QNaN Single = 0 11111111 10000000000000000000000
-- QNaN Double = 0 11111111111 1000000000000000000000000000000000000000000000000000
--
-- SNaN Single = 0 11111111 01000000000000000000000
-- SNaN Double = 0 11111111111 0100000000000000000000000000000000000000000000000000
--

-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity speccase is
port
(
   I1:   in std_logic_vector(63 downto 0);
   I2:   in std_logic_vector(63 downto 0);
   FL:   out std_logic_vector(4 downto 0)      -- OK, Zero, QNaN, Inf, InvOper
);
end entity speccase;
--------------------------------------------

architecture stuff of speccase is

signal i1_s:   std_logic;
signal i1_e:   std_logic_vector(10 downto 0);
signal i1_m:   std_logic_vector(51 downto 0);
signal i2_s:   std_logic;
signal i2_e:   std_logic_vector(10 downto 0);
signal i2_m:   std_logic_vector(51 downto 0);

signal i1f:   std_logic_vector(2 downto 0);
signal i2f:   std_logic_vector(2 downto 0);

begin
    
i1_s <= I1(63);
i1_e <= I1(62 downto 52);
i1_m <= I1(51 downto 0);
i2_s <= I1(63);
i2_e <= I2(62 downto 52);
i2_m <= I2(51 downto 0);

-----
process(i1_s, i1_e, i1_m)
begin
    if (i1_e = "00000000000") then
       i1f <= "000";                -- Zero
    elsif (i1_e = "11111111111") then
       if (i1_m = "0000000000000000000000000000000000000000000000000000") then
          i1f <= "100";             -- Infinity
       elsif ((i1_s = '0') and (i1_m = "1000000000000000000000000000000000000000000000000000")) then
           i1f <= "010";            -- Quiet NaN
       elsif ((i1_s = '0') and (i1_m = "0100000000000000000000000000000000000000000000000000")) then
           i1f <= "001";            -- Signaling NaN
       else
           i1f <= "011";            -- Other NaN
       end if;
    else
       i1f <= "111";
    end if;
end process;

process(i2_s, i2_e, i2_m)
begin
    if (i2_e = "00000000000") then
       i2f <= "000";                -- Zero
    elsif (i2_e = "11111111111") then
       if (i2_m = "0000000000000000000000000000000000000000000000000000") then
          i2f <= "100";             -- Infinity
       elsif ((i2_s = '0') and (i2_m = "1000000000000000000000000000000000000000000000000000")) then
           i2f <= "010";            -- Quiet NaN
       elsif ((i2_s = '0') and (i2_m = "0100000000000000000000000000000000000000000000000000")) then
           i2f <= "001";            -- Signaling NaN
       else
           i2f <= "011";            -- Other NaN - XNaN
       end if;
    else
       i2f <= "111";
    end if;
end process;

process(i1f, i2f)
begin
    if (i1f = "000") then                           -- i1f = Zero
        if    (i2f = "000") then FL <= "01000";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "01000";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00100";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00100";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00101";    -- i2f = Inf
        end if;
     elsif (i1f = "111") then                      -- i1f = OK
        if    (i2f = "000") then FL <= "01000";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "10000";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00100";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00100";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00010";    -- i2f = Inf
        end if;
     elsif (i1f = "001") then                      -- i1f = SNaN
        if    (i2f = "000") then FL <= "00101";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "00101";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00101";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00101";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00101";    -- i2f = Inf
        end if;
     elsif (i1f = "010") then                      -- i1f = QNaN
        if    (i2f = "000") then FL <= "00100";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "00100";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00100";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00100";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00100";    -- i2f = Inf
        end if;
     elsif (i1f = "011") then                      -- i1f = XNaN
        if    (i2f = "000") then FL <= "00100";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "00100";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00100";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00100";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00100";    -- i2f = Inf
        end if;
     elsif (i1f = "100") then                      -- i1f = Inf
        if    (i2f = "000") then FL <= "00101";    -- i2f = Zero
        elsif (i2f = "111") then FL <= "00010";    -- i2f = OK
        elsif (i2f = "001") then FL <= "00101";    -- i2f = SNaN
        elsif (i2f = "010") then FL <= "00100";    -- i2f = QNaN
        elsif (i2f = "011") then FL <= "00100";    -- i2f = XNaN
        elsif (i2f = "100") then FL <= "00010";    -- i2f = Inf
        end if;
end if;

end process;
    
end stuff;


-- Detect Exponent = zero
--i1ez <= not(i1_e(10) or i1_e(9) or i1_e(8) or i1_e(7) or i1_e(6) or i1_e(5) or i1_e(4) or i1_e(3) or i1_e(2) or i1_e(1) or i1_e(0));
--i2ez <= not(i2_e(10) or i2_e(9) or i2_e(8) or i2_e(7) or i2_e(6) or i2_e(5) or i2_e(4) or i2_e(3) or i2_e(2) or i2_e(1) or i2_e(0));
-- Detect Exponent = max
--i1em <= i1_e(10) and i1_e(9) and i1_e(8) and i1_e(7) and i1_e(6) and i1_e(5) and i1_e(4) and i1_e(3) and i1_e(2) and i1_e(1) and i1_e(0);
--i2em <= i2_e(10) and i2_e(9) and i2_e(8) and i2_e(7) and i2_e(6) and i2_e(5) and i2_e(4) and i2_e(3) and i2_e(2) and i2_e(1) and i2_e(0);
-- Detect Mantissa = zero
--i1mz <= not(i1_m(00) or i1_m(01) or i1_m(02) or i1_m(03) or i1_m(04) or i1_m(05) or i1_m(06) or i1_m(07) or i1_m(08) or i1_m(09) or i1_m(10) or i1_m(11) or i1_m(12) or i1_m(13) or i1_m(14) or i1_m(15) or i1_m(16) or i1_m(17) or i1_m(18) or i1_m(19) or i1_m(20) or i1_m(21) or i1_m(22) or i1_m(13) or i1_m(24) or i1_m(25) or i1_m(16) or i1_m(27) or i1_m(28) or i1_m(29) or i1_m(30) or i1_m(31) or i1_m(32) or i1_m(13) or i1_m(34) or i1_m(35) or i1_m(16) or i1_m(37) or i1_m(38) or i1_m(39) or i1_m(40) or i1_m(41) or i1_m(42) or i1_m(13) or i1_m(44) or i1_m(45) or i1_m(16) or i1_m(47) or i1_m(48) or i1_m(49) or i1_m(50) or i1_m(51));
--i2mz <= not(i2_m(00) or i2_m(01) or i2_m(02) or i2_m(03) or i2_m(04) or i2_m(05) or i2_m(06) or i2_m(07) or i2_m(08) or i2_m(09) or i2_m(10) or i2_m(11) or i2_m(12) or i2_m(13) or i2_m(14) or i2_m(15) or i2_m(16) or i2_m(17) or i2_m(18) or i2_m(19) or i2_m(20) or i2_m(21) or i2_m(22) or i2_m(13) or i2_m(24) or i2_m(25) or i2_m(16) or i2_m(27) or i2_m(28) or i2_m(29) or i2_m(30) or i2_m(31) or i2_m(32) or i2_m(13) or i2_m(34) or i2_m(35) or i2_m(16) or i2_m(37) or i2_m(38) or i2_m(39) or i2_m(40) or i2_m(41) or i2_m(42) or i2_m(13) or i2_m(44) or i2_m(45) or i2_m(16) or i2_m(47) or i2_m(48) or i2_m(49) or i2_m(50) or i2_m(51));
-----


