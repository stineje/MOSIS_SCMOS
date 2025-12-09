-- Special Cases for Output
-- Author: John Moskal
--  Created: 11-20-2004
-- Modified: 11-20-2004
--
-- Modifications:
--
------------------------------------------------------------------------------------------
-- Special Values:
-- 000 OK
-- 001 Zero
-- 010 Underflow (Tininess and Inexact)
-- 011 Overflow
-- 100 Quiet Nan
-- 101 Infinity
-- 110 ? -> OK
-- 111 ? -> OK
------------------------------------------------------------------------------------------

library work;
library ieee;
use ieee.std_logic_1164.all;

entity specoutput is
port
(
   S:    in std_logic;                        -- Sign
   E:    in std_logic_vector(10 downto 0);    -- Exponent
   M:    in std_logic_vector(51 downto 0);    -- Mantissa
   SV:   in std_logic_vector(2 downto 0);     -- Special Value
   TDE:  in std_logic;                        -- Trap Disabled/Enabled
   SDP:  in std_logic;                        -- precision
   RM:   in std_logic_vector(1 downto 0);     -- Rounding Mode
   O:    out std_logic_vector(63 downto 0)    -- Result in DP
);
end entity specoutput;
--------------------------------------------

architecture stuff of specoutput is

signal o_s:   std_logic;
signal o_e:   std_logic_vector(10 downto 0);
signal o_m:   std_logic_vector(51 downto 0);

begin

-- Templates
-- +Zero 0 00000000000 0000000000000000000000000000000000000000000000000000
-- -Zero 1 00000000000 0000000000000000000000000000000000000000000000000000
-- +Deno 0 00000000000 0101010101010101010101010101010101010101010101010101
-- -Deno 1 00000000000 0101010101010101010101010101010101010101010101010101
-- +Norm 0 10001110001 0101010101010101010101010101010101010101010101010101
-- -Norm 1 10001110001 0101010101010101010101010101010101010101010101010101
--  SNaN 0 11111111111 0100000000000000000000000000000000000000000000000000
--  QNaN 0 11111111111 1000000000000000000000000000000000000000000000000000
-- +XNaN 0 11111111111 0101010101010101010101010101010101010101010101010101
-- -XNaN 1 11111111111 0101010101010101010101010101010101010101010101010101
--  +Inf 0 11111111111 0000000000000000000000000000000000000000000000000000
--  -Inf 1 11111111111 0000000000000000000000000000000000000000000000000000
       
process(S, E, M, SV, TDE, RM, SDP)
begin
    -- Zero
    if(SV = "001") then
        o_s <= S;
        o_e <= "00000000000";
        o_m <= "0000000000000000000000000000000000000000000000000000";
    
    -- Underflow (Zero)
    elsif ((SV = "010") and (TDE = '0')) then
          o_s <= S;
          o_e <= "00000000000";
          o_m <= "0000000000000000000000000000000000000000000000000000";
    
    -- Overflow
    elsif((SV = "011") and (TDE = '0')) then
          -- RNE
          if(RM = "00") then
             o_s <= S; 
             o_e <= "11111111111";
             o_m <= "0000000000000000000000000000000000000000000000000000";
          -- RZ
          elsif(RM = "01") then
             o_s <= S;
             if (SDP = '0') then
                 o_e <= "10011111110";
             else
                 o_e <= "11111111110";
             end if;
             o_m <= "1111111111111111111111111111111111111111111111111111";
          -- RU
          elsif(RM = "10") then
             if (S = '0') then
                 o_s <= '0';
                 o_e <= "11111111111";
                 o_m <= "0000000000000000000000000000000000000000000000000000";
             else -- S='1'
                 o_s <= '1';
                 if (SDP = '0') then
                    o_e <= "10011111110";
                 else
                    o_e <= "11111111110";
                 end if;
                 o_m <= "1111111111111111111111111111111111111111111111111111";
             end if;
          -- RD
          else  --if (RM = "11") then
             if (S = '0') then
                 o_s <= '0';
                 if (SDP = '0') then
                    o_e <= "10011111110";
                 else
                    o_e <= "11111111110";
                 end if;
                 o_m <= "1111111111111111111111111111111111111111111111111111";
             else
                 o_s <= '1';
                 o_e <= "11111111111";
                 o_m <= "0000000000000000000000000000000000000000000000000000";
             end if;
          end if;
    
    -- Quiet NaN
    elsif (SV = "100") then
          o_s <= '0';
          o_e <= "11111111111";
          o_m <= "1000000000000000000000000000000000000000000000000000";
    
    -- Infinity
    elsif (SV = "101") then
          o_s <= S;
          o_e <= "11111111111";
          o_m <= "0000000000000000000000000000000000000000000000000000";
    
    -- else OK
    else
          o_s <= S;
          o_e <= E;
          o_m <= M;
    end if;
    
end process;

O(63) <= o_s;
O(62 downto 52) <= o_e;
O(51 downto 0) <= o_m;

end stuff;

