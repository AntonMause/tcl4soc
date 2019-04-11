
----------------------------------------------------------------------
-- brdLexSwx (for Trenz TEM0001 Board)
----------------------------------------------------------------------
-- (c) 2019 by Anton Mause
--
-- board/kit dependency : LEDs & SW polarity
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity brdLexSwx is
  port ( o_lex,   o_pbx : out std_logic );
end brdLexSwx;

----------------------------------------------------------------------
architecture rtl of brdLexSwx is

begin

  -- polarity of LED driver output
  -- '0' = low idle, high active
  -- '1' = high idle, low active
  o_lex   <= '0';
  
  -- polarity of push button switch
  -- '0' = low idle, high active (pressed)
  -- '1' = high idle, low active (pressed)
  o_pbx   <= '1'; 

end rtl;