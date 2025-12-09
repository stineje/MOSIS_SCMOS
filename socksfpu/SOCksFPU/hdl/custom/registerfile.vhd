library ieee;
use ieee.std_logic_1164.all;

entity registerfile is
  port (addr      : in  std_logic_vector(4 downto 0);
        data_in    : in  std_logic_vector(31 downto 0);
        data_in_ext: in  std_logic_vector(31 downto 0);
        regwrite  : in  std_logic;
        clk       : in  std_logic;
        sdp       : in  std_logic;    -- Single or double Precission
        fpu_cpu   : in  std_logic;
        addr_a    : in  std_logic_vector(4 downto 0);
        addr_b    : in  std_logic_vector(4 downto 0);
        op_a      : out std_logic_vector(63 downto 0);
        op_b      : out std_logic_vector(63 downto 0);
        d_out     : out std_logic_vector(31 downto 0));
end registerfile;

architecture behavior of registerfile is

  component register32
    port (d   : in  std_logic_vector(31 downto 0);
          clk : in  std_logic;
          q   : out std_logic_vector(31 downto 0));
  end component;

  component mux21_32 IS
    port (a, b  : in std_logic_vector(31 downto 0);
          sel	: in std_logic;
          z     : out std_logic_vector(31 downto 0));
  end component;

  -- write signals to individual registers
  signal wr   : std_logic_vector(31 downto 0);

  -- outputs (contents) of each register
  signal q0, q1, q2, q3, q4, q5, q6, q7, q8, q9 : std_logic_vector(31 downto 0);
  signal q10, q11, q12, q13, q14, q15, q16, q17, q18, q19 : std_logic_vector(31 downto 0);
  signal q20, q21, q22, q23, q24, q25, q26, q27, q28, q29 : std_logic_vector(31 downto 0);
  signal q30, q31: std_logic_vector(31 downto 0);
  
  signal din0,din1,din2,din3,din4,din5,din6,din7,din8,din9 : std_logic_vector(31 downto 0);
  signal din10,din11,din12,din13,din14,din15,din16,din17,din18,din19 : std_logic_vector(31 downto 0);
  signal din20,din21,din22,din23,din24,din25,din26,din27,din28,din29 : std_logic_vector(31 downto 0);
  signal din30,din31   : std_logic_vector(31 downto 0);
  
  signal mux_sdp   : std_logic_vector(31 downto 0);
  signal sdp_addr_a, sdp_addr_b   : std_logic_vector(5 downto 0);
  signal addr_ext   : std_logic_vector(7 downto 0);
  signal addr_mux   : std_logic_vector(5 downto 0);

begin

  reg0  : register32 port map(din0, wr(0), q0);
  reg1  : register32 port map(din1, wr(1), q1);
  reg2  : register32 port map(din2, wr(2), q2);
  reg3  : register32 port map(din3, wr(3), q3);
  reg4  : register32 port map(din4, wr(4), q4);
  reg5  : register32 port map(din5, wr(5), q5);
  reg6  : register32 port map(din6, wr(6), q6);
  reg7  : register32 port map(din7, wr(7), q7);
  reg8  : register32 port map(din8, wr(8), q8);
  reg9  : register32 port map(din9, wr(9), q9);
  reg10 : register32 port map(din10, wr(10), q10);
  reg11 : register32 port map(din11, wr(11), q11);
  reg12 : register32 port map(din12, wr(12), q12);
  reg13 : register32 port map(din13, wr(13), q13);
  reg14 : register32 port map(din14, wr(14), q14);
  reg15 : register32 port map(din15, wr(15), q15);
  reg16 : register32 port map(din16, wr(16), q16);
  reg17 : register32 port map(din17, wr(17), q17);
  reg18 : register32 port map(din18, wr(18), q18);
  reg19 : register32 port map(din19, wr(19), q19);
  reg20 : register32 port map(din20, wr(20), q20);
  reg21 : register32 port map(din21, wr(21), q21);
  reg22 : register32 port map(din22, wr(22), q22);
  reg23 : register32 port map(din23, wr(23), q23);
  reg24 : register32 port map(din24, wr(24), q24);
  reg25 : register32 port map(din25, wr(25), q25);
  reg26 : register32 port map(din26, wr(26), q26);
  reg27 : register32 port map(din27, wr(27), q27);
  reg28 : register32 port map(din28, wr(28), q28);
  reg29 : register32 port map(din29, wr(29), q29);
  reg30 : register32 port map(din30, wr(30), q30);
  reg31 : register32 port map(din31, wr(31), q31);
  
  -- write register signals for each register (register clock inputs)

