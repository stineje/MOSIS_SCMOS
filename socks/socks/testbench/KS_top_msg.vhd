-- @(#) KS_top_msg.vhd 1.7@(#)
-- ==================================================================
-- SCCS Path and File Name: /projects/ks/.sccs/s.KS_top_msg.vhd
-- File Name: KS_top_msg.vhd
-- SCCS File Release: 1 at Version: 7
-- Last Modified: 04/04/02 at 16:17:45
-- SCCS-get Executed on 09/17/02 at 15:38:11 to Get this File
--
-- ******************************************************************
-- *                        JTA Research Inc                        *
-- *                 Copyright (c) JTA Research Inc                 *
-- ******************************************************************
--
-- Description: This module is connected to the I/O area and generates
-- debug messages and bus exceptions for the test bench.
--
-- Level: Block
--
-- Class: Unknown
--
-- Revision History:
-- Date          By        Change
-- -----------   --------  ----------------------------------------
-- Jan 21 2002   mcynar    initial
-- Jan 21 2002   mcynar    Added a header. Renamed to KS_top_msg
-- Jan 21 2002   mcynar    Added messages
-- Jan 21 2002   mcynar    Indentation and formatting
-- Jan 23 2002   mcynar    Removed asserts 
-- Apr 04 2002   mcynar    Removed reference to leonlib
-- Nov 30 2004   bpeterson Fixed dint32 conversion from std_logic_vector to integer 
-- EOL
-- ==================================================================

-----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  See the file COPYING for the full details of the license.

-----------------------------------------------------------------------------   
-- Entity:      testmod
-- File:        testmod.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: This module is connected to the I/O area and generates
--      debug messages and bus exceptions for the test bench.
------------------------------------------------------------------------------  
-- Version control:
-- 17-12-1998:  : First implemetation
-- 27-08-1999:  : Moved trace function from iu 
-- 26-09-1999:  : Release 1.0
------------------------------------------------------------------------------  

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.Std_Logic_unsigned.all;
use STD.TEXTIO.all;

--library leonlib;
--use leonlib.debug.all;

entity KS_top_msg is
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
end;


architecture KS_top_msg_arch of KS_top_msg is

   signal ioporti  : std_logic_vector(15 downto 0);
    
   function chr(c: integer) return character is
       variable d : character;
     begin
         case c is
           when 32 => d:= ' '; 
           when 33 => d:= '!'; 
           when 34 => d:= '"'; 
           when 35 => d:= '#'; 
           when 36 => d:= '$'; 
           when 37 => d:= '%'; 
           when 38 => d:= '&'; 
           when 39 => d:= '''; 
           when 40 => d:= '('; 
           when 41 => d:= ')'; 
           when 42 => d:= '*'; 
           when 43 => d:= '+'; 
           when 44 => d:= ','; 
           when 45 => d:= '-'; 
           when 46 => d:= '.'; 
           when 47 => d:= '/'; 
           when 48 => d:= '0'; 
           when 49 => d:= '1'; 
           when 50 => d:= '2'; 
           when 51 => d:= '3'; 
           when 52 => d:= '4'; 
           when 53 => d:= '5'; 
           when 54 => d:= '6'; 
           when 55 => d:= '7'; 
           when 56 => d:= '8'; 
           when 57 => d:= '9'; 
           when 58 => d:= ':'; 
           when 59 => d:= ';'; 
           when 60 => d:= '<'; 
           when 61 => d:= '='; 
           when 62 => d:= '>'; 
           when 63 => d:= '?'; 
           when 64 => d:= '@';
           when 65 => d:= 'A';
           when 66 => d:= 'B';
           when 67 => d:= 'C';
           when 68 => d:= 'D';
           when 69 => d:= 'E';
           when 70 => d:= 'F';
           when 71 => d:= 'G';
           when 72 => d:= 'H';
           when 73 => d:= 'I';
           when 74 => d:= 'J';
           when 75 => d:= 'K';
           when 76 => d:= 'L';
           when 77 => d:= 'M';
           when 78 => d:= 'N';
           when 79 => d:= 'O';
           when 80 => d:= 'P';
           when 81 => d:= 'Q';
           when 82 => d:= 'R';
           when 83 => d:= 'S';
           when 84 => d:= 'T';
           when 85 => d:= 'U';
           when 86 => d:= 'V';
           when 87 => d:= 'W';
           when 88 => d:= 'X';
           when 89 => d:= 'Y';
           when 90 => d:= 'Z';
           when 91 => d:= '[';
           when 92 => d:= '\';
           when 93 => d:= ']';
           when 94 => d:= '^';
           when 95 => d:= '_';
           when 96 => d:= '`';
           when 97 => d:= 'a';
           when 98 => d:= 'b';
           when 99 => d:= 'c';
           when 100 => d:= 'd';
           when 101 => d:= 'e';
           when 102 => d:= 'f';
           when 103 => d:= 'g';
           when 104 => d:= 'h';
           when 105 => d:= 'i';
           when 106 => d:= 'j';
           when 107 => d:= 'k';
           when 108 => d:= 'l';
           when 109 => d:= 'm';
           when 110 => d:= 'n';
           when 111 => d:= 'o';
           when 112 => d:= 'p';
           when 113 => d:= 'q';
           when 114 => d:= 'r';
           when 115 => d:= 's';
           when 116 => d:= 't';
           when 117 => d:= 'u';
           when 118 => d:= 'v';
           when 119 => d:= 'w';
           when 120 => d:= 'x';
           when 121 => d:= 'y';
           when 122 => d:= 'z';
           when 123 => d:= '{';
           when 124 => d:= '|';
           when 125 => d:= '}';
           when 126 => d:= '~';
           when 127 => d:= ' ';
           when others => d := 's';
         end case;
       return d;
     end chr;

   -- converts a std_logic_vector into a hex string.
   function hstr(slv: std_logic_vector) return string is
       variable hexlen: integer;
       variable longslv : std_logic_vector(67 downto 0) := (others => '0');
       variable hex : string(1 to 16);
       variable fourbit : std_logic_vector(3 downto 0);
     begin
       hexlen := (slv'left+1)/4;
       if (slv'left+1) mod 4 /= 0 then
         hexlen := hexlen + 1;
       end if;
       longslv(slv'left downto 0) := slv;
       for i in (hexlen -1) downto 0 loop
         fourbit := longslv(((i*4)+3) downto (i*4));
         case fourbit is
           when "0000" => hex(hexlen -I) := '0';
           when "0001" => hex(hexlen -I) := '1';
           when "0010" => hex(hexlen -I) := '2';
           when "0011" => hex(hexlen -I) := '3';
           when "0100" => hex(hexlen -I) := '4';
           when "0101" => hex(hexlen -I) := '5';
           when "0110" => hex(hexlen -I) := '6';
           when "0111" => hex(hexlen -I) := '7';
           when "1000" => hex(hexlen -I) := '8';
           when "1001" => hex(hexlen -I) := '9';
           when "1010" => hex(hexlen -I) := 'A';
           when "1011" => hex(hexlen -I) := 'B';
           when "1100" => hex(hexlen -I) := 'C';
           when "1101" => hex(hexlen -I) := 'D';
           when "1110" => hex(hexlen -I) := 'E';
           when "1111" => hex(hexlen -I) := 'F';
           when "ZZZZ" => hex(hexlen -I) := 'z';
           when "UUUU" => hex(hexlen -I) := 'u';
           when "XXXX" => hex(hexlen -I) := 'x';
           when others => hex(hexlen -I) := '?';
         end case;
       end loop;
       return hex(1 to hexlen);
     end hstr;

begin

  init: process
    variable L:line;
  begin
    wait for 1 ns;
    write(L, string'("------------------------------------------------")); writeline(OUTPUT,L);
    write(L, string'("Simulation starting")); writeline(OUTPUT,L);
    write(L, string'(" ")); writeline(OUTPUT,L);
    wait until false;
  end process;
  
  rep: process
      variable L, L_txt, L_int : line;
      file txt_file : text  is out "TXT.OUTPUT";
      file int_file : text  is out "INT.OUTPUT";
      variable aint : natural;
      variable dint8 : natural;
      variable dint32 : integer;
--      variable dint32 : bit_vector(31 downto 0);
   begin

      data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" after 5 ns;

      wait until  ((iosn or (writen and oen)) = '0');
      wait for 1 ns;
      aint := conv_integer(address);
      dint8 := conv_integer(data(31 downto 24));
     
      if aint < 64 then
        if (aint=0) then
          if(dint8=10) then
            writeline(OUTPUT,L);
          else
            write(L, chr(dint8));
          end if;
        elsif (aint=4) then
          if(dint8=10) then
            writeline(txt_file,L_txt);
          else
            write(L_txt, chr(dint8));
          end if;
        elsif (aint=8) then
         dint32:=to_integer(unsigned(data(31 downto 0)));
--       dint32:= to_bitvector(data(31 downto 0));
            write(L_int, dint32);
            writeline(int_file,L_int);
        elsif (aint=12) then
          writeline(txt_file,L_txt);
          writeline(OUTPUT,L);
          write(L, string'("------------------------------------------------")); writeline(OUTPUT,L);
          write(L, string'("Simulation ending...")); writeline(OUTPUT,L);
          write(L, string'(" ")); writeline(OUTPUT,L);
          write(L, string'("Received QUIT command!")); writeline(OUTPUT,L);
          write(L, string'("Causing an ASSERT/FAILURE on purpose")); writeline(OUTPUT,L);
          write(L, string'("to make the simulator stop the simulation")); writeline(OUTPUT,L);
          write(L, string'(" ")); writeline(OUTPUT,L);
          assert false report "Received QUIT command" severity failure ;
        end if;
      end if;

      wait until (iosn = '1');
   end process;

end;
