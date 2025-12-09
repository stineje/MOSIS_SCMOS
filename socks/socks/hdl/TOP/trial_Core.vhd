library IEEE;
library leonlib;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use leonlib.target.all;
use leonlib.amba.all;

library toplib;
use toplib.probes.all; -- Allows the test bench to see lower level signals

entity Core_Entity is
port (
      CLK_2core : in std_logic;
      CLK2x_2core : in std_logic;
      RST_n_2core : in std_logic;
      
      UART_RxD_2core : in std_logic;
      UART_TxD_2pad  : out std_logic;
      UART_RTS_2pad  : out std_logic;
      UART_CTS_2core : in std_logic;

      EM_D0_2core : in std_logic_vector(7 downto 0);
      EM_D0_2pad : out std_logic_vector(7 downto 0);
      EM_D0_en_n : out std_logic;

      EM_D1_2core : in std_logic_vector(7 downto 0);
      EM_D1_2pad : out std_logic_vector(7 downto 0);
      EM_D1_en_n : out std_logic;

      EM_D2_2core : in std_logic_vector(7 downto 0);
      EM_D2_2pad : out std_logic_vector(7 downto 0);
      EM_D2_en_n : out std_logic;

      EM_D3_2core : in std_logic_vector(7 downto 0);
      EM_D3_2pad : out std_logic_vector(7 downto 0);
      EM_D3_en_n : out std_logic;

      EM_A_2pad       : out std_logic_vector(27 downto 0);
      EM_Ios_n_2pad   : out std_logic;
      EM_Oe_n_2pad    : out std_logic;
      EM_RamOe_n_2pad : out std_logic_vector(3 downto 0);
      EM_RamS_n_2pad  : out std_logic_vector(3 downto 0);
      EM_Read_2pad    : out std_logic;
      EM_RomS_n_2pad  : out std_logic_vector(1 downto 0);
      EM_RwE_n_2pad   : out std_logic_vector(3 downto 0);
      EM_Write_n_2pad : out std_logic
     );
end;

architecture Core_Architecture of Core_Entity is

component custom_top
port (
      clk           : in std_logic;
      rst_n         : in std_logic;
      ahbSlaveIn    : in std_logic_vector(83 downto 0);
      ahbSlaveOut   : out std_logic_vector(50 downto 0)
     );
end component;


component leon
port (
    resetn   : in    std_logic;                         -- system signals
    clk      : in    std_logic;

    clk_half : in    std_logic;  -- half speed clock
    clk_ena  : in    std_logic;  -- half speed clock used as enable

    errorn   : out   std_logic;
    address  : out   std_logic_vector(27 downto 0);     -- memory bus

    data_2pad  : out std_logic_vector(31 downto 0);
    data_2core : in std_logic_vector(31 downto 0);
    data_en_n  : out std_logic_vector(3 downto 0);

    ramsn    : out   std_logic_vector(4 downto 0);
    ramoen   : out   std_logic_vector(4 downto 0);
    rwen_2pad  : out std_logic_vector(3 downto 0);
    romsn    : out   std_logic_vector(1 downto 0);
    iosn     : out   std_logic;
    oen      : out   std_logic;
    read     : out   std_logic;
    writen_2pad : out std_logic;

    brdyn    : in    std_logic;
    bexcn    : in    std_logic;

    pio_2pad  : out std_logic_vector(15 downto 0);      -- I/O port
    pio_2core : in std_logic_vector(15 downto 0);       -- I/O port
    pio_en_n  : out std_logic_vector(15 downto 0);

    wdogn    : out   std_logic;                         -- watchdog output

    ahbsi_out: out ahb_slv_in_vector(4 to AHB_SLV_MAX-1);  -- 0, 1 used by mctrl and ahbarb
    ahbso_in : in  ahb_slv_out_vector(4 to AHB_SLV_MAX-1); -- 2,3 reserved for pci
-- MJC     ahbmi_out: out ahb_mst_in_vector(3 to AHB_MST_MAX-1);  -- 0 used by proc 1,2 used by pci
-- MJC     ahbmo_in : in  ahb_mst_out_vector(3 to AHB_MST_MAX-1);
    ahbmi_out: out ahb_mst_in_vector(1 to AHB_MST_MAX-1);  -- 0 used by proc
    ahbmo_in : in  ahb_mst_out_vector(1 to AHB_MST_MAX-1);
    ext_irq  : in  std_logic;                              -- irq (12)

    test     : in    std_logic
    );
end component;

--these are used to split the Leon bus into 8-bit chunks
signal EM_D_2pad, EM_D_2core : std_logic_vector(31 downto 0);
signal EM_D_En_n : std_logic_vector(3 downto 0);


signal pio_2core, pio_2pad : std_logic_vector(15 downto 0);
signal leon_addr_2pad : std_logic_vector(27 downto 0);
signal customSlaveIn   :  std_logic_vector(83 downto 0);

