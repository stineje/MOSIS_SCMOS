-- Sticky Bit Generation Unit
-- Author: John Moskal
--  Created: 11-12-2004
-- Modified: 11-14-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity sticky is
port
(
   I:     in std_logic_vector(81 downto 0);    -- Input
   SEL:   in std_logic;                        -- Select (MSB of result from MULT)
   SDP:   in std_logic;                        -- Single (0) or Double (1) Precision Select
   T:     out std_logic;                       -- Sticky (for Double Precision)
   InX:   out std_logic                        -- Inexact Exception
);
end entity sticky;
--------------------------------------------
architecture stuff of sticky is
    
signal TD1_w:   std_logic;
signal TS1_w:   std_logic;
signal TD2_w:   std_logic;
signal TS2_w:   std_logic;

signal T_w:     std_logic;   -- Sticky Bit
signal G_w:     std_logic;   -- Guard Bit

begin

TD1_w <= I(00) or I(01) or I(02) or I(03) or I(04) or I(05) or I(06) or I(07) or I(08) or I(09) or
         I(10) or I(11) or I(12) or I(13) or I(14) or I(15) or I(16) or I(17) or I(18) or I(19) or
         I(20) or I(21) or I(22) or I(23) or I(24) or I(25) or I(26) or I(27) or I(28) or I(29) or
         I(30) or I(31) or I(32) or I(33) or I(34) or I(35) or I(36) or I(37) or I(38) or I(39) or
         I(40) or I(41) or I(42) or I(43) or I(44) or I(45) or I(46) or I(47) or I(48) or I(49) or
         I(50);

TD2_w <= ((not SEL) and TD1_w) or (SEL and (TD1_w or I(51)));

TS1_w <= TD1_w or I(51) or I(52) or I(53) or I(54) or I(55) or I(56) or I(57) or I(58) or I(59) or
         I(60) or I(61) or I(62) or I(63) or I(64) or I(65) or I(66) or I(67) or I(68) or I(69) or
         I(70) or I(71) or I(72) or I(73) or I(74) or I(75) or I(76) or I(77) or I(78) or I(79);

TS2_w <= ((not SEL) and TS1_w) or (SEL and (TS1_w or I(80)));

T_w <= ((not SDP) and TS2_w) or (SDP and TD2_w);

G_w <= ((not SDP) and (not SEL) and I(51)) or ((not SDP) and SEL and I(52)) or (SDP and (not SEL) and I(80)) or (SDP and SEL and I(81));

T <= T_w;
InX <= T_w or G_w;

end stuff;

