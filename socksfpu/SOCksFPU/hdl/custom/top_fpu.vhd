-- Main module, interface with custom logic top level and AMBA bus interface

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity top_fpu is
    port (data_in   : in std_logic_vector(31 downto 0);
          clk       : in std_logic;
          reset     : in std_logic;
          address   : in std_logic_vector(4 downto 0);
          we_cpu    : in std_logic;
          match     : in std_logic;
          match_fpscr: in std_logic;
          data_out  : out std_logic_vector(31 downto 0));
end top_fpu;

architecture top_fpu of top_fpu is

component mux21_5 is
      port(a, b   			: in std_logic_vector(4 downto 0);
		     sel				   : in std_logic;
           z		     	 : out std_logic_vector(4 downto 0));
end component;

component mux21_32 is
      port(a, b   : in std_logic_vector(31 downto 0);
           sel				: in std_logic;
			  z		   : out std_logic_vector(31 downto 0));
end component;

component DFF_SR is
        port (D   : in std_logic;
              clk : in std_logic;
              reset :in std_logic;
              set : in std_logic;
              Q   : out std_logic);
end component;

component register_5bit is
    port (D   :   in std_logic_vector(4 downto 0);
          clk :   in std_logic;
          reset : in std_logic;
          set :   in std_logic;
          Q   :   out std_logic_vector(4 downto 0));
end component;

component register_27bit is
    port (D   :   in std_logic_vector(26 downto 0);
          clk :   in std_logic;
          reset : in std_logic;
          set :   in std_logic;
          Q   :   out std_logic_vector(26 downto 0));
end component;

component registerfile is
  port (addr      : in  std_logic_vector(4 downto 0);
        data_in    : in  std_logic_vector(31 downto 0);
        data_in_ext: in  std_logic_vector(31 downto 0);
        regwrite  : in  std_logic;
        clk       : in  std_logic;
        sdp       : in  std_logic;
        fpu_cpu   : in  std_logic;
        addr_a    : in  std_logic_vector(4 downto 0);
        addr_b    : in  std_logic_vector(4 downto 0);
        op_a      : out std_logic_vector(63 downto 0);
        op_b      : out std_logic_vector(63 downto 0);
        d_out     : out std_logic_vector(31 downto 0));
end component;

component fpu is
port
(  A, B:      in std_logic_vector(63 downto 0);   -- opperands
   SDP:       in std_logic;                        -- Single (0) or Double (1) Precision Select
   RM:        in std_logic_vector(1 downto 0);    -- rounding mode
   TDE:       in std_logic;             -- trap enable (1) or disable (0)
   Result:    out std_logic_vector(63 downto 0);
   OVF:       out std_logic;
   UDF:       out std_logic;
   DivZero:   out std_logic;
   Invalid:   out std_logic;
   Inexact:   out std_logic);
end component;


   signal fpu_cpu, fpscr_we, flags_we, rfwrite, clk_bar, dff_in   : std_logic;
   signal flags_fpu, rf_addr   : std_logic_vector(4 downto 0);
   signal mux_data_in, mux_data_out, fpscr_out   : std_logic_vector(31 downto 0);
   signal op_a, op_b, fpu_out   : std_logic_vector(63 downto 0);
   signal OVF, UDF, Invalid, Inexact, DivZero, SDP, TDE       : std_logic;
   signal RM    : std_logic_vector(1 downto 0);

begin

   clk_bar <= not clk;
   fpscr_we <= match_fpscr and we_cpu and reset and clk_bar;
   flags_we <= fpu_cpu and clk_bar;
   rfwrite <= (we_cpu and reset and match) or (fpu_cpu and reset);

   flags_fpu(4) <= OVF;
   flags_fpu(3) <= UDF;
   flags_fpu(2) <= Invalid;
   flags_fpu(1) <= Inexact;
   flags_fpu(0) <= DivZero;

   TDE <= fpscr_out(19);
   RM(1 downto 0) <= fpscr_out(18 downto 17);
   SDP <= fpscr_out(16);
   
   MUX_DIN : mux21_32 port map(data_in, fpu_out(63 downto 32), fpu_cpu, mux_data_in);
   mux_addr_in: mux21_5 port map(address, fpscr_out(14 downto 10), fpu_cpu, rf_addr);
   RF : registerfile port map(rf_addr, mux_data_in, fpu_out(31 downto 0), rfwrite, clk_bar, SDP, fpu_cpu, fpscr_out(4 downto 0), fpscr_out(9 downto 5), op_a, op_b, mux_data_out);
   MUX_DOUT : mux21_32 port map(mux_data_out, fpscr_out, match_fpscr, data_out);
   
   fpscr_data : register_27bit port map(data_in(26 downto 0), fpscr_we, reset, '1', fpscr_out(26 downto 0)); 
   fpscr_flags: register_5bit port map(flags_fpu, flags_we, reset, '1', fpscr_out(31 downto 27));

-- Floating Point Unit

   fpu0 : fpu port map(op_a, op_b, fpscr_out(16), RM, TDE, fpu_out, OVF, UDF, DivZero, Invalid, Inexact);
   
-- Small FSM to control input to RF from CPU or FPU

   fpu_cpu_fsm: DFF_SR port map(dff_in, clk, reset, '1', fpu_cpu);
   dff_in <= reset and we_cpu and match_fpscr and (not fpu_cpu);

end top_fpu;
