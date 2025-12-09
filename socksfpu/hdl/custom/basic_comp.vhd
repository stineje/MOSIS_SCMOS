
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux21_5 IS
      PORT(a, b   			:in std_logic_vector(4 downto 0);
		     sel				   :in std_logic;
           z		     	 :out std_logic_vector(4 downto 0));
END mux21_5;

ARCHITECTURE behv OF mux21_5 IS
BEGIN
	WITH sel SELECT
		z <= a when '0',
			  b when others;
END behv;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux21_32 IS
      PORT(a, b   : in std_logic_vector(31 downto 0);
           sel				: in std_logic;
			  z		   : out std_logic_vector(31 downto 0));
END mux21_32;

ARCHITECTURE behv OF mux21_32 IS
BEGIN
	WITH sel SELECT
	   z <= a when '0',
			  b when others;
end behv;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux321_32 IS
      PORT(q0, q1, q2, q3, q4, q5, q6, q7, q8, q9 : in std_logic_vector(31 downto 0);
           q10, q11, q12, q13, q14, q15, q16, q17, q18, q19 : in std_logic_vector(31 downto 0);
           q20, q21, q22, q23, q24, q25, q26, q27, q28, q29 : in std_logic_vector(31 downto 0);
           q30, q31   : in std_logic_vector(31 downto 0);
           sel				: in std_logic_vector(4 downto 0);
			  z		   : out std_logic_vector(31 downto 0));
END mux321_32;

ARCHITECTURE behv OF mux321_32 IS
BEGIN
	WITH sel SELECT
	   z <= q0 when "00000",
           q1 when "00001",
           q2 when "00010",
           q3 when "00011",
           q4 when "00100",
           q5 when "00101",
           q6 when "00110",
           q7 when "00111",
           q8 when "01000",
           q9 when "01001",
           q10 when "01010",
           q11 when "01011",
           q12 when "01100",
           q13 when "01101",
           q14 when "01110",
           q15 when "01111",
           q16 when "10000",
           q17 when "10001",
           q18 when "10010",
           q19 when "10011",
           q20 when "10100",
           q21 when "10101",
           q22 when "10110",
           q23 when "10111",
           q24 when "11000",
           q25 when "11001",
           q26 when "11010",
           q27 when "11011",
           q28 when "11100",
           q29 when "11101",
           q30 when "11110",
			  q31 when others;
end behv;


library ieee;
use ieee.std_logic_1164.all;

entity register32 is
  port (d   : in  std_logic_vector(31 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(31 downto 0));
end register32;

architecture behavior of register32 is
begin
  process (clk)
  begin
    if (clk'event and clk = '1') then
      q <= d;
    end if;
  end process; 
end behavior;


LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

entity DFF_SR is
        port (D   : in std_logic;
              clk : in std_logic;
              reset :in std_logic;
              set : in std_logic;
              Q   : out std_logic);
end DFF_SR;

architecture behavior of DFF_SR is

begin
        process (clk, set, reset) begin
           if reset = '0' then
                 Q <= '0';
           elsif set = '0' then
                 Q <= '1';
           elsif (clk'event and clk = '1') then
                 Q <= D;
           end if;
        end process;
end behavior;


LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

entity register_5bit is
    port (D   :   in std_logic_vector(4 downto 0);
          clk :   in std_logic;
          reset : in std_logic;
          set :   in std_logic;
          Q   :   out std_logic_vector(4 downto 0));
end register_5bit;

architecture register_5bit of register_5bit is
    
   component DFF_SR is 
      port (D   : in std_logic;
            clk : in std_logic;
            reset :in std_logic;
            set : in std_logic;
            Q   : out std_logic);
   end component;

begin

      FF0 : DFF_SR port map(D(0), clk, reset, set, Q(0));
      FF1 : DFF_SR port map(D(1), clk, reset, set, Q(1));
      FF2 : DFF_SR port map(D(2), clk, reset, set, Q(2));
      FF3 : DFF_SR port map(D(3), clk, reset, set, Q(3));
      FF4 : DFF_SR port map(D(4), clk, reset, set, Q(4));

end register_5bit;


LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

entity register_27bit is
    port (D   :   in std_logic_vector(26 downto 0);
          clk :   in std_logic;
          reset : in std_logic;
          set :   in std_logic;
          Q   :   out std_logic_vector(26 downto 0));
end register_27bit;

architecture register_27bit of register_27bit is
    
   component DFF_SR is 
      port (D   : in std_logic;
            clk : in std_logic;
            reset :in std_logic;
            set : in std_logic;
            Q   : out std_logic);
   end component;

begin

      FF0 : DFF_SR port map(D(0), clk, reset, set, Q(0));
      FF1 : DFF_SR port map(D(1), clk, reset, set, Q(1));
      FF2 : DFF_SR port map(D(2), clk, reset, set, Q(2));
      FF3 : DFF_SR port map(D(3), clk, reset, set, Q(3));
      FF4 : DFF_SR port map(D(4), clk, reset, set, Q(4));
      FF5 : DFF_SR port map(D(5), clk, reset, set, Q(5));
      FF6 : DFF_SR port map(D(6), clk, reset, set, Q(6));
      FF7 : DFF_SR port map(D(7), clk, reset, set, Q(7));
      FF8 : DFF_SR port map(D(8), clk, reset, set, Q(8));
      FF9 : DFF_SR port map(D(9), clk, reset, set, Q(9));
      FF10 : DFF_SR port map(D(10), clk, reset, set, Q(10));
      FF11 : DFF_SR port map(D(11), clk, reset, set, Q(11));
      FF12 : DFF_SR port map(D(12), clk, reset, set, Q(12));
      FF13 : DFF_SR port map(D(13), clk, reset, set, Q(13));
      FF14 : DFF_SR port map(D(14), clk, reset, set, Q(14));
      FF15 : DFF_SR port map(D(15), clk, reset, set, Q(15));
      FF16 : DFF_SR port map(D(16), clk, reset, set, Q(16));
      FF17 : DFF_SR port map(D(17), clk, reset, set, Q(17));
      FF18 : DFF_SR port map(D(18), clk, reset, set, Q(18));
      FF19 : DFF_SR port map(D(19), clk, reset, set, Q(19));
      FF20 : DFF_SR port map(D(20), clk, reset, set, Q(20));
      FF21 : DFF_SR port map(D(21), clk, reset, set, Q(21));
      FF22 : DFF_SR port map(D(22), clk, reset, set, Q(22));
      FF23 : DFF_SR port map(D(23), clk, reset, set, Q(23));
      FF24 : DFF_SR port map(D(24), clk, reset, set, Q(24));
      FF25 : DFF_SR port map(D(25), clk, reset, set, Q(25));
      FF26 : DFF_SR port map(D(26), clk, reset, set, Q(26));

end register_27bit;