signal customSlaveOut  :  std_logic_vector(50 downto 0);


signal ahbsi_out: ahb_slv_in_vector(4 to AHB_SLV_MAX-1);  -- 0, 1 used by mctrl and ahbarb
signal ahbso_in : ahb_slv_out_vector(4 to AHB_SLV_MAX-1); -- 2,3 reserved for pci
signal ahbmi_out: ahb_mst_in_vector(1 to AHB_MST_MAX-1);  -- 0 used by proc
signal ahbmo_in : ahb_mst_out_vector(1 to AHB_MST_MAX-1);

signal leon_errorn_dummy, leon_wdogn_dummy : std_logic;
signal leon_pio_en_dummy : std_logic_vector(15 downto 0);


signal EM_RamS_n_2pad_wire, EM_RamOe_n_2pad_wire : std_logic_vector(4 downto 0);

signal vcc : std_logic := '1';
signal gnd : std_logic := '0';

begin

  vcc <= '1';
  gnd <= '0';

  -- assign amba number

  customSlaveIn  <= ahbsi_out(4).hsel & ahbsi_out(4).hwrite & ahbsi_out(4).hready & ahbsi_out(4).htrans
               & ahbsi_out(4).hsize & ahbsi_out(4).hburst & ahbsi_out(4).hprot & ahbsi_out(4).hmaster
               & ahbsi_out(4).hmastlock & ahbsi_out(4).haddr & ahbsi_out(4).hwdata;  
  
  ahbso_in(4).hready  <= customSlaveOut(1+1+1+15+1+HDMAX-1);
  ahbso_in(4).hresp   <= customSlaveOut(1+1+15+1+HDMAX-1 downto 1+15+1+HDMAX-1);
  ahbso_in(4).hrdata  <= customSlaveOut(HDMAX-1 downto 0);
  ahbso_in(4).hsplit  <= customSlaveOut(15+1+HDMAX-1 downto 1+HDMAX-1);

  EM_D0_2pad             <= EM_D_2pad(7 downto 0);
  EM_D_2core(7 downto 0) <= EM_D0_2core;
  EM_D0_en_n             <= EM_D_En_n(0);

  EM_D1_2pad             <= EM_D_2pad(15 downto 8);
  EM_D_2core(15 downto 8) <= EM_D1_2core;
  EM_D1_en_n             <= EM_D_En_n(1);

  EM_D2_2pad             <= EM_D_2pad(23 downto 16);
  EM_D_2core(23 downto 16) <= EM_D2_2core;
  EM_D2_en_n             <= EM_D_En_n(2);

  EM_D3_2pad             <= EM_D_2pad(31 downto 24);
  EM_D_2core(31 downto 24) <= EM_D3_2core;
  EM_D3_en_n             <= EM_D_En_n(3);


  custom1 : custom_top
    port map 
     (
      rst_n         => RST_n_2core,
      clk           => CLK_2core,
      ahbSlaveIn    => customSlaveIn,
      ahbSlaveOut   => customSlaveOut
     );



  pio_2core <=  '1' & UART_RxD_2core & '1' & UART_CTS_2core & "111111111111";
  UART_TxD_2pad  <= pio_2pad(15);
  UART_RTS_2pad  <= pio_2pad(13);
  EM_A_2pad      <= leon_addr_2pad(27 downto 0);
  
  EM_RamS_n_2pad <= EM_RamS_n_2pad_wire(3 downto 0);
  EM_RamOe_n_2pad <= EM_RamOe_n_2pad_wire(3 downto 0);

  leon1 : leon
    port map (
      resetn   => RST_n_2core,
      clk      => CLK2x_2core,

      clk_half => CLK_2core,
      clk_ena  => CLK_2core,

      errorn   => errorn,
      address  => leon_addr_2pad(27 downto 0),

      data_2pad  => EM_D_2pad,
      data_2core => EM_D_2core,
      data_en_n  => EM_D_En_n,

      ramsn    => EM_RamS_n_2pad_wire,
      ramoen   => EM_RamOe_n_2pad_wire,
      rwen_2pad => EM_RwE_n_2pad,
      romsn    => EM_RomS_n_2pad,
      iosn     => EM_Ios_n_2pad,
      oen      => EM_Oe_n_2pad,
      read     => EM_Read_2pad,
      writen_2pad  => EM_Write_n_2pad,

      brdyn    => gnd,
      bexcn    => vcc,

      pio_2pad  => pio_2pad,
      pio_2core => pio_2core,
      pio_en_n  => leon_pio_en_dummy,

      wdogn     => leon_wdogn_dummy,

      ahbsi_out => ahbsi_out,
      ahbso_in  => ahbso_in,
      ahbmi_out => ahbmi_out,
      ahbmo_in  => ahbmo_in,
      ext_irq   => gnd,

      test      => gnd
    );

end;