mux_data_in0 : mux21_32 port map(data_in, data_in_ext, mux_sdp(0), din0);
mux_data_in1 : mux21_32 port map(data_in, data_in_ext, mux_sdp(1), din1);
mux_data_in2 : mux21_32 port map(data_in, data_in_ext, mux_sdp(2), din2);
mux_data_in3 : mux21_32 port map(data_in, data_in_ext, mux_sdp(3), din3);
mux_data_in4 : mux21_32 port map(data_in, data_in_ext, mux_sdp(4), din4);
mux_data_in5 : mux21_32 port map(data_in, data_in_ext, mux_sdp(5), din5);
mux_data_in6 : mux21_32 port map(data_in, data_in_ext, mux_sdp(6), din6);
mux_data_in7 : mux21_32 port map(data_in, data_in_ext, mux_sdp(7), din7);
mux_data_in8 : mux21_32 port map(data_in, data_in_ext, mux_sdp(8), din8);
mux_data_in9 : mux21_32 port map(data_in, data_in_ext, mux_sdp(9), din9);
mux_data_in10 : mux21_32 port map(data_in, data_in_ext, mux_sdp(10), din10);
mux_data_in11 : mux21_32 port map(data_in, data_in_ext, mux_sdp(11), din11);
mux_data_in12 : mux21_32 port map(data_in, data_in_ext, mux_sdp(12), din12);
mux_data_in13 : mux21_32 port map(data_in, data_in_ext, mux_sdp(13), din13);
mux_data_in14 : mux21_32 port map(data_in, data_in_ext, mux_sdp(14), din14);
mux_data_in15 : mux21_32 port map(data_in, data_in_ext, mux_sdp(15), din15);
mux_data_in16 : mux21_32 port map(data_in, data_in_ext, mux_sdp(16), din16);
mux_data_in17 : mux21_32 port map(data_in, data_in_ext, mux_sdp(17), din17);
mux_data_in18 : mux21_32 port map(data_in, data_in_ext, mux_sdp(18), din18);
mux_data_in19 : mux21_32 port map(data_in, data_in_ext, mux_sdp(19), din19);
mux_data_in20 : mux21_32 port map(data_in, data_in_ext, mux_sdp(20), din20);
mux_data_in21 : mux21_32 port map(data_in, data_in_ext, mux_sdp(21), din21);
mux_data_in22 : mux21_32 port map(data_in, data_in_ext, mux_sdp(22), din22);
mux_data_in23 : mux21_32 port map(data_in, data_in_ext, mux_sdp(23), din23);
mux_data_in24 : mux21_32 port map(data_in, data_in_ext, mux_sdp(24), din24);
mux_data_in25 : mux21_32 port map(data_in, data_in_ext, mux_sdp(25), din25);
mux_data_in26 : mux21_32 port map(data_in, data_in_ext, mux_sdp(26), din26);
mux_data_in27 : mux21_32 port map(data_in, data_in_ext, mux_sdp(27), din27);
mux_data_in28 : mux21_32 port map(data_in, data_in_ext, mux_sdp(28), din28);
mux_data_in29 : mux21_32 port map(data_in, data_in_ext, mux_sdp(29), din29);
mux_data_in30 : mux21_32 port map(data_in, data_in_ext, mux_sdp(30), din30);
mux_data_in31 : mux21_32 port map(data_in, data_in_ext, mux_sdp(31), din31);

addr_mux(4 downto 0) <= addr;
addr_mux(5) <= sdp and fpu_cpu;

