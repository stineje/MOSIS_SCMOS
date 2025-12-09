-- Rounding Unit
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

entity rndunit is
port
(
   I:      in std_logic_vector(51 downto 0);   -- Unrounded result (from Normalizing Unit)
   RND:    in std_logic;                       -- Round bit (from Round Bit Generator)
   SDP:    in std_logic;                       -- Single (0) or Double (1) Precision Select
   O:      out std_logic_vector(51 downto 0);  -- Rounded result (not truncated for SP)
   RndOvf: out std_logic                       -- Ulp Adder Overflow (Increase Exponent)
);
end entity rndunit;
--------------------------------------------

architecture stuff of rndunit is

component ulpadd is
port
(
   I:    in std_logic_vector(51 downto 0);
   ulp:  in std_logic;
   R:    out std_logic_vector(51 downto 0);
   cout: out std_logic
);
end component ulpadd;

signal R_w: std_logic_vector(51 downto 0);

begin

uadd: ulpadd port map(I, RND, R_w, RndOvf);

process(SDP, R_w)
begin
    if (SDP='1') then
        O <= R_w(51 downto 0);
    else
       O(51 downto 29) <= R_w(51 downto 29);
       O(28 downto 0) <= "00000000000000000000000000000";
    end if;
end process;
    
end stuff;

