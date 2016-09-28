
----------------------------------------------------------------------
-- brdRstClk (for Icicle Kit)
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Board dependend reset and clock manipulation file.
-- Adjust i_clk from some known clock, so o_clk has BRD_OSC_CLK_MHZ.
-- See "brdConst_pkg.vhd" for specific BRD_OSC_CLK_MHZ values.
-- Sync up o_rst_n to fit to rising edge of o_clk.
--
-- This version explains use of hardwired macros for global resources.
-- IO macros should be used in top hdl files for readability/structure.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- chip dependent libraries
library igloo;
use igloo.all;

----------------------------------------------------------------------
entity brdRstClk is
  port ( i_rst_n, i_clk : in std_logic;
         o_rst_n, o_clk : out std_logic );
end brdRstClk;

----------------------------------------------------------------------
architecture rtl of brdRstClk is

component CLKBUF
  port( PAD : in  std_logic;
        Y   : out std_logic );
end component;

component CLKINT
  port( A : in  std_logic;
        Y : out std_logic );
end component;

component CLKBIBUF
  port( D, E: in    std_logic;
        Y   : out   std_logic;
        PAD : inout std_logic );
end component;

-- with BiBUF you can control the signal timing
-- clock gen inside FPGA (D) -> drive to outside.
-- Use external (PAD) AND feed back to inside (Y),
-- this insures timing order D than PAD than Y.
component CLKBIBUF
  port( D, E: in    std_logic;
        Y   : out   std_logic;
        PAD : inout std_logic );
end component;

  signal s_clk, s_tgl, s_dly_n, s_rst_n, s_one_n : std_logic;

begin

-- (a) CLKBUF enforces a global resource for i_clk,
-- this macro will only work with global IO pads.
-- Expect synthesis to do this on demand (c).
-- (b) for non global pads use CLKINT
-- globals are useless if driving small nets (see s_tgl below).
--
--CLOCK_BUFFER : CLKBUF                   -- (a)
--  port map( PAD => i_clk, Y => s_clk ); -- (a)
--CLOCK_BUFFER : CLKINT                   -- (b)
--  port map(  A => i_clk, Y => s_clk  ); -- (b)
  s_clk   <= i_clk;                       -- (c)

-- This CLKBUF global is useless and limiting,
-- it only drives a hand full of FSM elements.
-- Global reset should come from sync FSM
--RESET_BUFFER : CLKBUF
--  port map( PAD => i_rst_n, Y => s_rst_n );
  s_rst_n <= i_rst_n;
	
RESET_SYNC_FSM : process(s_clk, s_rst_n)
  begin
    if s_rst_n = '0' then
      s_dly_n <= '0';
      s_tgl   <= '0';
      s_one_n <= '0';
    elsif (s_clk'event and s_clk = '1') then
      s_dly_n <= '1';
      s_tgl   <= not s_tgl;
      s_one_n <= s_dly_n;
    end if;
  end process;

-- The buffers below will be inserted automaticly
-- by synthesis on demand in nearly all cases.
-- Only the most simple designes can live without.

--RESET_GLOBAL : CLKINT 
--  port map(  A => s_one_n, Y => o_rst_n  );
  o_rst_n <= s_one_n;

-- edit BRD_OSC_CLK_MHZ in brdConst_pkg too
  o_clk   <= s_clk; -- 20MHz, direct
--o_clk   <= s_tgl; -- 10MHz, divided

--CLOCK_GLOBAL : CLKINT 
--port map(  A => s_clk, Y => o_clk  );
--port map(  A => s_tgl, Y => o_clk  );

end rtl;
----------------------------------------------------------------------
-- Most macros can control IO features like CMOS/TTL/Drive/Pull
-- for example : BIBUF_LVCMOS5U, 
-- BIBUF_F_8D = TTL, 8mA Drive, Pull down
-- see catalog -> Macro Library -> BIBUF, CLKBUF, INBUF, OUTBUF
-- find Wizzard here : catalog -> Basic Blocks -> I/O
