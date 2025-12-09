LIBRARY ieee;
Use ieee.std_logic_1164.all;

entity addextra is

  port( Zin : in STD_LOGIC_VECTOR(10 downto 0);
	OVFin, DenInc, RoundInc, DS, Aten, Bten : in STD_LOGIC;
	Zout : out STD_LOGIC_VECTOR(10 downto 0);
	OVFout, UDFout : out STD_LOGIC);

end addextra;

architecture struct of addextra is

component elevenbitadder
	Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
	      Cin : in STD_LOGIC;
	      Z : out STD_LOGIC_VECTOR(10 downto 0));
end component;    

signal TempB, TempZ  : STD_LOGIC_VECTOR(10 downto 0);
signal Cin, INFa, INFb, ZEROa, ZEROb : STD_LOGIC; 
  begin  

	TempB(0) <= DenInc;
	TempB(10 downto 1) <= "0000000000";


	Cin <= RoundInc;

	adder: elevenbitadder port map(Zin, TempB, Cin, TempZ);

        INFa <= TempZ(0) and TempZ(1) and TempZ(2) and TempZ(3) and TempZ(4) and TempZ(5) and TempZ(6) and TempZ(7) and TempZ(8) and TempZ(9) and TempZ(10);
        INFb <= TempZ(0) and TempZ(1) and TempZ(2) and TempZ(3) and TempZ(4) and TempZ(5) and TempZ(6) and not(TempZ(7)) and not(TempZ(8)) and not(TempZ(9)) and TempZ(10);
        
        ZEROa <= not(TempZ(0)) and not(TempZ(1)) and not(TempZ(2)) and not(TempZ(3)) and not(TempZ(4)) and not(TempZ(5)) and not(TempZ(6)) and not(TempZ(7)) and not(TempZ(8)) and not(TempZ(9)) and not(TempZ(10));
        ZEROb <= not(TempZ(0)) and not(TempZ(1)) and not(TempZ(2)) and not(TempZ(3)) and not(TempZ(4)) and not(TempZ(5)) and not(TempZ(6)) and TempZ(7) and TempZ(8) and TempZ(9) and not(TempZ(10));

   -- overflow occurs if the input goes from Z > bias to being Z < bias
   -- which we have check before, and this checks the second addition as
   -- well as checking to see if we hit infinity in the end
   -- for double we do not want our output no larger than 10001111111
   -- our overflow range will be 10010000000 < # < 10011111111 and infinity
	OVFout <= OVFin or 
		  (DS and (((not TempZ(10)) and Zin(10)) or INFa)) or 
		  ((not DS) and ((TempZ(10) and TempZ(7)) or INFb));
		  
	-- underflow occurs if A <= bias and B <= bias but result is Z > bias
	-- I waited to this point knowing that if  there was underflow in the 
	-- previous stage it could be corrected by the addition of these two bits
	-- in single precision we are just worried about the result being no lower
	-- than 01110000001. knowing the underflow result is in between 
	-- 01101111111 >= # >= 01100000011 or zero
	UDFout <= (DS and (((not Aten) and (not Bten) and TempZ(10)) or ZEROa)) or 
		  ((not DS) and ((not TempZ(10) and (not TempZ(7))) or ZEROb));

	Zout(10 downto 0) <= TempZ(10 downto 0);

end struct;

