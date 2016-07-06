
----------------------------------------------------------------------
-- OscChpMux
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Blink some LEDs based only on OnChip resources.
-- Use the 50 MHz OnDie RC-Oscillator plus a bunch 
-- of registers for the FlipFlip toggle counter.
--
-- Added the CCC NonGlitching MUX to demonstrate its behaivour.
-- Watch how long it takes to switch between clock inputs.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity OscChpMux is
  port( LED0     : out std_logic;
        LED1     : out std_logic;
        LED2     : out std_logic;
        LED3     : out std_logic;
        LED4     : out std_logic;
        LED5     : out std_logic;
        LED6     : out std_logic;
        LED7     : out std_logic );
end OscChpMux;

----------------------------------------------------------------------
architecture rtl of OscChpMux is

component brdLexSwx is
  port ( o_lex,   o_pbx : out std_logic );
end component;

component myChpOsc is
  port ( i_rst_n : in std_logic;
         o_clk : out std_logic );
end component;

component myDffCnt
  generic (N : Integer);
  port ( i_rst_n, i_clk : in std_logic;
         o_q : out std_logic_vector(N-1 downto 0) );
end component;

component myCccMux is
port( i_clk0, i_clk1, i_mux : in  std_logic;
      o_clk : out std_logic );
end component;

signal s_clk, s_ccc : std_logic;
signal s_cnt : std_logic_vector(29 downto 0);
signal s_led : std_logic_vector(7 downto 0);
signal s_lex : std_logic;

begin

brdLexSwx_0 : brdLexSwx
  port map(
    o_lex   => s_lex,
    o_pbx   => open );
	
myChpOsc_0 : myChpOsc
  port map(
    i_rst_n => '1',
    o_clk   => s_clk );

myDffCnt_0 : myDffCnt
  generic map( N => s_cnt'high+1 )
  port map(
    i_rst_n => '1',
    i_clk   => s_clk,
    o_q     => s_cnt );

myCccMux_0 : myCccMux
  port map( 
    i_clk0 => s_led(1),
    i_clk1 => s_led(2), 
    i_mux  => s_led(7), -- use MSB to select clock
    o_clk  => s_ccc );

  s_led  <= s_cnt(s_cnt'high downto s_cnt'high-7);
  LED0   <= s_lex;
  LED1   <= s_lex xor  s_led(1); -- blink clk0
  LED2   <= s_lex xor (s_ccc     AND     s_led(7));
  LED3   <= s_lex xor (s_ccc     AND NOT s_led(7));
  LED4   <= s_lex xor  s_led(2); -- blink clk1
  LED5   <= s_lex;
  LED6   <= s_lex xor (                  s_led(7));
  LED7   <= s_lex xor (              NOT s_led(7));

end rtl;
----------------------------------------------------------------------