process (addr_mux)
begin
    case addr_mux (5 downto 0) is
        when "000000" => mux_sdp <= "00000000000000000000000000000000";
        when "000001" => mux_sdp <= "00000000000000000000000000000000";
        when "000010" => mux_sdp <= "00000000000000000000000000000000";
        when "000011" => mux_sdp <= "00000000000000000000000000000000";
        when "000100" => mux_sdp <= "00000000000000000000000000000000";
        when "000101" => mux_sdp <= "00000000000000000000000000000000";
        when "000110" => mux_sdp <= "00000000000000000000000000000000";
        when "000111" => mux_sdp <= "00000000000000000000000000000000";
        when "001000" => mux_sdp <= "00000000000000000000000000000000";
        when "001001" => mux_sdp <= "00000000000000000000000000000000";
        when "001010" => mux_sdp <= "00000000000000000000000000000000";
        when "001011" => mux_sdp <= "00000000000000000000000000000000";
        when "001100" => mux_sdp <= "00000000000000000000000000000000";
        when "001101" => mux_sdp <= "00000000000000000000000000000000";
        when "001110" => mux_sdp <= "00000000000000000000000000000000";
        when "001111" => mux_sdp <= "00000000000000000000000000000000";
        when "010000" => mux_sdp <= "00000000000000000000000000000000";
        when "010001" => mux_sdp <= "00000000000000000000000000000000";
        when "010010" => mux_sdp <= "00000000000000000000000000000000";
        when "010011" => mux_sdp <= "00000000000000000000000000000000";
        when "010100" => mux_sdp <= "00000000000000000000000000000000";
        when "010101" => mux_sdp <= "00000000000000000000000000000000";
        when "010110" => mux_sdp <= "00000000000000000000000000000000";
        when "010111" => mux_sdp <= "00000000000000000000000000000000";
        when "011000" => mux_sdp <= "00000000000000000000000000000000";
        when "011001" => mux_sdp <= "00000000000000000000000000000000";
        when "011010" => mux_sdp <= "00000000000000000000000000000000";
        when "011011" => mux_sdp <= "00000000000000000000000000000000";
        when "011100" => mux_sdp <= "00000000000000000000000000000000";
        when "011101" => mux_sdp <= "00000000000000000000000000000000";
        when "011110" => mux_sdp <= "00000000000000000000000000000000";
        when "011111" => mux_sdp <= "00000000000000000000000000000000";

        when "100000" => mux_sdp <= "00000000000000000000000000000010";
        when "100001" => mux_sdp <= "00000000000000000000000000000100";
        when "100010" => mux_sdp <= "00000000000000000000000000001000";
        when "100011" => mux_sdp <= "00000000000000000000000000010000";
        when "100100" => mux_sdp <= "00000000000000000000000000100000";
        when "100101" => mux_sdp <= "00000000000000000000000001000000";
        when "100110" => mux_sdp <= "00000000000000000000000010000000";
        when "100111" => mux_sdp <= "00000000000000000000000100000000";
        when "101000" => mux_sdp <= "00000000000000000000001000000000";
        when "101001" => mux_sdp <= "00000000000000000000010000000000";
        when "101010" => mux_sdp <= "00000000000000000000100000000000";
        when "101011" => mux_sdp <= "00000000000000000001000000000000";
        when "101100" => mux_sdp <= "00000000000000000010000000000000";
        when "101101" => mux_sdp <= "00000000000000000100000000000000";
        when "101110" => mux_sdp <= "00000000000000001000000000000000";
        when "101111" => mux_sdp <= "00000000000000010000000000000000";
        when "110000" => mux_sdp <= "00000000000000100000000000000000";
        when "110001" => mux_sdp <= "00000000000001000000000000000000";
        when "110010" => mux_sdp <= "00000000000010000000000000000000";
        when "110011" => mux_sdp <= "00000000000100000000000000000000";
        when "110100" => mux_sdp <= "00000000001000000000000000000000";
        when "110101" => mux_sdp <= "00000000010000000000000000000000";
        when "110110" => mux_sdp <= "00000000100000000000000000000000";
        when "110111" => mux_sdp <= "00000001000000000000000000000000";
        when "111000" => mux_sdp <= "00000010000000000000000000000000";
        when "111001" => mux_sdp <= "00000100000000000000000000000000";
        when "111010" => mux_sdp <= "00001000000000000000000000000000";
        when "111011" => mux_sdp <= "00010000000000000000000000000000";
        when "111100" => mux_sdp <= "00100000000000000000000000000000";
        when "111101" => mux_sdp <= "01000000000000000000000000000000";
        when "111110" => mux_sdp <= "10000000000000000000000000000000";
        when "111111" => mux_sdp <= "00000000000000000000000000000000";
        when others   => mux_sdp <= "00000000000000000000000000000000";
    end case;
