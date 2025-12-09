library IEEE; 
use IEEE.std_logic_1164.all; 

entity Mult53 is
	port(	Y : in  std_logic_vector(51 downto 0);
		X : in  std_logic_vector(51 downto 0);
		P : out std_logic_vector(105 downto 0));
end Mult53;

architecture Structure of Mult53 is

component Dadda53 is
	port(	Y : in  std_logic_vector(51 downto 0);
		X : in  std_logic_vector(51 downto 0);
		S : out std_logic_vector(105 downto 0);
		C : out std_logic_vector(105 downto 0));
end component;

component full_adder 
	port(	A : in  std_logic;
                B : in  std_logic;
		CIN : in  std_logic;
		S : out std_logic;
                COUT : out std_logic);
end component;

component half_adder 
	port(	A : in  std_logic;
		CIN : in  std_logic;
		S : out std_logic;
                COUT : out std_logic);
end component;

       signal S : std_logic_vector(105 downto 0);
       signal C : std_logic_vector(105 downto 0);
       signal RIPPLE : std_logic_vector(105 downto 0);
         

begin

  DADDA : Dadda53 port map (X, Y, S, C);

  HA0 : half_adder port map (S(0), C(0), P(0), RIPPLE(0));
  FA0 : full_adder port map (S(1), C(1), RIPPLE(0), P(1), RIPPLE(1));
  FA1 : full_adder port map (S(2), C(2), RIPPLE(1), P(2), RIPPLE(2));
  FA2 : full_adder port map (S(3), C(3), RIPPLE(2), P(3), RIPPLE(3));
  FA3 : full_adder port map (S(4), C(4), RIPPLE(3), P(4), RIPPLE(4));
  FA4 : full_adder port map (S(5), C(5), RIPPLE(4), P(5), RIPPLE(5));
  FA5 : full_adder port map (S(6), C(6), RIPPLE(5), P(6), RIPPLE(6));
  FA6 : full_adder port map (S(7), C(7), RIPPLE(6), P(7), RIPPLE(7));
  FA7 : full_adder port map (S(8), C(8), RIPPLE(7), P(8), RIPPLE(8));
  FA8 : full_adder port map (S(9), C(9), RIPPLE(8), P(9), RIPPLE(9));
  FA9 : full_adder port map (S(10), C(10), RIPPLE(9), P(10), RIPPLE(10));
  FA10 : full_adder port map (S(11), C(11), RIPPLE(10), P(11), RIPPLE(11));
  FA11 : full_adder port map (S(12), C(12), RIPPLE(11), P(12), RIPPLE(12));
  FA12 : full_adder port map (S(13), C(13), RIPPLE(12), P(13), RIPPLE(13));
  FA13 : full_adder port map (S(14), C(14), RIPPLE(13), P(14), RIPPLE(14));
  FA14 : full_adder port map (S(15), C(15), RIPPLE(14), P(15), RIPPLE(15));
  FA15 : full_adder port map (S(16), C(16), RIPPLE(15), P(16), RIPPLE(16));
  FA16 : full_adder port map (S(17), C(17), RIPPLE(16), P(17), RIPPLE(17));
  FA17 : full_adder port map (S(18), C(18), RIPPLE(17), P(18), RIPPLE(18));
  FA18 : full_adder port map (S(19), C(19), RIPPLE(18), P(19), RIPPLE(19));
  FA19 : full_adder port map (S(20), C(20), RIPPLE(19), P(20), RIPPLE(20));
  FA20 : full_adder port map (S(21), C(21), RIPPLE(20), P(21), RIPPLE(21));
  FA21 : full_adder port map (S(22), C(22), RIPPLE(21), P(22), RIPPLE(22));
  FA22 : full_adder port map (S(23), C(23), RIPPLE(22), P(23), RIPPLE(23));
  FA23 : full_adder port map (S(24), C(24), RIPPLE(23), P(24), RIPPLE(24));
  FA24 : full_adder port map (S(25), C(25), RIPPLE(24), P(25), RIPPLE(25));
  FA25 : full_adder port map (S(26), C(26), RIPPLE(25), P(26), RIPPLE(26));
  FA26 : full_adder port map (S(27), C(27), RIPPLE(26), P(27), RIPPLE(27));
  FA27 : full_adder port map (S(28), C(28), RIPPLE(27), P(28), RIPPLE(28));
  FA28 : full_adder port map (S(29), C(29), RIPPLE(28), P(29), RIPPLE(29));
  FA29 : full_adder port map (S(30), C(30), RIPPLE(29), P(30), RIPPLE(30));
  FA30 : full_adder port map (S(31), C(31), RIPPLE(30), P(31), RIPPLE(31));
  FA31 : full_adder port map (S(32), C(32), RIPPLE(31), P(32), RIPPLE(32));
  FA32 : full_adder port map (S(33), C(33), RIPPLE(32), P(33), RIPPLE(33));
  FA33 : full_adder port map (S(34), C(34), RIPPLE(33), P(34), RIPPLE(34));
  FA34 : full_adder port map (S(35), C(35), RIPPLE(34), P(35), RIPPLE(35));
  FA35 : full_adder port map (S(36), C(36), RIPPLE(35), P(36), RIPPLE(36));
  FA36 : full_adder port map (S(37), C(37), RIPPLE(36), P(37), RIPPLE(37));
  FA37 : full_adder port map (S(38), C(38), RIPPLE(37), P(38), RIPPLE(38));
  FA38 : full_adder port map (S(39), C(39), RIPPLE(38), P(39), RIPPLE(39));
  FA39 : full_adder port map (S(40), C(40), RIPPLE(39), P(40), RIPPLE(40));
  FA40 : full_adder port map (S(41), C(41), RIPPLE(40), P(41), RIPPLE(41));
  FA41 : full_adder port map (S(42), C(42), RIPPLE(41), P(42), RIPPLE(42));
  FA42 : full_adder port map (S(43), C(43), RIPPLE(42), P(43), RIPPLE(43));
  FA43 : full_adder port map (S(44), C(44), RIPPLE(43), P(44), RIPPLE(44));
  FA44 : full_adder port map (S(45), C(45), RIPPLE(44), P(45), RIPPLE(45));
  FA45 : full_adder port map (S(46), C(46), RIPPLE(45), P(46), RIPPLE(46));
  FA46 : full_adder port map (S(47), C(47), RIPPLE(46), P(47), RIPPLE(47));
  FA47 : full_adder port map (S(48), C(48), RIPPLE(47), P(48), RIPPLE(48));
  FA48 : full_adder port map (S(49), C(49), RIPPLE(48), P(49), RIPPLE(49));
  FA49 : full_adder port map (S(50), C(50), RIPPLE(49), P(50), RIPPLE(50));
  FA50 : full_adder port map (S(51), C(51), RIPPLE(50), P(51), RIPPLE(51));

  FA51 : full_adder port map (S(52), C(52), RIPPLE(51), P(52), RIPPLE(52));
  FA52 : full_adder port map (S(53), C(53), RIPPLE(52), P(53), RIPPLE(53));
  FA53 : full_adder port map (S(54), C(54), RIPPLE(53), P(54), RIPPLE(54));
  FA54 : full_adder port map (S(55), C(55), RIPPLE(54), P(55), RIPPLE(55));
  FA55 : full_adder port map (S(56), C(56), RIPPLE(55), P(56), RIPPLE(56));
  FA56 : full_adder port map (S(57), C(57), RIPPLE(56), P(57), RIPPLE(57));
  FA57 : full_adder port map (S(58), C(58), RIPPLE(57), P(58), RIPPLE(58));
  FA58 : full_adder port map (S(59), C(59), RIPPLE(58), P(59), RIPPLE(59));
  FA59 : full_adder port map (S(60), C(60), RIPPLE(59), P(60), RIPPLE(60));
  FA60 : full_adder port map (S(61), C(61), RIPPLE(60), P(61), RIPPLE(61));
  FA61 : full_adder port map (S(62), C(62), RIPPLE(61), P(62), RIPPLE(62));
  FA62 : full_adder port map (S(63), C(63), RIPPLE(62), P(63), RIPPLE(63));
  FA63 : full_adder port map (S(64), C(64), RIPPLE(63), P(64), RIPPLE(64));
  FA64 : full_adder port map (S(65), C(65), RIPPLE(64), P(65), RIPPLE(65));
  FA65 : full_adder port map (S(66), C(66), RIPPLE(65), P(66), RIPPLE(66));
  FA66 : full_adder port map (S(67), C(67), RIPPLE(66), P(67), RIPPLE(67));
  FA67 : full_adder port map (S(68), C(68), RIPPLE(67), P(68), RIPPLE(68));
  FA68 : full_adder port map (S(69), C(69), RIPPLE(68), P(69), RIPPLE(69));
  FA69 : full_adder port map (S(70), C(70), RIPPLE(69), P(70), RIPPLE(70));
  FA70 : full_adder port map (S(71), C(71), RIPPLE(70), P(71), RIPPLE(71));
  FA71 : full_adder port map (S(72), C(72), RIPPLE(71), P(72), RIPPLE(72));
  FA72 : full_adder port map (S(73), C(73), RIPPLE(72), P(73), RIPPLE(73));
  FA73 : full_adder port map (S(74), C(74), RIPPLE(73), P(74), RIPPLE(74));
  FA74 : full_adder port map (S(75), C(75), RIPPLE(74), P(75), RIPPLE(75));
  FA75 : full_adder port map (S(76), C(76), RIPPLE(75), P(76), RIPPLE(76));
  FA76 : full_adder port map (S(77), C(77), RIPPLE(76), P(77), RIPPLE(77));
  FA77 : full_adder port map (S(78), C(78), RIPPLE(77), P(78), RIPPLE(78));
  FA78 : full_adder port map (S(79), C(79), RIPPLE(78), P(79), RIPPLE(79));
  FA79 : full_adder port map (S(80), C(80), RIPPLE(79), P(80), RIPPLE(80));
  FA80 : full_adder port map (S(81), C(81), RIPPLE(80), P(81), RIPPLE(81));
  FA81 : full_adder port map (S(82), C(82), RIPPLE(81), P(82), RIPPLE(82));
  FA82 : full_adder port map (S(83), C(83), RIPPLE(82), P(83), RIPPLE(83));
  FA83 : full_adder port map (S(84), C(84), RIPPLE(83), P(84), RIPPLE(84));
  FA84 : full_adder port map (S(85), C(85), RIPPLE(84), P(85), RIPPLE(85));
  FA85 : full_adder port map (S(86), C(86), RIPPLE(85), P(86), RIPPLE(86));
  FA86 : full_adder port map (S(87), C(87), RIPPLE(86), P(87), RIPPLE(87));
  FA87 : full_adder port map (S(88), C(88), RIPPLE(87), P(88), RIPPLE(88));
  FA88 : full_adder port map (S(89), C(89), RIPPLE(88), P(89), RIPPLE(89));
  FA89 : full_adder port map (S(90), C(90), RIPPLE(89), P(90), RIPPLE(90));
  FA90 : full_adder port map (S(91), C(91), RIPPLE(90), P(91), RIPPLE(91));
  FA91 : full_adder port map (S(92), C(92), RIPPLE(91), P(92), RIPPLE(92));
  FA92 : full_adder port map (S(93), C(93), RIPPLE(92), P(93), RIPPLE(93));
  FA93 : full_adder port map (S(94), C(94), RIPPLE(93), P(94), RIPPLE(94));
  FA94 : full_adder port map (S(95), C(95), RIPPLE(94), P(95), RIPPLE(95));
  FA95 : full_adder port map (S(96), C(96), RIPPLE(95), P(96), RIPPLE(96));
  FA96 : full_adder port map (S(97), C(97), RIPPLE(96), P(97), RIPPLE(97));
  FA97 : full_adder port map (S(98), C(98), RIPPLE(97), P(98), RIPPLE(98));
  FA98 : full_adder port map (S(99), C(99), RIPPLE(98), P(99), RIPPLE(99));
  FA99 : full_adder port map (S(100), C(100), RIPPLE(99), P(100), RIPPLE(100));
  FA100 : full_adder port map (S(101), C(101), RIPPLE(100), P(101), RIPPLE(101));
  FA101 : full_adder port map (S(102), C(102), RIPPLE(101), P(102), RIPPLE(102));
  FA102 : full_adder port map (S(103), C(103), RIPPLE(102), P(103), RIPPLE(103));
  FA103 : full_adder port map (S(104), C(104), RIPPLE(103), P(104), RIPPLE(104));
  FA104 : full_adder port map (S(105), C(105), RIPPLE(104), P(105), RIPPLE(105));
  
end Structure;

