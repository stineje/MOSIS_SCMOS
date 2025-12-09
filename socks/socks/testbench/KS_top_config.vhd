-- @(#) KS_top_config.vhd 1.2@(#)
-- ==================================================================
-- SCCS Path and File Name: /projects/ks/.sccs/s.KS_top_config.vhd
-- File Name: KS_top_config.vhd
-- SCCS File Release: 1 at Version: 2
-- Last Modified: 01/24/02 at 13:48:05
-- SCCS-get Executed on 02/19/02 at 12:36:50 to Get this File
--
-- ******************************************************************
-- *                        JTA Research Inc                        *
-- *                 Copyright (c) JTA Research Inc                 *
-- ******************************************************************
--
-- Description:
--
-- Level: Block
--
-- Class: Unknown
--
-- Revision History:
-- Date          By        Change
-- -----------   --------  ----------------------------------------
-- Dec 10 2001   mcynar    initial
-- Jan 24 2002   mcynar    Changed to use auto_gen
-- Dec 16 2002   mcynar    Added use ramlib.all
-- EOL
-- ==================================================================

LIBRARY ramlib;
LIBRARY toplib;
LIBRARY leonlib;
LIBRARY customlib;

configuration KS_top_tb_config of KS_top_tb is

  use ramlib.all;
  use toplib.all;
  use leonlib.all;
  use customlib.all;

  for KS_top_tb_arch
    for all: KS_top
       use configuration toplib.auto_gen;
       --use configuration toplib.empty_gen;
    end for;
  end for;

end KS_top_tb_config;
