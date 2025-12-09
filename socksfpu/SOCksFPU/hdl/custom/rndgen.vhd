-- Round Bit Generator
-- Author: John Moskal
--  Created: 11-12-2004
-- Modified: 11-14-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------
--
-- RM  Scheme
-- 00  Round to nearest even
-- 01  Round to zero
-- 10  Round toward +Inf
-- 11  Round toward -Inf
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity rndgen is
port
(
   S:   in std_logic;                     -- Sign
   L:   in std_logic;                     -- LSB
   G:   in std_logic;                     -- Guard
   T:  in std_logic;                      -- Sticky
   RM:  in std_logic_vector(1 downto 0);  -- Round Mode
   R:   out std_logic                     -- Round result
);
end entity rndgen;
--------------------------------------------

architecture stuff of rndgen is


begin
        
R <= (RM(1) and RM(0) and S and G) or
     (RM(1) and (not RM(0)) and (not S) and G) or
     ((not RM(1)) and (not RM(0)) and L and G) or
     (RM(1) and RM(0) and S and T) or
     (RM(1) and (not RM(0)) and (not S) and T) or
     ((not RM(1)) and (not RM(0)) and G and T);

end stuff;