end process;

addr_ext(4 downto 0) <= addr(4 downto 0);
addr_ext(5) <= clk;
addr_ext(6) <= regwrite;
addr_ext(7) <= sdp and fpu_cpu;

process (addr_ext)
begin
    case addr_ext(7 downto 0) is
        when "01100000" => wr <= "00000000000000000000000000000001";
        when "01100001" => wr <= "00000000000000000000000000000010";
        when "01100010" => wr <= "00000000000000000000000000000100";
        when "01100011" => wr <= "00000000000000000000000000001000";
        when "01100100" => wr <= "00000000000000000000000000010000";
        when "01100101" => wr <= "00000000000000000000000000100000";
        when "01100110" => wr <= "00000000000000000000000001000000";
        when "01100111" => wr <= "00000000000000000000000010000000";
        when "01101000" => wr <= "00000000000000000000000100000000";
        when "01101001" => wr <= "00000000000000000000001000000000";
        when "01101010" => wr <= "00000000000000000000010000000000";
        when "01101011" => wr <= "00000000000000000000100000000000";
        when "01101100" => wr <= "00000000000000000001000000000000";
        when "01101101" => wr <= "00000000000000000010000000000000";
        when "01101110" => wr <= "00000000000000000100000000000000";
        when "01101111" => wr <= "00000000000000001000000000000000";
        when "01110000" => wr <= "00000000000000010000000000000000";
        when "01110001" => wr <= "00000000000000100000000000000000";
        when "01110010" => wr <= "00000000000001000000000000000000";
        when "01110011" => wr <= "00000000000010000000000000000000";
        when "01110100" => wr <= "00000000000100000000000000000000";
        when "01110101" => wr <= "00000000001000000000000000000000";
        when "01110110" => wr <= "00000000010000000000000000000000";
        when "01110111" => wr <= "00000000100000000000000000000000";
        when "01111000" => wr <= "00000001000000000000000000000000";
        when "01111001" => wr <= "00000010000000000000000000000000";
        when "01111010" => wr <= "00000100000000000000000000000000";
        when "01111011" => wr <= "00001000000000000000000000000000";
        when "01111100" => wr <= "00010000000000000000000000000000";
        when "01111101" => wr <= "00100000000000000000000000000000";
        when "01111110" => wr <= "01000000000000000000000000000000";
        when "01111111" => wr <= "10000000000000000000000000000000";

        when "11100000" => wr <= "00000000000000000000000000000011";
        when "11100001" => wr <= "00000000000000000000000000000110";
        when "11100010" => wr <= "00000000000000000000000000001100";
        when "11100011" => wr <= "00000000000000000000000000011000";
        when "11100100" => wr <= "00000000000000000000000000110000";
        when "11100101" => wr <= "00000000000000000000000001100000";
        when "11100110" => wr <= "00000000000000000000000011000000";
        when "11100111" => wr <= "00000000000000000000000110000000";
        when "11101000" => wr <= "00000000000000000000001100000000";
        when "11101001" => wr <= "00000000000000000000011000000000";
        when "11101010" => wr <= "00000000000000000000110000000000";
        when "11101011" => wr <= "00000000000000000001100000000000";
        when "11101100" => wr <= "00000000000000000011000000000000";
        when "11101101" => wr <= "00000000000000000110000000000000";
        when "11101110" => wr <= "00000000000000001100000000000000";
        when "11101111" => wr <= "00000000000000011000000000000000";
        when "11110000" => wr <= "00000000000000110000000000000000";
        when "11110001" => wr <= "00000000000001100000000000000000";
        when "11110010" => wr <= "00000000000011000000000000000000";
        when "11110011" => wr <= "00000000000110000000000000000000";
        when "11110100" => wr <= "00000000001100000000000000000000";
        when "11110101" => wr <= "00000000011000000000000000000000";
        when "11110110" => wr <= "00000000110000000000000000000000";
        when "11110111" => wr <= "00000001100000000000000000000000";
        when "11111000" => wr <= "00000011000000000000000000000000";
        when "11111001" => wr <= "00000110000000000000000000000000";
        when "11111010" => wr <= "00001100000000000000000000000000";
        when "11111011" => wr <= "00011000000000000000000000000000";
        when "11111100" => wr <= "00110000000000000000000000000000";
        when "11111101" => wr <= "01100000000000000000000000000000";
        when "11111110" => wr <= "11000000000000000000000000000000";
        when "11111111" => wr <= "10000000000000000000000000000000";
        when others      => wr <= "00000000000000000000000000000000";
    end case;
