
----------------------------------------------------------------------
-- brdRstClk (for SCS Kit)
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Board dependend reset and clock manipulation file.
-- Adjust i_clk from some known clock, so o_clk has BRD_OSC_CLK_MHZ.
-- See "brdConst_pkg.vhd" for specific BRD_OSC_CLK_MHZ values.
-- Sync up o_rst_n to fit to rising edge of o_clk.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- 000000000000000000000000111111111111111111111111
-- 111110000011111000001111000001111100000111110000
-- 
-- 0    1    2    3    4    5    6    7    8    9
-- 024680246802468024680246802468024680246802468024
-- 135791357913579135791357913579135791357913579135
-- 
-- 1.1.1.1.1.0.0.0.0.0.1.1.1.1.1.0.0.0.0.0.1.1.1.1.
-- .1.1.1.1.1.0.0.0.0.0.1.1.1.1.0.0.0.0.0.1.1.1.1.1
-- 111111111100000000001111111110000000000111111111
-- 0         1         2         3         4
-- 012345678901234567890123456789012345678901234567
-- 0                   1                   2
-- 0.1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9.0.1.2.3.
-- 

----------------------------------------------------------------------
entity brdRstClk is
  port ( i_rst_n, i_clk : in std_logic;
         o_rst_n, o_clk : out std_logic );
end brdRstClk;

----------------------------------------------------------------------
architecture rtl of brdRstClk is

  signal s_tgl, s_dly_n, s_clk, s_rst_n, s_rst_one, s_rst_two : std_logic;
  signal s_one, s_two : std_logic_vector(23 downto 0);  

begin

  process(i_clk, i_rst_n)
  begin
    if i_rst_n = '0' then
      s_dly_n <= '0';
      s_tgl   <= '0';
      o_rst_n <= '0';
    elsif (i_clk'event and i_clk = '1') then
      s_dly_n <= '1';
      s_tgl   <= not s_tgl;
      o_rst_n <= s_dly_n;
    end if;
  end process;

  process(i_clk, s_rst_n)
  begin
    if (s_rst_n = '0') then
      s_one <= "111110000011111000001111";
    elsif (i_clk'event and i_clk = '1') then
      s_one <= not s_one(0) & s_one(23 downto 1);
    end if;
  end process;
  process(i_clk, s_rst_n)
  begin
    if (s_rst_n = '0') then
      s_two <= "111110000011110000011111";
    elsif (i_clk'event and i_clk = '0') then
      s_two <= not s_two(0) & s_two(23 downto 1);
    end if;
  end process;
  o_clk <= s_one(0) AND s_two(0); -- aprox 10MHz, direct

-- edit BRD_OSC_CLK_MHZ in brdConst_pkg too
--o_clk   <= i_clk; -- 48MHz, direct
--o_clk   <= s_tgl; -- 24MHz, divided

end rtl;
----------------------------------------------------------------------
