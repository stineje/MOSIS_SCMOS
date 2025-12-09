LIBRARY ieee;
Use ieee.std_logic_1164.all;

entity EminusAlpha is

  port( Zin : in STD_LOGIC_VECTOR(10 downto 0);
	OVFin, UDFin, DS : in STD_LOGIC;
	Zout : out STD_LOGIC_VECTOR(10 downto 0));

end EminusAlpha;

architecture struct of EminusAlpha is

component elevenbitadder
	Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
	      Cin : in STD_LOGIC;
	      Z : out STD_LOGIC_VECTOR(10 downto 0));
end component;    

signal TempB : STD_LOGIC_VECTOR(10 downto 0);
signal Cin   : STD_LOGIC;
  begin  
	
	setB: process( DS, OVFin, UDFin)
	begin
		if (DS = '0' and OVFin = '1') then
			TempB <= "11101000000";
		elsif (DS = '0' and UDFin = '1') then
			TempB <= "00011000000";
		elsif (DS = '1' and OVFin = '1') then
			TempB <= "01000000000";
		elsif (DS = '1' and UDFin = '1') then
			TempB <= "00011000000";
		else
			TempB <= "00000000000";
		end if;
	end process setB;
	
	Cin <= '0';
	
	adder: elevenbitadder port map (Zin, TempB, Cin, Zout);

  end struct;