end process;

  process (addr,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31)
  begin
    case addr (4 downto 0) is
      when "00000" => d_out <= q0;
      when "00001" => d_out <= q1;
      when "00010" => d_out <= q2;
      when "00011" => d_out <= q3;
      when "00100" => d_out <= q4;
      when "00101" => d_out <= q5;
      when "00110" => d_out <= q6;
      when "00111" => d_out <= q7;
      when "01000" => d_out <= q8;
      when "01001" => d_out <= q9;
      when "01010" => d_out <= q10;
      when "01011" => d_out <= q11;
      when "01100" => d_out <= q12;
      when "01101" => d_out <= q13;
      when "01110" => d_out <= q14;
      when "01111" => d_out <= q15;
      when "10000" => d_out <= q16;
      when "10001" => d_out <= q17;
      when "10010" => d_out <= q18;
      when "10011" => d_out <= q19;
      when "10100" => d_out <= q20;
      when "10101" => d_out <= q21;
      when "10110" => d_out <= q22;
      when "10111" => d_out <= q23;
      when "11000" => d_out <= q24;
      when "11001" => d_out <= q25;
      when "11010" => d_out <= q26;
      when "11011" => d_out <= q27;
      when "11100" => d_out <= q28;
      when "11101" => d_out <= q29;
      when "11110" => d_out <= q30;
      when others  => d_out <= q31;
    end case;

  end process;

  sdp_addr_a(5) <= sdp;
  sdp_addr_a(4 downto 0) <= addr_a;
  sdp_addr_b(5) <= sdp;
  sdp_addr_b(4 downto 0) <= addr_b;

  process (sdp_addr_a,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31)
  begin
    case sdp_addr_a (5 downto 0) is
      when "000000" => op_a (63 downto 32) <= q0; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000001" => op_a (63 downto 32) <= q1; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000010" => op_a (63 downto 32) <= q2; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000011" => op_a (63 downto 32) <= q3; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000100" => op_a (63 downto 32) <= q4; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000101" => op_a (63 downto 32) <= q5; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000110" => op_a (63 downto 32) <= q6; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "000111" => op_a (63 downto 32) <= q7; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001000" => op_a (63 downto 32) <= q8; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001001" => op_a (63 downto 32) <= q9; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001010" => op_a (63 downto 32) <= q10; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001011" => op_a (63 downto 32) <= q11; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001100" => op_a (63 downto 32) <= q12; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001101" => op_a (63 downto 32) <= q13; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001110" => op_a (63 downto 32) <= q14; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "001111" => op_a (63 downto 32) <= q15; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010000" => op_a (63 downto 32) <= q16; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010001" => op_a (63 downto 32) <= q17; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010010" => op_a (63 downto 32) <= q18; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010011" => op_a (63 downto 32) <= q19; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010100" => op_a (63 downto 32) <= q20; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010101" => op_a (63 downto 32) <= q21; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010110" => op_a (63 downto 32) <= q22; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "010111" => op_a (63 downto 32) <= q23; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011000" => op_a (63 downto 32) <= q24; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011001" => op_a (63 downto 32) <= q25; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011010" => op_a (63 downto 32) <= q26; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011011" => op_a (63 downto 32) <= q27; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011100" => op_a (63 downto 32) <= q28; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011101" => op_a (63 downto 32) <= q29; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011110" => op_a (63 downto 32) <= q30; op_a (31 downto 0) <= "00000000000000000000000000000000";
      when "011111" => op_a (63 downto 32) <= q31; op_a (31 downto 0) <= "00000000000000000000000000000000";

      when "100000" => op_a (63 downto 32) <= q0; op_a (31 downto 0) <= q1;
      when "100001" => op_a (63 downto 32) <= q1; op_a (31 downto 0) <= q2;
      when "100010" => op_a (63 downto 32) <= q2; op_a (31 downto 0) <= q3;
      when "100011" => op_a (63 downto 32) <= q3; op_a (31 downto 0) <= q4;
      when "100100" => op_a (63 downto 32) <= q4; op_a (31 downto 0) <= q5;
      when "100101" => op_a (63 downto 32) <= q5; op_a (31 downto 0) <= q6;
      when "100110" => op_a (63 downto 32) <= q6; op_a (31 downto 0) <= q7;
      when "100111" => op_a (63 downto 32) <= q7; op_a (31 downto 0) <= q8;
      when "101000" => op_a (63 downto 32) <= q8; op_a (31 downto 0) <= q9;
      when "101001" => op_a (63 downto 32) <= q9; op_a (31 downto 0) <= q10;
      when "101010" => op_a (63 downto 32) <= q10; op_a (31 downto 0) <= q11;
      when "101011" => op_a (63 downto 32) <= q11; op_a (31 downto 0) <= q12;
      when "101100" => op_a (63 downto 32) <= q12; op_a (31 downto 0) <= q13;
      when "101101" => op_a (63 downto 32) <= q13; op_a (31 downto 0) <= q14;
      when "101110" => op_a (63 downto 32) <= q14; op_a (31 downto 0) <= q15;
      when "101111" => op_a (63 downto 32) <= q15; op_a (31 downto 0) <= q16;
      when "110000" => op_a (63 downto 32) <= q16; op_a (31 downto 0) <= q17;
      when "110001" => op_a (63 downto 32) <= q17; op_a (31 downto 0) <= q18;
      when "110010" => op_a (63 downto 32) <= q18; op_a (31 downto 0) <= q19;
      when "110011" => op_a (63 downto 32) <= q19; op_a (31 downto 0) <= q20;
      when "110100" => op_a (63 downto 32) <= q20; op_a (31 downto 0) <= q21;
      when "110101" => op_a (63 downto 32) <= q21; op_a (31 downto 0) <= q22;
      when "110110" => op_a (63 downto 32) <= q22; op_a (31 downto 0) <= q23;
      when "110111" => op_a (63 downto 32) <= q23; op_a (31 downto 0) <= q24;
      when "111000" => op_a (63 downto 32) <= q24; op_a (31 downto 0) <= q25;
      when "111001" => op_a (63 downto 32) <= q25; op_a (31 downto 0) <= q26;
      when "111010" => op_a (63 downto 32) <= q26; op_a (31 downto 0) <= q27;
      when "111011" => op_a (63 downto 32) <= q27; op_a (31 downto 0) <= q28;
      when "111100" => op_a (63 downto 32) <= q28; op_a (31 downto 0) <= q29;
      when "111101" => op_a (63 downto 32) <= q29; op_a (31 downto 0) <= q30;
      when "111110" => op_a (63 downto 32) <= q30; op_a (31 downto 0) <= q31;
      when others  => op_a (63 downto 32) <= q31; op_a (31 downto 0) <= q31;
    end case;
  end process;

  process (sdp_addr_b,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31)
  begin
    case sdp_addr_b is
      when "000000" => op_b (63 downto 32) <= q0; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000001" => op_b (63 downto 32) <= q1; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000010" => op_b (63 downto 32) <= q2; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000011" => op_b (63 downto 32) <= q3; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000100" => op_b (63 downto 32) <= q4; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000101" => op_b (63 downto 32) <= q5; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000110" => op_b (63 downto 32) <= q6; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "000111" => op_b (63 downto 32) <= q7; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001000" => op_b (63 downto 32) <= q8; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001001" => op_b (63 downto 32) <= q9; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001010" => op_b (63 downto 32) <= q10; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001011" => op_b (63 downto 32) <= q11; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001100" => op_b (63 downto 32) <= q12; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001101" => op_b (63 downto 32) <= q13; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001110" => op_b (63 downto 32) <= q14; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "001111" => op_b (63 downto 32) <= q15; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010000" => op_b (63 downto 32) <= q16; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010001" => op_b (63 downto 32) <= q17; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010010" => op_b (63 downto 32) <= q18; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010011" => op_b (63 downto 32) <= q19; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010100" => op_b (63 downto 32) <= q20; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010101" => op_b (63 downto 32) <= q21; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010110" => op_b (63 downto 32) <= q22; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "010111" => op_b (63 downto 32) <= q23; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011000" => op_b (63 downto 32) <= q24; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011001" => op_b (63 downto 32) <= q25; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011010" => op_b (63 downto 32) <= q26; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011011" => op_b (63 downto 32) <= q27; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011100" => op_b (63 downto 32) <= q28; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011101" => op_b (63 downto 32) <= q29; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011110" => op_b (63 downto 32) <= q30; op_b (31 downto 0) <= "00000000000000000000000000000000";
      when "011111" => op_b (63 downto 32) <= q31; op_b (31 downto 0) <= "00000000000000000000000000000000";

      when "100000" => op_b (63 downto 32) <= q0; op_b (31 downto 0) <= q1;
      when "100001" => op_b (63 downto 32) <= q1; op_b (31 downto 0) <= q2;
      when "100010" => op_b (63 downto 32) <= q2; op_b (31 downto 0) <= q3;
      when "100011" => op_b (63 downto 32) <= q3; op_b (31 downto 0) <= q4;
      when "100100" => op_b (63 downto 32) <= q4; op_b (31 downto 0) <= q5;
      when "100101" => op_b (63 downto 32) <= q5; op_b (31 downto 0) <= q6;
      when "100110" => op_b (63 downto 32) <= q6; op_b (31 downto 0) <= q7;
      when "100111" => op_b (63 downto 32) <= q7; op_b (31 downto 0) <= q8;
      when "101000" => op_b (63 downto 32) <= q8; op_b (31 downto 0) <= q9;
      when "101001" => op_b (63 downto 32) <= q9; op_b (31 downto 0) <= q10;
      when "101010" => op_b (63 downto 32) <= q10; op_b (31 downto 0) <= q11;
      when "101011" => op_b (63 downto 32) <= q11; op_b (31 downto 0) <= q12;
      when "101100" => op_b (63 downto 32) <= q12; op_b (31 downto 0) <= q13;
      when "101101" => op_b (63 downto 32) <= q13; op_b (31 downto 0) <= q14;
      when "101110" => op_b (63 downto 32) <= q14; op_b (31 downto 0) <= q15;
      when "101111" => op_b (63 downto 32) <= q15; op_b (31 downto 0) <= q16;
      when "110000" => op_b (63 downto 32) <= q16; op_b (31 downto 0) <= q17;
      when "110001" => op_b (63 downto 32) <= q17; op_b (31 downto 0) <= q18;
      when "110010" => op_b (63 downto 32) <= q18; op_b (31 downto 0) <= q19;
      when "110011" => op_b (63 downto 32) <= q19; op_b (31 downto 0) <= q20;
      when "110100" => op_b (63 downto 32) <= q20; op_b (31 downto 0) <= q21;
      when "110101" => op_b (63 downto 32) <= q21; op_b (31 downto 0) <= q22;
      when "110110" => op_b (63 downto 32) <= q22; op_b (31 downto 0) <= q23;
      when "110111" => op_b (63 downto 32) <= q23; op_b (31 downto 0) <= q24;
      when "111000" => op_b (63 downto 32) <= q24; op_b (31 downto 0) <= q25;
      when "111001" => op_b (63 downto 32) <= q25; op_b (31 downto 0) <= q26;
      when "111010" => op_b (63 downto 32) <= q26; op_b (31 downto 0) <= q27;
      when "111011" => op_b (63 downto 32) <= q27; op_b (31 downto 0) <= q28;
      when "111100" => op_b (63 downto 32) <= q28; op_b (31 downto 0) <= q29;
      when "111101" => op_b (63 downto 32) <= q29; op_b (31 downto 0) <= q30;
      when "111110" => op_b (63 downto 32) <= q30; op_b (31 downto 0) <= q31;
      when others  => op_b (63 downto 32) <= q31; op_b (31 downto 0) <= q31;
    end case;
  end process;

end behavior;

