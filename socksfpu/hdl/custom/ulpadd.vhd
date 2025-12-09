-- Ulp Adder (Based on CLA)
-- Author: John Moskal
--  Created: 11-18-2004
-- Modified: 11-18-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity RFA is
port
(
   A:   in std_logic;
   B:   in std_logic;
   cin: in std_logic;
   p:   out std_logic;
   g:   out std_logic;
   R:   out std_logic  

);
end entity RFA;

architecture stuff of RFA is

signal p_w:   std_logic;
signal g_w:   std_logic;
signal r_w:   std_logic;

begin
    
    p_w <= A and B;
    p <= p_w;
    g_w <= A or B;
    g <= g_w;
    r_w <= (not p_w) and g_w;
    R <= (not(r_w and cin)) and (r_w or cin);
    
end stuff;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

-- Special Adder (RFA with B always assumed to be 0) - simpler logic and faster
entity SA is
port
(
   A:   in std_logic;
   cin: in std_logic;
   p:   out std_logic;
   R:   out std_logic  

);
end entity SA;

architecture stuff of SA is

signal a_w:   std_logic;
signal p_w:   std_logic;
signal r_w:   std_logic;

begin
    
    a_w <= A;
    p <= a_w;
    R <= (not(a_w and cin)) and (a_w or cin);
    
end stuff;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity bclg1s is
port
(
   cin: in std_logic;
   p:   in std_logic_vector(3 downto 0);
   c:   out std_logic_vector(2 downto 0);
   PP:   out std_logic
);
end entity bclg1s;

architecture stuff of bclg1s is

begin
    
c(0) <= p(0) and cin;
c(1) <= p(1) and p(0) and cin;
c(2) <= p(2) and p(1) and p(0) and cin;
PP <= p(3) and p(2) and p(1) and p(0);
    
end stuff;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity ulpadd is
port
(
   I:    in std_logic_vector(51 downto 0);
   ulp:  in std_logic;
   R:    out std_logic_vector(51 downto 0);
   cout: out std_logic
);
end entity ulpadd;

---------------------------------------------

architecture stuff of ulpadd is

component SA is
port
(
   A:   in std_logic;
   cin: in std_logic;
   p:   out std_logic;
   R:   out std_logic  

);
end component SA;

component bclg1s is
port
(
   cin: in std_logic;
   p:   in std_logic_vector(3 downto 0);
   c:   out std_logic_vector(2 downto 0);
   PP:   out std_logic
);
end component bclg1s;

signal cin_w: std_logic_vector(51 downto 0);
signal p_w:   std_logic_vector(51 downto 0);

signal PL1:   std_logic_vector(12 downto 0);
signal PL2:   std_logic_vector(03 downto 0);

signal co0:   std_logic_vector(2 downto 0);
signal co1:   std_logic_vector(2 downto 0);
signal co2:   std_logic_vector(2 downto 0);

signal cm:    std_logic_vector(2 downto 0);

signal P:     std_logic;

---------------------------------------------

begin

cin_w(0) <= ulp;

A00:   SA port map (I(00), cin_w(00), p_w(00), R(00));
A01:   SA port map (I(01), cin_w(01), p_w(01), R(01));
A02:   SA port map (I(02), cin_w(02), p_w(02), R(02));
A03:   SA port map (I(03), cin_w(03), p_w(03), R(03));

B00L1:   bclg1s port map(cin_w(00), p_w(03 downto 00), cin_w(03 downto 01), PL1(00));

A04:   SA port map (I(04), cin_w(04), p_w(04), R(04));
A05:   SA port map (I(05), cin_w(05), p_w(05), R(05));
A06:   SA port map (I(06), cin_w(06), p_w(06), R(06));
A07:   SA port map (I(07), cin_w(07), p_w(07), R(07));

B01L1:   bclg1s port map(cin_w(04), p_w(07 downto 04), cin_w(07 downto 05), PL1(01));

A08:   SA port map (I(08), cin_w(08), p_w(08), R(08));
A09:   SA port map (I(09), cin_w(09), p_w(09), R(09));
A10:   SA port map (I(10), cin_w(10), p_w(10), R(10));
A11:   SA port map (I(11), cin_w(11), p_w(11), R(11));

B02L1:   bclg1s port map(cin_w(08), p_w(11 downto 08), cin_w(11 downto 09), PL1(02));

A12:   SA port map (I(12), cin_w(12), p_w(12), R(12));
A13:   SA port map (I(13), cin_w(13), p_w(13), R(13));
A14:   SA port map (I(14), cin_w(14), p_w(14), R(14));
A15:   SA port map (I(15), cin_w(15), p_w(15), R(15));

B03L1:   bclg1s port map(cin_w(12), p_w(15 downto 12), cin_w(15 downto 13), PL1(03));

