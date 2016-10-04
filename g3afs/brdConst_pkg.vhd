
----------------------------------------------------------------------
-- brdConst_pkg (for Fusion Embeded Dev Kit )
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
--constant BRD_OSC_CLK_MHZ : positive := 100_000_000; -- OnChp Osc
  constant BRD_OSC_CLK_MHZ : positive :=  50_000_000; -- direct Xtl
--constant BRD_OSC_CLK_MHZ : positive :=  25_000_000; -- divided Xtl
end brdConst_pkg;

----------------------------------------------------------------------
