LIBRARY ieee;
Use ieee.std_logic_1164.all;

Entity fourbitcarryblock is
  Port( PIn, GIn : in std_logic_vector(3 downto 0);
        CIn : in std_logic;
        COut : out std_logic_vector(3 downto 1);
        POut, GOut : out std_logic);
end fourbitcarryblock;

architecture struct of fourbitcarryblock is

begin  -- struct

  GOut <= GIn(3) or (GIn(2) and PIn(3)) or (GIn(1) and PIn(3) and PIn(2)) or (GIn(0) and PIn(3) and PIn(2) and PIn(1));

  POut <= PIn(0) and PIn(1) and PIn(2) and PIn(3);

  COut(1) <= GIn(0) or (PIn(0) and CIn);
  COut(2) <= GIn(1) or (PIn(1) and GIn(0)) or (PIn(1) and PIn(0) and CIn);
  COut(3) <= GIn(2) or (PIn(2) and GIn(1)) or (PIn(2) and PIn(1) and GIn(0)) or (PIn(2) and PIn(1) and PIn(0) and CIn);

end struct;


