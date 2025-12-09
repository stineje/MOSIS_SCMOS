library IEEE; 
use IEEE.std_logic_1164.all; 

entity half_adder is
	port(	A : in  std_logic;
		CIN : in  std_logic;
		S : out std_logic;
                COUT : out std_logic);
end half_adder;

architecture Structure of half_adder is

begin

  S <= A xor CIN;
  COUT <= A and CIN;


end Structure;

