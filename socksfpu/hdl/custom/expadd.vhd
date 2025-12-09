LIBRARY ieee;
Use ieee.std_logic_1164.all;

entity ExpAdd is

  port(A, B : in STD_LOGIC_VECTOR(10 downto 0);
	DS, RoundInc, DenInc, S, TDE : in STD_LOGIC;
	Z : out STD_LOGIC_VECTOR(10 downto 0);
	OVF, UDF, TrapSet : out STD_LOGIC);

end ExpAdd;

architecture struct of ExpAdd is

component AplusBminusBias
	  Port( A, B : in STD_LOGIC_VECTOR(10 downto 0);
          DS : in STD_LOGIC;
          Z : out STD_LOGIC_VECTOR(10 downto 0);
	  OVFa : out STD_LOGIC);
end component;    

component addextra
  port( Zin : in STD_LOGIC_VECTOR(10 downto 0);
	OVFin, DenInc, RoundInc, DS, Aten, Bten : in STD_LOGIC;
	Zout : out STD_LOGIC_VECTOR(10 downto 0);
	OVFout, UDFout : out STD_LOGIC);
end component;  

component EminusAlpha is
  port( Zin : in STD_LOGIC_VECTOR(10 downto 0);
	OVFin, UDFin, DS : in STD_LOGIC;
	Zout : out STD_LOGIC_VECTOR(10 downto 0));
end component;

signal Za, Zb, Zc : STD_LOGIC_VECTOR(10 downto 0);
signal OVFa, OVFb, UDFa : STD_LOGIC;

begin

stage1: AplusBminusBias port map(A, B, DS, Za, OVFa);
stage2: addextra port map(Za, OVFa, DenInc, RoundInc, DS, A(10), B(10), Zb, OVFb, UDFa);
stage3: EminusAlpha port map(Zb, OVFb, UDFa, DS, Zc);

Z(10 downto 0) <= Zc(10 downto 0);
OVF <= OVFb;
UDF <= UDFa;
TrapSet <= (OVFb or UDFa) and TDE;

end struct;

