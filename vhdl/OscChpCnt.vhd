
----------------------------------------------------------------------
-- OscChpCnt
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Blink 8 LEDs based only on OnChip resources.
-- Use the OnDie RC-Oscillator plus a bunch 
-- of registers for the FlipFlip toggle counter.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity OscChpCnt is
  port( LED0     : out std_logic;
        LED1     : out std_logic;
        LED2     : out std_logic;
        LED3     : out std_logic;
        LED4     : out std_logic;
        LED5     : out std_logic;
        LED6     : out std_logic;
        LED7     : out std_logic );
end OscChpCnt;

----------------------------------------------------------------------
architecture rtl of OscChpCnt is

component myChpOsc is
  port ( i_rst_n : in std_logic;
         o_clk : out std_logic );
end component;

component myDffCnt
  generic (N : Integer);
  port ( i_rst_n, i_clk : in std_logic;
         o_q : out std_logic_vector(N-1 downto 0) );
end component;

signal s_clk : std_logic;
signal s_cnt : std_logic_vector(28 downto 0);
signal s_led : std_logic_vector(7 downto 0);

begin

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

  s_led  <= s_cnt(s_cnt'high downto s_cnt'high-7);
  LED0   <= s_led(0);
  LED1   <= s_led(1);
  LED2   <= s_led(2);
  LED3   <= s_led(3);
  LED4   <= s_led(4);
  LED5   <= s_led(5);
  LED6   <= s_led(6);
  LED7   <= s_led(7);

end rtl;
----------------------------------------------------------------------
