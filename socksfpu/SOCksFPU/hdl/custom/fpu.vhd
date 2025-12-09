-- Postnormalization and Rounding (Higher Level)
-- Author: John Moskal
--  Created: 11-12-2004
-- Modified: 11-21-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity fpu is
port
(
   A, B:      in std_logic_vector(63 downto 0);   -- opperands
   SDP:   in std_logic;                        -- Single (0) or Double (1) Precision Select
   RM:    in std_logic_vector(1 downto 0);    -- rounding mode
   TDE:    in std_logic;             -- trap enable (1) or disable (0)
   Result:   out std_logic_vector(63 downto 0);
   OVF:   out std_logic;
   UDF:   out std_logic;
   DivZero:    out std_logic;
   Invalid:   out std_logic;
   Inexact:   out std_logic
);
end entity fpu;
--------------------------------------------
architecture stuff of fpu is

--- COMPONENTS -----------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

component sng2dbl is
port
(
        S:   in std_logic_vector(31 downto 0);
        D:   out std_logic_vector(63 downto 0)
);
end component sng2dbl;

  
component mux2to1x64 is
port
(
   Input1:   in std_logic_vector(63 downto 0);
   Input2:   in std_logic_vector(63 downto 0);
   Sel:      in std_logic;
   Output:   out std_logic_vector(63 downto 0)
);
end component mux2to1x64;

component speccase is
port
(
   I1:   in std_logic_vector(63 downto 0);
   I2:   in std_logic_vector(63 downto 0);
   FL:   out std_logic_vector(4 downto 0)      -- OK, Zero, QNaN, Inf, InvOper
);
end component speccase;

  
component Mult53 is
        port(   Y : in  std_logic_vector(51 downto 0);
                X : in  std_logic_vector(51 downto 0);
                P : out std_logic_vector(105 downto 0));
end component Mult53;

  
component postnorm is
port
(
   I:   in std_logic_vector(53 downto 0);   -- Input
   SEL: in std_logic;                       -- mux Select
   SDP: in std_logic;                       -- Single (0) or Double (1) Precision Select
   O:   out std_logic_vector(51 downto 0);  -- Normalized Result
   L:   out std_logic;                      -- LSB
   G:   out std_logic                       -- Guard bit
);
end component postnorm;

component sticky is
port
(
   I:     in std_logic_vector(81 downto 0);    -- Input
   SEL:   in std_logic;                        -- Select (MSB of result from MULT)
   SDP:   in std_logic;                        -- Single (0) or Double (1) Precision Select
   T:     out std_logic;                       -- Sticky (for Double Precision)
   InX:   out std_logic                        -- Inexact Exception
);
end component sticky;

component rndgen is
port
(
   S:   in std_logic;                     -- Sign
   L:   in std_logic;                     -- LSB
   G:   in std_logic;                     -- Guard
   T:   in std_logic;                     -- Sticky
   RM:  in std_logic_vector(1 downto 0);  -- Rou1nd Mode
   R:   out std_logic                     -- Round result
);
end component rndgen;

component rndunit is
port
(
   I:      in std_logic_vector(51 downto 0);   -- Unrounded result (from Normalizing Unit)
   RND:    in std_logic;                       -- Round bit (from Round Bit Generator)
   SDP:    in std_logic;                       -- Single (0) or Double (1) Precision Select
   O:      out std_logic_vector(51 downto 0);  -- Rounded result (not truncated for SP)
   RndOvf: out std_logic                       -- Ulp Adder Overflow (Increase Exponent)
);
end component rndunit;

component specoutput is
port
(
   S:    in std_logic;                        -- Sign
   E:    in std_logic_vector(10 downto 0);    --1 Exponent
   M:    in std_logic_vector(51 downto 0);    -- Mantissa
   SV:   in std_logic_vector(2 downto 0);     -- Special Value
   TDE:  in std_logic;                        -- Trap Disabled/Enabled
   SDP:  in std_logic;                        -- precision
   RM:   in std_logic_vector(1 downto 0);     -- Rounding Mode
   O:    out std_logic_vector(63 downto 0)    -- Result in DP
);
end component specoutput;

component dbl2sng is
port
(
   I:   in std_logic_vector(63 downto 0);
   SDP: in std_logic;
   Infinity: in std_logic;
   Zero: in std_logic;
   O:   out std_logic_vector(63 downto 0)
);
end component dbl2sng;

