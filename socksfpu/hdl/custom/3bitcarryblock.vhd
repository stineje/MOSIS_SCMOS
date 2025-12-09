LIBRARY ieee;
Use ieee.std_logic_1164.all;

entity threebitcarryblock is

  port(PIn, GIn : in std_logic_vector(2 downto 0);
       CIn : in std_logic;
       COut : out std_logic_vector(2 downto 1);
       POut, GOut : out std_logic);
end threebitcarryblock;

architecture struct of threebitcarryblock is

begin  -- struct

  GOut <= GIn(2) or (GIn(1) and PIn(2)) or (GIn(0) and PIn(2) and PIn(1));

  POut <= PIn(0) and PIn(1) and PIn(2);

  COut(1) <= GIn(0) or (PIn(0) and CIn);
  COut(2) <= GIn(1) or (PIn(1) and GIn(0)) or (PIn(1) and PIn(0) and cin);

end struct;


