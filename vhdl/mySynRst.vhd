
----------------------------------------------------------------------
-- mySynRst
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- synchronise reset to clock
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mySynRst is
  port(i_rst_n, i_clk : in std_logic;
       o_rst_n : out std_logic);
end mySynRst;

architecture rtl of mySynRst is

  signal s_dly_n, s_rst_n : std_logic;

begin

  process(i_clk, i_rst_n)
  begin
    if i_rst_n = '0' then
      s_dly_n <= '0';
      s_rst_n <= '0';
    elsif (i_clk'event and i_clk = '1') then
      s_dly_n <= '1';
      s_rst_n <= s_dly_n;
    end if;
  end process;

  o_rst_n <= s_rst_n;

end rtl;
