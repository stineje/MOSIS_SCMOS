-- trial_PadRing.vhd 

library IEEE;
use IEEE.std_logic_1164.all;
use STD.TEXTIO.all;

entity PadRing_Entity is
port (
    -- ==> Port declarations
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
end PadRing_Entity;

architecture PadRing_Architecture of PadRing_Entity is
    component PDUDGZ
    port (
        PAD : in std_logic;
        Y : out std_logic
    );
    end component;

    component PDO08CDG
    port (
        PAD : out std_logic;
        A : in std_logic
    );
    end component;

    component PCI66DGZ
    port (
        PAD : inout std_logic;
        Y : out std_logic;
        EN : in std_logic;
        A : in std_logic
    );
    end component;

    -- ==> Internal signal declarations
    signal pull_lo : std_logic;

begin

    -- ==> Signal assign statements
    pull_lo <= '0';

    -- ==> Pad Instantiation

    pad34EM_A_27 : PDO08CDG
    port map (
        PAD => EM_A(27),
        A => EM_A_2pad(27)
    );

    pad35EM_A_26 : PDO08CDG
    port map (
        PAD => EM_A(26),
        A => EM_A_2pad(26)
    );

    pad36EM_A_25 : PDO08CDG
    port map (
        PAD => EM_A(25),
        A => EM_A_2pad(25)
    );

    pad37EM_A_24 : PDO08CDG
    port map (
        PAD => EM_A(24),
        A => EM_A_2pad(24)
    );

    pad40EM_A_23 : PDO08CDG
    port map (
        PAD => EM_A(23),
        A => EM_A_2pad(23)
    );

    pad41EM_A_22 : PDO08CDG
    port map (
        PAD => EM_A(22),
        A => EM_A_2pad(22)
    );

    pad42EM_A_21 : PDO08CDG
    port map (
        PAD => EM_A(21),
        A => EM_A_2pad(21)
    );

    pad43EM_A_20 : PDO08CDG
    port map (
        PAD => EM_A(20),
        A => EM_A_2pad(20)
    );

    pad44EM_A_19 : PDO08CDG
    port map (
        PAD => EM_A(19),
        A => EM_A_2pad(19)
    );

    pad45EM_A_18 : PDO08CDG
    port map (
        PAD => EM_A(18),
        A => EM_A_2pad(18)
    );

    pad46EM_A_17 : PDO08CDG
    port map (
        PAD => EM_A(17),
        A => EM_A_2pad(17)
    );

    pad47EM_A_16 : PDO08CDG
    port map (
        PAD => EM_A(16),
        A => EM_A_2pad(16)
    );

    pad48EM_A_15 : PDO08CDG
    port map (
        PAD => EM_A(15),
        A => EM_A_2pad(15)
    );

    pad49EM_A_14 : PDO08CDG
    port map (
        PAD => EM_A(14),
        A => EM_A_2pad(14)
    );

    pad52EM_A_13 : PDO08CDG
    port map (
        PAD => EM_A(13),
        A => EM_A_2pad(13)
    );

    pad53EM_A_12 : PDO08CDG
    port map (
        PAD => EM_A(12),
        A => EM_A_2pad(12)
    );

    pad54EM_A_11 : PDO08CDG
    port map (
        PAD => EM_A(11),
        A => EM_A_2pad(11)
    );

    pad55EM_A_10 : PDO08CDG
    port map (
        PAD => EM_A(10),
        A => EM_A_2pad(10)
    );

    pad56EM_A_9 : PDO08CDG
    port map (
        PAD => EM_A(9),
        A => EM_A_2pad(9)
    );

    pad57EM_A_8 : PDO08CDG
    port map (
        PAD => EM_A(8),
        A => EM_A_2pad(8)
    );

    pad58EM_A_7 : PDO08CDG
    port map (
        PAD => EM_A(7),
        A => EM_A_2pad(7)
    );

    pad59EM_A_6 : PDO08CDG
    port map (
        PAD => EM_A(6),
        A => EM_A_2pad(6)
    );

    pad60EM_A_5 : PDO08CDG
    port map (
        PAD => EM_A(5),
        A => EM_A_2pad(5)
    );

    pad61EM_A_4 : PDO08CDG
    port map (
        PAD => EM_A(4),
        A => EM_A_2pad(4)
    );

    pad64EM_A_3 : PDO08CDG
    port map (
        PAD => EM_A(3),
        A => EM_A_2pad(3)
    );

    pad65EM_A_2 : PDO08CDG
    port map (
        PAD => EM_A(2),
        A => EM_A_2pad(2)
    );

    pad66EM_A_1 : PDO08CDG
    port map (
        PAD => EM_A(1),
        A => EM_A_2pad(1)
    );

    pad67EM_A_0 : PDO08CDG
    port map (
        PAD => EM_A(0),
        A => EM_A_2pad(0)
    );

    pad68EM_Ios_n : PDO08CDG
    port map (
        PAD => EM_Ios_n,
        A => EM_Ios_n_2pad
    );

    pad69EM_Oe_n : PDO08CDG
    port map (
        PAD => EM_Oe_n,
        A => EM_Oe_n_2pad
    );

    pad70EM_RamOe_n_3 : PDO08CDG
    port map (
        PAD => EM_RamOe_n(3),
        A => EM_RamOe_n_2pad(3)
    );

    pad71EM_RamOe_n_2 : PDO08CDG
    port map (
        PAD => EM_RamOe_n(2),
        A => EM_RamOe_n_2pad(2)
    );

    pad72EM_RamOe_n_1 : PDO08CDG
    port map (
        PAD => EM_RamOe_n(1),
        A => EM_RamOe_n_2pad(1)
    );

    pad73EM_RamOe_n_0 : PDO08CDG
    port map (
        PAD => EM_RamOe_n(0),
        A => EM_RamOe_n_2pad(0)
    );

    pad76EM_RamS_n_3 : PDO08CDG
    port map (
        PAD => EM_RamS_n(3),
        A => EM_RamS_n_2pad(3)
    );

    pad77EM_RamS_n_2 : PDO08CDG
    port map (
        PAD => EM_RamS_n(2),
        A => EM_RamS_n_2pad(2)
    );

    pad78EM_RamS_n_1 : PDO08CDG
    port map (
        PAD => EM_RamS_n(1),
        A => EM_RamS_n_2pad(1)
    );

    pad79EM_RamS_n_0 : PDO08CDG
    port map (
        PAD => EM_RamS_n(0),
        A => EM_RamS_n_2pad(0)
    );

    pad80EM_Read : PDO08CDG
    port map (
        PAD => EM_Read,
        A => EM_Read_2pad
    );

    pad81EM_RomS_n_1 : PDO08CDG
    port map (
        PAD => EM_RomS_n(1),
        A => EM_RomS_n_2pad(1)
    );

    pad82EM_RomS_n_0 : PDO08CDG
    port map (
        PAD => EM_RomS_n(0),
        A => EM_RomS_n_2pad(0)
    );

    pad83EM_RwE_n_3 : PDO08CDG
    port map (
        PAD => EM_RwE_n(3),
        A => EM_RwE_n_2pad(3)
    );

    pad84EM_RwE_n_2 : PDO08CDG
    port map (
        PAD => EM_RwE_n(2),
        A => EM_RwE_n_2pad(2)
    );

    pad85EM_RwE_n_1 : PDO08CDG
    port map (
        PAD => EM_RwE_n(1),
        A => EM_RwE_n_2pad(1)
    );

    pad90EM_RwE_n_0 : PDO08CDG
    port map (
        PAD => EM_RwE_n(0),
        A => EM_RwE_n_2pad(0)
    );


    pad92EM_Write_n : PDO08CDG
    port map (
        PAD => EM_Write_n,
        A => EM_Write_n_2pad
    );


    pad265CLK : PDUDGZ
    port map (
        PAD => CLK,
        Y => CLK_2core
    );

    pad266RST_n : PDUDGZ
    port map (
        PAD => RST_n,
        Y => RST_n_2core
    );

    pad267EM_D0_7 : PCI66DGZ
    port map (
        PAD => EM_D0(7),
        Y => EM_D0_2core(7),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(7)
    );

    pad268EM_D0_6 : PCI66DGZ
    port map (
        PAD => EM_D0(6),
        Y => EM_D0_2core(6),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(6)
    );

    pad269EM_D0_5 : PCI66DGZ
    port map (
        PAD => EM_D0(5),
        Y => EM_D0_2core(5),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(5)
    );

    pad270EM_D0_4 : PCI66DGZ
    port map (
        PAD => EM_D0(4),
        Y => EM_D0_2core(4),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(4)
    );

    pad271EM_D0_3 : PCI66DGZ
    port map (
        PAD => EM_D0(3),
        Y => EM_D0_2core(3),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(3)
    );

    pad274EM_D0_2 : PCI66DGZ
    port map (
        PAD => EM_D0(2),
        Y => EM_D0_2core(2),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(2)
    );

    pad275EM_D0_1 : PCI66DGZ
    port map (
        PAD => EM_D0(1),
        Y => EM_D0_2core(1),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(1)
    );

    pad276EM_D0_0 : PCI66DGZ
    port map (
        PAD => EM_D0(0),
        Y => EM_D0_2core(0),
        EN => EM_D0_en_n,
        A => EM_D0_2pad(0)
    );

    pad277EM_D1_7 : PCI66DGZ
    port map (
        PAD => EM_D1(7),
        Y => EM_D1_2core(7),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(7)
    );

    pad278EM_D1_6 : PCI66DGZ
    port map (
        PAD => EM_D1(6),
        Y => EM_D1_2core(6),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(6)
    );

    pad279EM_D1_5 : PCI66DGZ
    port map (
        PAD => EM_D1(5),
        Y => EM_D1_2core(5),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(5)
    );

    pad280EM_D1_4 : PCI66DGZ
    port map (
        PAD => EM_D1(4),
        Y => EM_D1_2core(4),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(4)
    );

    pad281EM_D1_3 : PCI66DGZ
    port map (
        PAD => EM_D1(3),
        Y => EM_D1_2core(3),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(3)
    );

    pad284EM_D1_2 : PCI66DGZ
    port map (
        PAD => EM_D1(2),
        Y => EM_D1_2core(2),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(2)
    );

    pad285EM_D1_1 : PCI66DGZ
    port map (
        PAD => EM_D1(1),
        Y => EM_D1_2core(1),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(1)
    );

    pad286EM_D1_0 : PCI66DGZ
    port map (
        PAD => EM_D1(0),
        Y => EM_D1_2core(0),
        EN => EM_D1_en_n,
        A => EM_D1_2pad(0)
    );

    pad287EM_D2_7 : PCI66DGZ
    port map (
        PAD => EM_D2(7),
        Y => EM_D2_2core(7),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(7)
    );

    pad288EM_D2_6 : PCI66DGZ
    port map (
        PAD => EM_D2(6),
        Y => EM_D2_2core(6),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(6)
    );

    pad289EM_D2_5 : PCI66DGZ
    port map (
        PAD => EM_D2(5),
        Y => EM_D2_2core(5),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(5)
    );

    pad290EM_D2_4 : PCI66DGZ
    port map (
        PAD => EM_D2(4),
        Y => EM_D2_2core(4),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(4)
    );

    pad291EM_D2_3 : PCI66DGZ
    port map (
        PAD => EM_D2(3),
        Y => EM_D2_2core(3),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(3)
    );

    pad294EM_D2_2 : PCI66DGZ
    port map (
        PAD => EM_D2(2),
        Y => EM_D2_2core(2),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(2)
    );

    pad295EM_D2_1 : PCI66DGZ
    port map (
        PAD => EM_D2(1),
        Y => EM_D2_2core(1),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(1)
    );

    pad296EM_D2_0 : PCI66DGZ
    port map (
        PAD => EM_D2(0),
        Y => EM_D2_2core(0),
        EN => EM_D2_en_n,
        A => EM_D2_2pad(0)
    );

    pad297EM_D3_7 : PCI66DGZ
    port map (
        PAD => EM_D3(7),
        Y => EM_D3_2core(7),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(7)
    );

    pad298EM_D3_6 : PCI66DGZ
    port map (
        PAD => EM_D3(6),
        Y => EM_D3_2core(6),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(6)
    );

    pad299EM_D3_5 : PCI66DGZ
    port map (
        PAD => EM_D3(5),
        Y => EM_D3_2core(5),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(5)
    );

    pad300EM_D3_4 : PCI66DGZ
    port map (
        PAD => EM_D3(4),
        Y => EM_D3_2core(4),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(4)
    );

    pad301EM_D3_3 : PCI66DGZ
    port map (
        PAD => EM_D3(3),
        Y => EM_D3_2core(3),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(3)
    );

    pad302EM_D3_2 : PCI66DGZ
    port map (
        PAD => EM_D3(2),
        Y => EM_D3_2core(2),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(2)
    );

    pad305EM_D3_1 : PCI66DGZ
    port map (
        PAD => EM_D3(1),
        Y => EM_D3_2core(1),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(1)
    );

    pad306EM_D3_0 : PCI66DGZ
    port map (
        PAD => EM_D3(0),
        Y => EM_D3_2core(0),
        EN => EM_D3_en_n,
        A => EM_D3_2pad(0)
    );

    pad307UART_RxD : PDUDGZ
    port map (
        PAD => UART_RxD,
        Y => UART_RxD_2core
    );

    pad308UART_TxD : PDO08CDG
    port map (
        PAD => UART_TxD,
        A => UART_TxD_2pad
    );

    pad309UART_RTS : PDO08CDG
    port map (
        PAD => UART_RTS,
        A => UART_RTS_2pad
    );

    pad310UART_CTS : PDUDGZ
    port map (
        PAD => UART_CTS,
        Y => UART_CTS_2core
    );

    pad347CLK2x : PDUDGZ
    port map (
        PAD => CLK2x,
        Y => CLK2x_2core
    );

end PadRing_Architecture;
