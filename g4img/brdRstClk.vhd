
----------------------------------------------------------------------
-- brdRstClk  (for IMG Dev Kit)
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Board dependend reset and clock manipulation file.
-- Adjust i_clk from some known input clock rate so o_clk runs at 50MHz.
-- Sync up o_rst_n to fit to rising edge of o_clk.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;

----------------------------------------------------------------------
-- 125 MHz xTal Input => 50 MHz Output => divide by 2.5
--  1 2 3 4 5 6 7 8 9 10
-- 01010101010101010101
--
-- 00011000110001100011
-- 0  1 0  2 0  3 0  4 
-- 0.0.1.0.1.0.0.1.0.1.
-- .0.1.0.0.1.0.1.0.0.1
-- 00011000110001100011
-- 0  1 0  2 0  3 0  4 
-- 01234567890123456789
-- 0.1.2.3.4.5.6.7.8.9.
-- 
-- .0.1.0.1.0.0.1.0.1.0 -- failing if starting at wrong edge
-- 1.0.1.0.0.1.0.1.0.0.
-- 10011001001001100100 -- wrong pattern with spikes
-- 00011000110001100011 -- rigth pattern
-- *------****------*** -- <= mismatch

----------------------------------------------------------------------
entity brdRstClk is
  port ( i_rst_n, i_clk : in std_logic;
         o_rst_n, o_clk : out std_logic );
end brdRstClk;

----------------------------------------------------------------------
architecture behavioral of brdRstClk is
component SYSRESET

  port( DEVRST_N         : in  std_logic;
        POWER_ON_RESET_N : out std_logic );
  end component;

  signal s_rst_in, s_dly_n, s_rst_n, s_clk : std_logic;
  -- FLASH FPGA tools will not synthesise := "00101" !!!
  -- With G3 expext random values, with G4 all ZEROs.
  -- Looks OK with Modelsim PRE synthesis, NOT in reality.
  signal s_one : std_logic_vector(4 downto 0) := "00101";
  signal s_two : std_logic_vector(4 downto 0) := "01001";
  -- not using := increases chance to find uninitialized values
  
begin

SYSRESET_0 : SYSRESET
  port map( 
    DEVRST_N         => i_rst_n,
    POWER_ON_RESET_N => s_rst_in );

  process(i_clk, s_rst_in) -- sync s_rst_n to i_clk
  begin
    if s_rst_in = '0' then
      s_dly_n <= '0';
      s_rst_n <= '0';
    elsif (i_clk'event and i_clk = '1') then
      s_dly_n <= '1';
      s_rst_n <= s_dly_n;
    end if;
  end process;

  process(i_clk, s_rst_n) -- divide clock by shifting pattern
  begin
    if (s_rst_n = '0') then
      s_one <= "00101";
    elsif (i_clk'event and i_clk = '1') then
      s_one <= s_one(0) & s_one(4 downto 1);
    end if;
  end process;
  process(i_clk, s_rst_n)
  begin
    if (s_rst_n = '0') then
      s_two <= "01001";
    elsif (i_clk'event and i_clk = '0') then
      s_two <= s_two(0) & s_two(4 downto 1);
    end if;
  end process;
  s_clk <= s_one(0) AND s_two(0);

  -- decide if second RESET sync block here
  
  o_rst_n <= s_rst_n;
  
-- edit BRD_OSC_CLK_MHZ in brdConst_pkg too
--o_clk   <= i_clk; -- 125MHz, direct
  o_clk   <= s_clk; --  50MHz, divided

end behavioral;