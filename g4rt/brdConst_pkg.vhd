
----------------------------------------------------------------------
-- brdConst_pkg (for RTG4-ES & non ES)
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
  constant BRD_OSC_CLK_MHZ : positive := 50_000_000; -- direct
--constant BRD_OSC_CLK_MHZ : positive := 25_000_000; -- divided
end brdConst_pkg;

----------------------------------------------------------------------
