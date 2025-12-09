LIBRARY ieee;
Use ieee.std_logic_1164.all;

Entity AplusBminusBias is
	Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
	          DS : in STD_LOGIC;
	          Z : out STD_LOGIC_VECTOR(10 downto 0);
	          OVFa : out STD_LOGIC);
end AplusBminusBias;

architecture struct of AplusBminusBias is

component elevenbitadder
	Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
	      Cin : in STD_LOGIC;
	      Z : out STD_LOGIC_VECTOR(10 downto 0));
end component;

signal Cin, Anot : STD_LOGIC;
signal TempA, TempZ: STD_LOGIC_VECTOR(10 downto 0);

begin

	Cin <= '1';

	TempA(9 downto 0) <= A(9 downto 0);
	TempA(10) <= not(A(10));

	Adder : elevenbitadder port map (TempA, B, Cin, TempZ);

   -- overflow initially detected if A > bias and B > bias and result < bias
   -- in double precision this is shown with bit 10 being one or zero
   -- in single precision this is shown by seing if the result is bigger than 10011111111
   -- in single precision the overflow result will obly be between: 
   -- 10001111111 <= # <= 10011111101 so only need to check bits 10 and 8 and case 10011111111 checked later
	OVFa <= (not(DS) and (TempZ(10) and TempZ(7))) or (DS and (A(10) and B(10) and (not TempZ(10))));

	Z(10 downto 0) <= TempZ(10 downto 0);
	
end struct;

