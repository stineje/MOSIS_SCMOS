-- trial_Asic.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use STD.TEXTIO.all;

entity Asic_Entity is
port (
    -- ==> Port Declarations
    CLK : in std_logic;
    CLK2x : in std_logic;
    EM_A : out std_logic_vector(27 downto 0);
    EM_D0 : inout std_logic_vector(7 downto 0);
    EM_D1 : inout std_logic_vector(7 downto 0);
    EM_D2 : inout std_logic_vector(7 downto 0);
    EM_D3 : inout std_logic_vector(7 downto 0);
    EM_Ios_n : out std_logic;
    EM_Oe_n : out std_logic;
    EM_RamOe_n : out std_logic_vector(3 downto 0);
    EM_RamS_n : out std_logic_vector(3 downto 0);
    EM_Read : out std_logic;
    EM_RomS_n : out std_logic_vector(1 downto 0);
    EM_RwE_n : out std_logic_vector(3 downto 0);
    EM_Write_n : out std_logic;
    RST_n : in std_logic;
    UART_CTS : in std_logic;
    UART_RTS : out std_logic;
    UART_RxD : in std_logic;
    UART_TxD : out std_logic
);
end Asic_Entity;

architecture Asic_Architecture of Asic_Entity is
    component PadRing_Entity
    port (
        -- ==> Goes to asic
        CLK : in std_logic;
        CLK2x : in std_logic;
        EM_A : out std_logic_vector(27 downto 0);
        EM_D0 : inout std_logic_vector(7 downto 0);
        EM_D1 : inout std_logic_vector(7 downto 0);
        EM_D2 : inout std_logic_vector(7 downto 0);
        EM_D3 : inout std_logic_vector(7 downto 0);
        EM_Ios_n : out std_logic;
        EM_Oe_n : out std_logic;
        EM_RamOe_n : out std_logic_vector(3 downto 0);
        EM_RamS_n : out std_logic_vector(3 downto 0);
        EM_Read : out std_logic;
        EM_RomS_n : out std_logic_vector(1 downto 0);
        EM_RwE_n : out std_logic_vector(3 downto 0);
        EM_Write_n : out std_logic;
        RST_n : in std_logic;
        UART_CTS : in std_logic;
        UART_RTS : out std_logic;
        UART_RxD : in std_logic;
        UART_TxD : out std_logic;

        -- ==> Goes to core
        CLK_2core : out std_logic;
        CLK2x_2core : out std_logic;
        EM_A_2pad : in std_logic_vector(27 downto 0);
        EM_D0_2core : out std_logic_vector(7 downto 0);
        EM_D0_2pad : in std_logic_vector(7 downto 0);
        EM_D0_en_n : in std_logic;
        EM_D1_2core : out std_logic_vector(7 downto 0);
        EM_D1_2pad : in std_logic_vector(7 downto 0);
        EM_D1_en_n : in std_logic;
        EM_D2_2core : out std_logic_vector(7 downto 0);
        EM_D2_2pad : in std_logic_vector(7 downto 0);
        EM_D2_en_n : in std_logic;
        EM_D3_2core : out std_logic_vector(7 downto 0);
        EM_D3_2pad : in std_logic_vector(7 downto 0);
        EM_D3_en_n : in std_logic;
        EM_Ios_n_2pad : in std_logic;
        EM_Oe_n_2pad : in std_logic;
        EM_RamOe_n_2pad : in std_logic_vector(3 downto 0);
        EM_RamS_n_2pad : in std_logic_vector(3 downto 0);
        EM_Read_2pad : in std_logic;
        EM_RomS_n_2pad : in std_logic_vector(1 downto 0);
        EM_RwE_n_2pad : in std_logic_vector(3 downto 0);
        EM_Write_n_2pad : in std_logic;
        RST_n_2core : out std_logic;
        UART_CTS_2core : out std_logic;
        UART_RTS_2pad : in std_logic;
        UART_RxD_2core : out std_logic;
        UART_TxD_2pad : in std_logic
    );
    end component;

    component Core_Entity
    port (
        -- ==> Goes to core
        CLK_2core : in std_logic;
        CLK2x_2core : in std_logic;

        EM_A_2pad : out std_logic_vector(27 downto 0);

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

        EM_Ios_n_2pad : out std_logic;

        EM_Oe_n_2pad : out std_logic;

        EM_RamOe_n_2pad : out std_logic_vector(3 downto 0);

        EM_RamS_n_2pad : out std_logic_vector(3 downto 0);

        EM_Read_2pad : out std_logic;

        EM_RomS_n_2pad : out std_logic_vector(1 downto 0);

        EM_RwE_n_2pad : out std_logic_vector(3 downto 0);

        EM_Write_n_2pad : out std_logic;

        RST_n_2core : in std_logic;

        UART_CTS_2core : in std_logic;

        UART_RTS_2pad : out std_logic;

        UART_RxD_2core : in std_logic;

        UART_TxD_2pad : out std_logic

    );
    end component;

    -- ==> Signal declarations
    -- ==> Signals that connect the Core to the PadRing
    signal CLK_2core : std_logic;
    signal CLK2x_2core : std_logic;

    signal EM_A_2pad : std_logic_vector(27 downto 0);

    signal EM_D0_2core : std_logic_vector(7 downto 0);
    signal EM_D0_2pad : std_logic_vector(7 downto 0);
    signal EM_D0_en_n : std_logic;

    signal EM_D1_2core : std_logic_vector(7 downto 0);
    signal EM_D1_2pad : std_logic_vector(7 downto 0);
    signal EM_D1_en_n : std_logic;

    signal EM_D2_2core : std_logic_vector(7 downto 0);
    signal EM_D2_2pad : std_logic_vector(7 downto 0);
    signal EM_D2_en_n : std_logic;

    signal EM_D3_2core : std_logic_vector(7 downto 0);
    signal EM_D3_2pad : std_logic_vector(7 downto 0);
    signal EM_D3_en_n : std_logic;

    signal EM_Ios_n_2pad : std_logic;

    signal EM_Oe_n_2pad : std_logic;

    signal EM_RamOe_n_2pad : std_logic_vector(3 downto 0);

    signal EM_RamS_n_2pad : std_logic_vector(3 downto 0);

    signal EM_Read_2pad : std_logic;

    signal EM_RomS_n_2pad : std_logic_vector(1 downto 0);

    signal EM_RwE_n_2pad : std_logic_vector(3 downto 0);

    signal EM_Write_n_2pad : std_logic;

    signal RST_n_2core : std_logic;

    signal UART_CTS_2core : std_logic;

    signal UART_RTS_2pad : std_logic;

    signal UART_RxD_2core : std_logic;

    signal UART_TxD_2pad : std_logic;

