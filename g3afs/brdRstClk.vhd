
----------------------------------------------------------------------
-- brdRstClk (for some Fusion (Embeded/Start/SCS) Dev Kit )
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

library fusion;
use fusion.all;

----------------------------------------------------------------------
entity brdRstClk is
  port ( i_rst_n, i_clk : in std_logic;
         o_rst_n, o_clk : out std_logic );
end brdRstClk;

----------------------------------------------------------------------
architecture rtl of brdRstClk is

  signal s_tgl, s_dly_n, s_rst_n : std_logic;

begin

  s_rst_n <= i_rst_n;
	
  process(i_clk, s_rst_n)
  begin
    if s_rst_n = '0' then
      s_dly_n <= '0';
      s_tgl   <= '0';
      o_rst_n <= '0';
    elsif (i_clk'event and i_clk = '1') then
      s_dly_n <= '1';
      s_tgl   <= not s_tgl;
      o_rst_n <= s_dly_n;
    end if;
  end process;

-- edit BRD_OSC_CLK_MHZ in brdConst_pkg too
  o_clk   <= i_clk; -- direct
--o_clk   <= s_tgl; -- divided

end rtl;
----------------------------------------------------------------------
