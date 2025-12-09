-- Double to Single conversion
-- (!!! NOTHING FANCY - JUST SIGNAL REARRANGEMENT !!! )
-- All logic has to be done in earlier stages.
--
-- Author: John Moskal
--  Created: 11-21-2004
-- Modified: 11-21-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity dbl2sng is
port
(
   I:   in std_logic_vector(63 downto 0);
   SDP: in std_logic;
   Infinity: in std_logic;
   Zero: in std_logic;
   O:   out std_logic_vector(63 downto 0)
);
end entity dbl2sng;
--------------------------------------------

architecture stuff of dbl2sng is

begin

process(I, SDP)
begin

   if (SDP = '0') then
       O(63) <= I(63);
       O(62) <= I(62);
       O(61 downto 55) <= I(58 downto 52);
       O(54 downto 32) <= I(51 downto 29);
       O(31 downto 0) <= "00000000000000000000000000000000";
       
   
   
   else
       O <= I;
   end if;    
end process;        

end stuff;

-----------------------------------------------------------------------
-----------------------------------------------------------------------

