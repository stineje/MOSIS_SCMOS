-- @(#) probes.vhd 1.1@(#)
-- ==================================================================
-- SCCS Path and File Name: /projects/ks/.sccs/s.probes.vhd
-- File Name: probes.vhd
-- SCCS File Release: 1 at Version: 1
-- Last Modified: 12/14/01 at 09:38:26
-- SCCS-get Executed on 12/14/01 at 09:38:26 to Get this File
--
-- ******************************************************************
-- *                        JTA Research Inc                        *
-- *                 Copyright (c) JTA Research Inc                 *
-- ******************************************************************
--
-- Description: Probes package to allow the testbench to use lower
--              level signals
--
-- Level: Top
--
-- Class: TBD
--
-- Revision History:
-- Date          By        Change
-- -----------   --------  ----------------------------------------
-- Dec 14 2001   mcynar    initial
-- EOL
-- ==================================================================

library IEEE;
use IEEE.std_logic_1164.all;

package probes is

   signal errorn : std_logic;

end probes;
