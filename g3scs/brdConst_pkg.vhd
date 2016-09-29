
----------------------------------------------------------------------
-- brdConst_pkg (for SCS Kit)
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
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
  constant BRD_OSC_CLK_MHZ : positive := 48_000_000; -- direct
--constant BRD_OSC_CLK_MHZ : positive := 24_000_000; -- divided
--constant BRD_OSC_CLK_MHZ : positive := 10_000_000; -- divided
end brdConst_pkg;

----------------------------------------------------------------------
