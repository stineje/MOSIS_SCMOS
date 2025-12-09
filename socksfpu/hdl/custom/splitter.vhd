-- Split DP number into S, E, M
-- Author: John Moskal
--  Created: 11-19-2004
-- Modified: 11-19-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity splitter is
port
(
   I:   in std_logic_vector(63 downto 0);
   S:   out std_logic;
   E:   out std_logic_vector(10 downto 0);
   M:   out std_logic_vector(51 downto 0)
);
end entity splitter;
--------------------------------------------

architecture stuff of splitter is
begin
    
S <= I(63);
E <= I(62 downto 52);
M <= I(51 downto 0);

end stuff;

