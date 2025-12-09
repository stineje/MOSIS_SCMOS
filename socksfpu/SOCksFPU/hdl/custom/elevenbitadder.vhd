LIBRARY ieee;
Use ieee.std_logic_1164.all;

Entity elevenbitadder is
	Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
	      Cin : in STD_LOGIC;
	      Z : out STD_LOGIC_VECTOR(10 downto 0));
end elevenbitadder;

architecture struct of elevenbitadder is


  component fourbitcarryblock
  Port( PIn, GIn : in std_logic_vector(3 downto 0);
        CIn : in std_logic;
        COut : out std_logic_vector(3 downto 1);
        POut, GOut : out std_logic);
  end component;

  component threebitcarryblock
  port(PIn, GIn : in std_logic_vector(2 downto 0);
       CIn : in std_logic;
       COut : out std_logic_vector(2 downto 1);
       POut, GOut : out std_logic);
  end component;

	signal P, G : STD_LOGIC_VECTOR(10 downto 0);
	signal Pout, Gout, Cout : STD_LOGIC_VECTOR(2 downto 0);
	signal Aten_not, temp1, temp2, DOVF, SOVF: STD_LOGIC;
	signal C : STD_LOGIC_VECTOR(10 downto 0);

begin

	C(0) <= Cin;

	P(0) <= A(0) xor B(0);
	P(1) <= A(1) xor B(1);
	P(2) <= A(2) xor B(2);
	P(3) <= A(3) xor B(3);
	P(4) <= A(4) xor B(4);
	P(5) <= A(5) xor B(5);
	P(6) <= A(6) xor B(6);
	P(7) <= A(7) xor B(7);
	P(8) <= A(8) xor B(8);
	P(9) <= A(9) xor B(9);
	P(10) <= A(10) xor B(10);
	
	G(0) <= A(0) and B(0);
	G(1) <= A(1) and B(1);
	G(2) <= A(2) and B(2);
	G(3) <= A(3) and B(3);
	G(4) <= A(4) and B(4);
	G(5) <= A(5) and B(5);
	G(6) <= A(6) and B(6);
	G(7) <= A(7) and B(7);
	G(8) <= A(8) and B(8);
	G(9) <= A(9) and B(9);
	G(10) <= A(10) and B(10);

	CG_0_3 : fourbitcarryblock port map(P(3 downto 0), G(3 downto 0), C(0), C(3 downto 1), Pout(0), Gout(0));
	CG_4_7 : fourbitcarryblock port map(P(7 downto 4), G(7 downto 4), C(4), C(7 downto 5), Pout(1), Gout(1));
	CG_8_10 : threebitcarryblock port map(P(10 downto 8), G(10 downto 8), C(8), C(10 downto 9), Pout(2), Gout(2));

	CG_lvl2 : threebitcarryblock port map(Pout(2 downto 0), Gout(2 downto 0), C(0), Cout(1 downto 0), temp1, temp2);

	C(4) <= Cout(0);
	C(8) <= Cout(1);

	Z(0) <= P(0) xor C(0);
	Z(1) <= P(1) xor C(1);
	Z(2) <= P(2) xor C(2);
	Z(3) <= P(3) xor C(3);
	Z(4) <= P(4) xor C(4);
	Z(5) <= P(5) xor C(5);
	Z(6) <= P(6) xor C(6);
	Z(7) <= P(7) xor C(7);
	Z(8) <= P(8) xor C(8);
	Z(9) <= P(9) xor C(9);
	Z(10) <= P(10) xor C(10);

end struct;

