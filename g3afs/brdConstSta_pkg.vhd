
----------------------------------------------------------------------
-- brdConst_pkg (for Fusion Starter Kit)
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
--constant BRD_OSC_CLK_MHZ : positive := 50_000_000; -- OSC divided
  constant BRD_OSC_CLK_MHZ : positive := 40_000_000; -- XTL direct
--constant BRD_OSC_CLK_MHZ : positive := 24_000_000; -- XTL divided
end brdConst_pkg;

----------------------------------------------------------------------
