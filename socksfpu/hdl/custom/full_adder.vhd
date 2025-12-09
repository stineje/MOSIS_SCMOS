library IEEE; 
use IEEE.std_logic_1164.all; 

entity full_adder is
	port(	A : in  std_logic;
                B : in  std_logic;
		CIN : in  std_logic;
		S : out std_logic;
                COUT : out std_logic);
end full_adder;

architecture Structure of full_adder is

  signal NET1 : std_logic;
  signal NET2 : std_logic;
  signal NET3 : std_logic;
  signal NET4 : std_logic;

  
begin


  NET1 <= A xor B;
  S <= NET1 xor CIN;



  NET2 <= A and B;
  NET3 <= A and CIN;
  NET4 <= B and CIN;

  COUT <= NET2 or NET3 or NET4;
  
  

end Structure;

