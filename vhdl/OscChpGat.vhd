
----------------------------------------------------------------------
-- OscChpGat
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Blink some LEDs based only on OnChip resources.
-- Use the OnDie RC-Oscillator plus a bunch 
-- of registers for the FlipFlip toggle counter.
--
-- Added the CCC clock gating unit to demonstrate its behaivour.
-- Watch how it controls gating the clock input.
--
-- GATE  -> (Din) -> LATCH -> (Dout) -> AND(a)
-- CLOCK -> (Ena) -> LATCH     CLOCK -> AND(b) -> GATED_CLOCK
-- 
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity OscChpGat is
  port( LED0     : out std_logic;
        LED1     : out std_logic;
        LED2     : out std_logic;
        LED3     : out std_logic;
        LED4     : out std_logic;
        LED5     : out std_logic;
        LED6     : out std_logic;
        LED7     : out std_logic );
end OscChpGat;

----------------------------------------------------------------------
architecture rtl of OscChpGat is

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

component myCccGat is
port( i_clk, i_gat : in  std_logic;
      o_clk : out std_logic );
end component;

signal s_clk, s_ccc, s_gat : std_logic;
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

myCccGat_0 : myCccGat
  port map( 
    i_clk  => s_led(3),
    i_gat  => s_gat,
    o_clk  => s_ccc );

  s_gat <= s_led(7) xor (s_led(6) and s_led(1));

  s_led  <= s_cnt(s_cnt'high downto s_cnt'high-7);
  LED0   <= s_lex;
  LED1   <= s_lex xor s_led(3); -- blink clock
  LED2   <= s_lex;
  LED3   <= s_lex xor s_gat;
  LED4   <= s_lex;
  LED5   <= s_lex xor s_ccc;
  LED6   <= s_lex xor s_led(6);
  LED7   <= s_lex xor s_led(7);

end rtl;
----------------------------------------------------------------------
