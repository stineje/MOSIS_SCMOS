library IEEE; 
use IEEE.std_logic_1164.all; 

entity and2 is
	port(	X : in  std_logic;
		Y : in  std_logic;
		O : out std_logic);
end and2;

architecture Structure of and2 is

begin

	O <= X and Y;


end Structure;