begin

    RingInst : PadRing_Entity
    port map (
        -- ==> Goes to asic
        CLK => CLK,
        CLK2x => CLK2x,
        EM_A => EM_A,
        EM_D0 => EM_D0,
        EM_D1 => EM_D1,
        EM_D2 => EM_D2,
        EM_D3 => EM_D3,
        EM_Ios_n => EM_Ios_n,
        EM_Oe_n => EM_Oe_n,
        EM_RamOe_n => EM_RamOe_n,
        EM_RamS_n => EM_RamS_n,
        EM_Read => EM_Read,
        EM_RomS_n => EM_RomS_n,
        EM_RwE_n => EM_RwE_n,
        EM_Write_n => EM_Write_n,
        RST_n => RST_n,
        UART_CTS => UART_CTS,
        UART_RTS => UART_RTS,
        UART_RxD => UART_RxD,
        UART_TxD => UART_TxD,

        -- ==> Goes to core
        CLK_2core => CLK_2core,
        CLK2x_2core => CLK2x_2core,
        EM_A_2pad => EM_A_2pad,
        EM_D0_2core => EM_D0_2core,
        EM_D0_2pad => EM_D0_2pad,
        EM_D0_en_n => EM_D0_en_n,
        EM_D1_2core => EM_D1_2core,
        EM_D1_2pad => EM_D1_2pad,
        EM_D1_en_n => EM_D1_en_n,
        EM_D2_2core => EM_D2_2core,
        EM_D2_2pad => EM_D2_2pad,
        EM_D2_en_n => EM_D2_en_n,
        EM_D3_2core => EM_D3_2core,
        EM_D3_2pad => EM_D3_2pad,
        EM_D3_en_n => EM_D3_en_n,
        EM_Ios_n_2pad => EM_Ios_n_2pad,
        EM_Oe_n_2pad => EM_Oe_n_2pad,
        EM_RamOe_n_2pad => EM_RamOe_n_2pad,
        EM_RamS_n_2pad => EM_RamS_n_2pad,
        EM_Read_2pad => EM_Read_2pad,
        EM_RomS_n_2pad => EM_RomS_n_2pad,
        EM_RwE_n_2pad => EM_RwE_n_2pad,
        EM_Write_n_2pad => EM_Write_n_2pad,
        RST_n_2core => RST_n_2core,
        UART_CTS_2core => UART_CTS_2core,
        UART_RTS_2pad => UART_RTS_2pad,
        UART_RxD_2core => UART_RxD_2core,
        UART_TxD_2pad => UART_TxD_2pad
    );

    CoreInst : Core_Entity
    port map (
        -- ==> Goes to core
        CLK_2core => CLK_2core,
        CLK2x_2core => CLK2x_2core,

        EM_A_2pad => EM_A_2pad,

        EM_D0_2core => EM_D0_2core,
        EM_D0_2pad => EM_D0_2pad,
        EM_D0_en_n => EM_D0_en_n,

        EM_D1_2core => EM_D1_2core,
        EM_D1_2pad => EM_D1_2pad,
        EM_D1_en_n => EM_D1_en_n,

        EM_D2_2core => EM_D2_2core,
        EM_D2_2pad => EM_D2_2pad,
        EM_D2_en_n => EM_D2_en_n,

        EM_D3_2core => EM_D3_2core,
        EM_D3_2pad => EM_D3_2pad,
        EM_D3_en_n => EM_D3_en_n,

        EM_Ios_n_2pad => EM_Ios_n_2pad,

        EM_Oe_n_2pad => EM_Oe_n_2pad,

        EM_RamOe_n_2pad => EM_RamOe_n_2pad,

        EM_RamS_n_2pad => EM_RamS_n_2pad,

        EM_Read_2pad => EM_Read_2pad,

        EM_RomS_n_2pad => EM_RomS_n_2pad,

        EM_RwE_n_2pad => EM_RwE_n_2pad,

        EM_Write_n_2pad => EM_Write_n_2pad,

        RST_n_2core => RST_n_2core,

        UART_CTS_2core => UART_CTS_2core,

        UART_RTS_2pad => UART_RTS_2pad,

        UART_RxD_2core => UART_RxD_2core,

        UART_TxD_2pad => UART_TxD_2pad

    );

end Asic_Architecture;