B00L2:   bclg1s port map(cin_w(0), PL1(03 downto 00), co0, PL2(00));
cin_w(12) <= co0(2);
cin_w(08) <= co0(1);
cin_w(04) <= co0(0);

----

A16:   SA port map (I(16), cin_w(16), p_w(16), R(16));
A17:   SA port map (I(17), cin_w(17), p_w(17), R(17));
A18:   SA port map (I(18), cin_w(18), p_w(18), R(18));
A19:   SA port map (I(19), cin_w(19), p_w(19), R(19));

B04L1:   bclg1s port map(cin_w(16), p_w(19 downto 16), cin_w(19 downto 17), PL1(04));

A20:   SA port map (I(20), cin_w(20), p_w(20), R(20));
A21:   SA port map (I(21), cin_w(21), p_w(21), R(21));
A22:   SA port map (I(22), cin_w(22), p_w(22), R(22));
A23:   SA port map (I(23), cin_w(23), p_w(23), R(23));

B05L1:   bclg1s port map(cin_w(20), p_w(23 downto 20), cin_w(23 downto 21), PL1(05));

A24:   SA port map (I(24), cin_w(24), p_w(24), R(24));
A25:   SA port map (I(25), cin_w(25), p_w(25), R(25));
A26:   SA port map (I(26), cin_w(26), p_w(26), R(26));
A27:   SA port map (I(27), cin_w(27), p_w(27), R(27));

B06L1:   bclg1s port map(cin_w(24), p_w(27 downto 24), cin_w(27 downto 25), PL1(06));

A28:   SA port map (I(28), cin_w(28), p_w(28), R(28));
A29:   SA port map (I(29), cin_w(29), p_w(29), R(29));
A30:   SA port map (I(30), cin_w(30), p_w(30), R(30));
A31:   SA port map (I(31), cin_w(31), p_w(31), R(31));

B07L1:   bclg1s port map(cin_w(28), p_w(31 downto 28), cin_w(31 downto 29), PL1(07));

B01L2:   bclg1s port map(cin_w(16), PL1(07 downto 04), co1, PL2(01));
cin_w(28) <= co1(2);
cin_w(24) <= co1(1);
cin_w(20) <= co1(0);

---

A32:   SA port map (I(32), cin_w(32), p_w(32), R(32));
A33:   SA port map (I(33), cin_w(33), p_w(33), R(33));
A34:   SA port map (I(34), cin_w(34), p_w(34), R(34));
A35:   SA port map (I(35), cin_w(35), p_w(35), R(35));

B08L1:   bclg1s port map(cin_w(32), p_w(35 downto 32), cin_w(35 downto 33), PL1(08));

A36:   SA port map (I(36), cin_w(36), p_w(36), R(36));
A37:   SA port map (I(37), cin_w(37), p_w(37), R(37));
A38:   SA port map (I(38), cin_w(38), p_w(38), R(38));
A39:   SA port map (I(39), cin_w(39), p_w(39), R(39));

B09L1:   bclg1s port map(cin_w(36), p_w(39 downto 36), cin_w(39 downto 37), PL1(09));

A40:   SA port map (I(40), cin_w(40), p_w(40), R(40));
A41:   SA port map (I(41), cin_w(41), p_w(41), R(41));
A42:   SA port map (I(42), cin_w(42), p_w(42), R(42));
A43:   SA port map (I(43), cin_w(43), p_w(43), R(43));

B10L1:   bclg1s port map(cin_w(40), p_w(43 downto 40), cin_w(43 downto 41), PL1(10));

A44:   SA port map (I(44), cin_w(44), p_w(44), R(44));
A45:   SA port map (I(45), cin_w(45), p_w(45), R(45));
A46:   SA port map (I(46), cin_w(46), p_w(46), R(46));
A47:   SA port map (I(47), cin_w(47), p_w(47), R(47));

B11L1:   bclg1s port map(cin_w(44), p_w(47 downto 44), cin_w(47 downto 45), PL1(11));

B02L2:   bclg1s port map(cin_w(32), PL1(11 downto 08), co2, PL2(02));
cin_w(44) <= co2(2);
cin_w(40) <= co2(1);
cin_w(36) <= co2(0);

---

A48:   SA port map (I(48), cin_w(48), p_w(48), R(48));
A49:   SA port map (I(49), cin_w(49), p_w(49), R(49));
A50:   SA port map (I(50), cin_w(50), p_w(50), R(50));
A51:   SA port map (I(51), cin_w(51), p_w(51), R(51));
    
B12L1:   bclg1s port map(cin_w(48), p_w(51 downto 48), cin_w(51 downto 49), PL1(12));

PL2(03) <= PL1(12);

--------

BL3:   bclg1s port map(cin_w(0), PL2(03 downto 00), cm, P);
cin_w(16) <= cm(0);
cin_w(32) <= cm(1);
cin_w(48) <= cm(2);

---

cout <= P and cin_w(0);

end stuff;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

