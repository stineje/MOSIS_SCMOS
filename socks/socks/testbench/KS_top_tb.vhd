-- @(#) KS_top_tb.vhd 1.27@(#)
-- ==================================================================
-- SCCS Path and File Name: /projects/ks/.sccs/s.KS_top_tb.vhd
-- File Name: KS_top_tb.vhd
-- SCCS File Release: 1 at Version: 27
-- Last Modified: 05/29/02 at 14:00:29
-- SCCS-get Executed on 09/27/02 at 16:13:56 to Get this File
--
-- ******************************************************************
-- *                        JTA Research Inc                        *
-- *                 Copyright (c) JTA Research Inc                 *
-- ******************************************************************
--
-- Description: The Million Gate project top level testbench
--
-- Level: Testbench
--
-- Class: Unknown
--
-- Revision History:
-- Date          By        Change
-- -----------   --------  ----------------------------------------
-- Dec 05 2001   mcynar    initial
-- Dec 06 2001   mcynar    Added the rom32 instance
-- Dec 11 2001   mcynar    Un-commented the KS instance
-- Dec 11 2001   mcynar    Added the ram32 instance
-- Dec 11 2001   mcynar    Added the test module block
-- Dec 13 2001   mcynar    Added the trigger for the RX block
--                         Added the probes packege to probe errorn
-- Dec 27 2001   mcynar    Increased MG clock to 125Mhz. Added USB clock
-- Jan 07 2002   mcynar    Added the VGA/LCD output monitor.
--                         Added the pixel clock generator.
-- Jan 11 2002   mcynar    Added video memory
-- Jan 11 2002   mcynar    Added HDD monitor to write HDD data to a file
-- Jan 21 2002   mcynar    Modified testmod name.
-- Jan 22 2002   mcynar    Replaced the vga_lcd video memory model with TSMC
--                         dual port memory
-- Jan 28 2002   mcynar    Added the USB snooper
-- Jan 30 2002   mcynar    Vid mem modifications
-- Feb 04 2002   mcynar    Added the VGA_LCD video memory model to verify the VGA block
--                         Commented out the MII2 assignments
--                         Routed MII1_RxClk to MII2_RxClk
-- Feb 04 2002   mcynar    Added the MII2 transmit monitor
-- Feb 04 2002   mcynar    Modified the KS_top port list to align with rtl_3
-- Feb 04 2002   mcynar    Modified component iram to KS_top_iram
-- Feb 06 2002   mcynar    Added MII TxClk generation logic. Modified Video Memory connetctions
--                         Increased program memory depth
-- Feb 11 2002   mcynar    Modified dual port memory instance
--                         Cleaned up code
-- Feb 13 2002   mcynar    Modified to migrate to rtl4
-- Feb 14 2002   mcynar    Delayed the RX packet stream to 86,080 ns
-- Feb 21 2002   mcynar    Added a second RX block to stream RX data into MAC 2
-- Feb 25 2002   mcynar    Modified to migrate to rtl 10
-- May 23 2002   mcynar    Added vidmem_clk so the DP video mem will sample data/control signals on
--                         the falling edge of the system clock
--                         Moved system reset release to falling edge of system clock
--                         Added weak low pull downs on the data busses wo they are always
--                         in a known state.
-- May 28 2002   mcynar    Mods to use asynch mem model for vid mem
-- Dec 16 2002   mcynar    Added clk2x generation. Modified the MII clocks and rx_blocks to
--                         create the MII rx clocks in the top level test bench.
-- Dec 17 2002   mcynar    Added a phy clock period generic for the usb_snooper block
-- EOL
-- ==================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use STD.TEXTIO.all;
use STD.TEXTIO.all;

library toplib;
use toplib.probes.all;

entity KS_top_tb is
   generic (
      romfile   : string := "tsource/rom.dat";  -- rom contents
      ramfile   : string := "tsource/ram.dat";  -- ram contents
      romwidth  : integer := 32;                -- rom data width (8/32)
      romdepth  : integer := 13;                -- rom address depth
      romtacc   : integer := 10;                -- rom access time (ns)
      ramwidth  : integer := 32;                -- ram data width (8/16/32)
      ramdepth  : integer := 16;                -- ram address depth
      rambanks  : integer := 4;                 -- number of ram banks
      --bytewrite : boolean := true;              -- individual byte write strobes
      ramtacc   : integer := 10                 -- ram access time (ns)
   );
end;

architecture KS_top_tb_arch of KS_top_tb is

--************************************************************
--
--                     Constants
--
--************************************************************
-- Clock Periods
constant clk_period          : time := 8 ns;  -- MG system clock
constant clk2x_period        : time := 4 ns;  -- Leon core clock

-- For inputs
constant bad_data            : std_logic_vector(31 downto 0) := "10111010110100000000101101011101";


--************************************************************
--
--                     component
--
--************************************************************

component KS_top
   port (
      clk    : in std_logic;
      clk2x  : in std_logic;

      rst_n  : in std_logic;
   
      UART_RxD : in std_logic;
      UART_TxD : out std_logic;
      UART_RTS : out std_logic;
      UART_CTS : in std_logic;

      EM_D0 : inout std_logic_vector(7 downto 0);
      EM_D1 : inout std_logic_vector(7 downto 0);
      EM_D2 : inout std_logic_vector(7 downto 0);
      EM_D3 : inout std_logic_vector(7 downto 0);
      EM_A       : out std_logic_vector(27 downto 0);
      EM_Ios_n   : out std_logic;
      EM_Oe_n    : out std_logic;
      EM_RamOe_n : out std_logic_vector(3 downto 0);
      EM_RamS_n  : out std_logic_vector(3 downto 0);
      EM_Read    : out std_logic;
      EM_RomS_n  : out std_logic_vector(1 downto 0);
      EM_RwE_n   : out std_logic_vector(3 downto 0);
      EM_Write_n : out std_logic

   );
end component;

component KS_top_iram
   generic (
      index : integer := 0;         -- Byte lane (0 - 3)
      Abits: Positive := 10;        -- Default 10 address bits (1 Kbyte)
      echk : integer := 0;          -- Generate EDAC checksum
      tacc : integer := 10;         -- access time (ns)
      fname : string := "ram.dat"   -- File to read from
   );
   port (
      A : in std_logic_vector;
      D : inout std_logic_vector(7 downto 0);
      CE1 : in std_logic;
      WE : in std_logic;
      OE : in std_logic
   );
end component;

component KS_top_msg
   port (
      error   : in    std_logic;
      iosn    : in    std_logic;
      oen     : in    std_logic;
      read    : in    std_logic;
      writen  : in    std_logic;
      brdyn   : out   std_logic;
      bexcn   : out   std_logic;
      address : in    std_logic_vector(7 downto 0);
      data    : inout std_logic_vector(31 downto 0);
      ioport  : out   std_logic_vector(15 downto 0)
   );
end component;

--************************************************************
--
--                     Signal
--
--************************************************************
signal clk      : std_logic := '0';
signal clk2x    : std_logic := '0';

signal rst_n    : std_logic := '0';         -- Reset

signal address  : std_logic_vector(27 downto 0);
signal data     : std_logic_vector(31 downto 0);

signal ramsn    : std_logic_vector(3 downto 0);
signal ramoen   : std_logic_vector(3 downto 0);
signal rwen     : std_logic_vector(3 downto 0);
signal rwenx    : std_logic_vector(3 downto 0);
signal romsn    : std_logic_vector(1 downto 0);
signal iosn     : std_logic;
signal oen      : std_logic;
signal read     : std_logic;
signal writen   : std_logic;
signal brdyn    : std_logic;
signal bexcn    : std_logic;
signal wdog     : std_logic;
signal error    : std_logic;
signal pio      : std_logic_vector(15 downto 0);
signal GND      : std_logic := '0';
signal VCC      : std_logic := '1';
signal NC       : std_logic := 'Z';
signal clk2     : std_logic := '1';
   
signal UART_RxD : std_logic;
signal UART_TxD : std_logic;
signal UART_RTS : std_logic;
signal UART_CTS : std_logic;

signal EM_D       : std_logic_vector(31 downto 0);
signal EM_Q       : std_logic_vector(31 downto 0);
signal EM_A       : std_logic_vector(31 downto 0);
signal EM_Ios_n   : std_logic;
signal EM_Oe_n    : std_logic;
signal EM_RamOe_n : std_logic_vector(3 downto 0);
signal EM_RamS_n  : std_logic_vector(3 downto 0);
signal EM_Read    : std_logic;
signal EM_RomS_n  : std_logic_vector(1 downto 0);
signal EM_RwE_n   : std_logic_vector(3 downto 0);
signal EM_Write_n : std_logic;


signal high_nibble       : std_logic_vector(3 downto 0);
signal high              : std_logic;
signal low               : std_logic;

begin

   high <= '1';
   high_nibble <= "0000";
   low  <= '0';

   EM_A(31 downto 28) <= "0000";

   UART_RxD <= '0';
   UART_CTS <= '0';


   -------------------------------
   -- Main control process
   -------------------------------
   main : process
      --variable OUT_BUF:LINE;
   begin
      rst_n <= '0';
      wait for clk_period * 10.5;
      rst_n <= '1';
      wait for 100 ms;
   end process;

   -------------------------------
   -- Generate the chip clock
   -------------------------------
   process
   begin
      clk <= '0';
      wait for clk_period*0.5;
      clk <= '1';
      wait for clk_period*0.5;
   end process;

   -------------------------------
   -- Generate the controller clock
   -------------------------------
   process
   begin
      clk2x <= '1';
      wait for clk2x_period*0.5;
      clk2x <= '0';
      wait for clk2x_period*0.5;
   end process;

   -------------------------------
   -- Program memory
   -------------------------------
   ram32d : if ramwidth = 32 generate
      rambnk : for i in 0 to rambanks-1 generate -- 0 to 3
         ramarr : for j in 0 to 3 generate
            ram0 : KS_top_iram
            generic map (
               index => j,
               abits => ramdepth, -- 2^ramdepth = # BYTES per iram cell 
               echk  => 0,
               tacc  => ramtacc,
               fname => "./tsource/ram.dat"
            )
            port map (
               A   => EM_A(ramdepth+1 downto 2),
               D   => EM_D( (31-j*8) downto (24-j*8) ),
               CE1 => EM_RamS_n(i),
               WE  => EM_RwE_n(j),
               OE  => EM_RamOe_n(i)
            );
         end generate;
      end generate;
   end generate;
   
   -------------------------------
   -- Boot ROM
   -------------------------------
   rom32d : if romwidth = 32 generate
      romarr : for i in 0 to 3 generate
         rom0 : KS_top_iram
         generic map (
            index => i,
            abits => romdepth,
            echk => 0,
            tacc => romtacc,
            fname => "./tsource/rom.dat" 
         )
         port map ( 
            A => EM_A(romdepth+1 downto 2),
            D => EM_D((31 - i*8) downto (24-i*8)),
            CE1 => EM_RomS_n(0),
            WE => high,
            OE => EM_Oe_n
         );
      end generate;
   end generate;

   -------------------------------
   -- IO test module
   -------------------------------
   testmod0 : KS_top_msg
      port map (
         error   => errorn,
         iosn    => EM_Ios_n,
         oen     => EM_Oe_n,
         read    => EM_Read,
         writen  => EM_Write_n,
         brdyn   => open,
         bexcn   => open,
         address => EM_A(7 downto 0),
         data    => EM_D,
         ioport  => open
      );


   -------------------------------
   -- The MG chip
   -------------------------------
   KS_top_inst: KS_top
      port map(
         clk    => clk,
         clk2x  => clk2x,
         rst_n  => rst_n,

         UART_RxD   => UART_RxD,
         UART_TxD   => UART_TxD,
         UART_RTS   => UART_RTS,
         UART_CTS   => UART_CTS,

         EM_A       => EM_A(27 downto 0),
         EM_D0       => EM_D(7 downto 0),
         EM_D1       => EM_D(15 downto 8),
         EM_D2       => EM_D(23 downto 16),
         EM_D3       => EM_D(31 downto 24),
         EM_Ios_n   => EM_Ios_n,
         EM_Oe_n    => EM_Oe_n,
         EM_RamOe_n => EM_RamOe_n,
         EM_RamS_n  => EM_RamS_n,
         EM_Read    => EM_Read,
         EM_RomS_n  => EM_RomS_n,
         EM_RwE_n   => EM_RwE_n,
         EM_Write_n => EM_Write_n

      );

end;
