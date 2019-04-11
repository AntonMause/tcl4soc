
----------------------------------------------------------------------
-- brdConst_pkg (for Trenz TEM0001 Board)
----------------------------------------------------------------------
-- (c) 2019 by Anton Mause
--
-- Package to declare board specific constants.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
package brdConst_pkg is
  constant BRD_OSC_CLK_MHZ : positive;
end brdConst_pkg;

----------------------------------------------------------------------
package body brdConst_pkg is
  -- Frequency of signal o_clk from brdRstClk to system
  constant BRD_OSC_CLK_MHZ : positive := 12_000_000; -- FTDI Clock
end brdConst_pkg;

----------------------------------------------------------------------