component ExpAdd 

  port(A, B : in STD_LOGIC_VECTOR(10 downto 0);
	DS, RoundInc, DenInc, S, TDE : in STD_LOGIC;
	Z : out STD_LOGIC_VECTOR(10 downto 0);
	OVF, UDF, TrapSet : out STD_LOGIC);

end component;

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

signal RegAS, RegBS : std_logic_vector(63 downto 0);  -- From SingleToDouble Converter
signal OpA, OpB: std_logic_vector(63 downto 0);         -- From MUXes
signal Special: std_logic_vector(4 downto 0);           -- From Special Case Detector

signal AMulB:   std_logic_vector(105 downto 0);         -- From multiplier

signal RNORM_w:  std_logic_vector(51 downto 0);    -- Normalized, not rounded
signal L_w:      std_logic;                        -- LSB
signal G_w:      std_logic;                        -- Guard bit
signal T_w:      std_logic;                        -- Sticky bit
signal InEx_w:   std_logic;                        -- Inexact
signal RND_W:    std_logic;                        -- Round bit (from Round Bit Generator)

signal Sign:      std_logic;                        -- sign result
signal Exp:      std_logic_vector(10 downto 0);     -- exponent result 

signal trapset:  std_logic;                        

signal INF:      std_logic;                        -- Infinite result 
signal ZERO:     std_logic;                        -- Zero result
signal SpVal:    std_logic_vector(2 downto 0);     -- 3 bit special cases info     

signal Mant:     std_logic_vector(51 downto 0);    -- Mantissa
signal SOResult: std_logic_vector(63 downto 0);    -- Special Output Result

signal tempA, tempB, tempAX, tempBX: 	std_logic_vector(63 downto 0);

signal OVF_w:    std_logic;
signal UDF_w:    std_logic;
signal ROvf:     std_logic;

--------------------------------------------

begin

Sign <= A(63) xor B(63);

INF <= Special(1);

ZERO <= Special(3);

SPECIN: speccase port map(A, B, Special);

MUL:    Mult53 port map(tempAX(51 downto 0), tempBX(51 downto 0), AMulB);

convertA: 	sng2dbl port map(A(63 downto 32), tempA);
convertB:  sng2dbl port map(B(63 downto 32), tempB);

M1:	mux2to1x64 port map(tempA, A, SDP, tempAX);
M2:	mux2to1x64 port map(tempB, B, SDP, tempBX);

EXPMOD:   ExpAdd port map(tempAX(62 downto 52), tempBX(62 downto 52), SDP, ROvf, AMulB(105), Sign, TDE, Exp, OVF_w, UDF_w, TrapSet);

process (Special, UDF_w, OVF_w, TDE, InEx_w)
    begin
        if (Special(3)='1') then
         SpVal <= "001";
        elsif (UDF_w='1' and TDE='0') then
         SpVal <= "010";
        elsif (OVF_w='1' and TDE='0') then
         SpVal <= "011";
        elsif (Special(2)='1') then
         SpVal <= "100";
        elsif (Special(1)='1') then
           SpVal <= "101";
        else
           SpVal <= "000"; 
   end if;       
end process;    

ST:   sticky port map(AMulB(81 downto 0), AMulB(105), SDP, T_w, InEx_w);
NU:   postnorm port map(AMulB(104 downto 51), AMulB(105), SDP, RNORM_w, L_w, G_w);
RG:   rndgen port map(Sign, L_w, G_w, T_w, RM, RND_w);
RU:   rndunit port map(RNORM_w, RND_w, SDP, Mant, ROvf);
SO:   specoutput port map(Sign, Exp, Mant, SpVal, TDE, SDP, RM, SOResult);
DS:   dbl2sng port map(SOResult, SDP, INF, ZERO, Result);

Inexact <= InEx_w or (not TDE and (UDF_w or OVF_w));
OVF <=OVF_w and not((not(SpVal(2)) and not(SpVal(1)) and SpVal(0)) or (SpVal(2) and not(SpVal(1)) and not(SpVal(0))) or (SpVal(2) and not(SpVal(1)) and SpVal(0)));
UDF <=UDF_w and not((not(SpVal(2)) and not(SpVal(1)) and SpVal(0)) or (SpVal(2) and not(SpVal(1)) and not(SpVal(0))) or (SpVal(2) and not(SpVal(1)) and SpVal(0)));
DivZero <= '0';
Invalid <= Special(0);
end stuff;

