-- Muxes
-- Author: John Moskal
--  Created: 11-12-2004
-- Modified: 11-19-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
port
(
   Input1:   in std_logic;
   Input2:   in std_logic;
   Sel:      in std_logic;
   Output:   out std_logic
);
end entity mux2to1;
--------------------------------------------

architecture stuff of mux2to1 is
begin
    
   Output <= ((not Sel) and Input1) or (Sel and Input2);

end stuff;

-----------------------------------------------------------------------
-----------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1x64 is
port
(
   Input1:   in std_logic_vector(63 downto 0);
   Input2:   in std_logic_vector(63 downto 0);
   Sel:      in std_logic;
   Output:   out std_logic_vector(63 downto 0)
);
end entity mux2to1x64;
--------------------------------------------

architecture stuff of mux2to1x64 is
begin

mux: process(Sel, Input1, Input2)
begin
   if(Sel = '0') then 
      Output <= Input1;
   else
      Output <= Input2;
   end if;   
end process mux;

end stuff;

-----------------------------------------------------------------------
-----------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1x11 is
port
(
   Input1:   in std_logic_vector(10 downto 0);
   Input2:   in std_logic_vector(10 downto 0);
   Sel:      in std_logic;
   Output:   out std_logic_vector(10 downto 0)
);
end entity mux2to1x11;
--------------------------------------------

architecture stuff of mux2to1x11 is
begin

mux: process(Sel, Input1, Input2)
begin
   if(Sel = '0') then 
      Output <= Input1;
   else
      Output <= Input2;
   end if;   
end process mux;

end stuff;


