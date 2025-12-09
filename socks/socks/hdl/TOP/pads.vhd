library IEEE;
use IEEE.std_logic_1164.all;

entity PCI66DGZ is
port ( EN   : in std_logic;
       A     : in std_logic;
       PAD   : inout std_logic;
       Y     : out std_logic
     );
end;

architecture rtl of PCI66DGZ is
begin

     PAD <= A when EN = '0' else 'Z';
     Y   <= PAD;

end;

-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity PDO08CDG is
port ( PAD : out std_logic;
       A   : in  std_logic
     );
end;

architecture rtl of PDO08CDG is

begin

    PAD <= A;

end;

-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity PDUDGZ is
port ( PAD : in std_logic;
       Y   : out std_logic
     );
end;

architecture rtl of PDUDGZ is
begin

     Y <= PAD;
end;

-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity PVDDDGZ is

end;

architecture rtl of PVDDDGZ is
begin
end;

-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity PVSSDGZ is

end;

architecture rtl of PVSSDGZ is
begin
end;

-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity PCORNER is

end;

architecture rtl of PCORNER is
begin
end;


