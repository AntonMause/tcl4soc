 
----------------------------------------------------------------------
-- myDff
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- D-FlipFlip (intended use in toggle counter).
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity myDff is
  port (i_rst_n, i_clk, i_d : in std_logic;
        o_q, o_nq : out std_logic);
end entity myDff;

----------------------------------------------------------------------
architecture rtl of myDff is

  signal s : std_logic;

begin

P_D_FF: process(i_rst_n, i_clk)
  begin
    if i_rst_n='0' then
      s <= '0';
    elsif rising_edge(i_clk) then
      s <= i_d;
    end if;
    o_q  <=     s;
    o_nq <= not s;
  end process;

end architecture rtl;
----------------------------------------------------------------------
