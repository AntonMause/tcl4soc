
----------------------------------------------------------------------
-- OscXtlCnt
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Blink 8 LEDs using external Xtal Clock.
-- Use External Xtal, adjust its signal to 50 MHz and add a bunch 
-- of registers for the FlipFlip toggle counter.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity OscXtlCnt is
  port( OSC_CLK  : in  std_logic;
        DEVRST_N : in  std_logic;
        PB1      : in  std_logic;
        PB2      : in  std_logic;
        LED0     : out std_logic;
        LED1     : out std_logic;
        LED2     : out std_logic;
        LED3     : out std_logic;
        LED4     : out std_logic;
        LED5     : out std_logic;
        LED6     : out std_logic;
        LED7     : out std_logic;
        UART_RXD : in  std_logic;
        UART_TXD : out std_logic );
end OscXtlCnt;

----------------------------------------------------------------------
architecture rtl of OscXtlCnt is

component brdLexSwx is
  port ( o_lex,   o_pbx : out std_logic );
end component;

component brdRstClk
  port ( i_rst_n, i_clk : in std_logic;
         o_rst_n, o_clk : out std_logic );
end component;

component myDffCnt
  generic (N : Integer);
  port ( i_rst_n, i_clk : in std_logic;
         o_q : out std_logic_vector(N-1 downto 0) );
end component;

signal s_clk, s_rst_n, s_lex, s_pbx : std_logic;
signal s_cnt : std_logic_vector(28 downto 0);
signal s_led : std_logic_vector(7 downto 0);

begin

brdRstClk_0 : brdRstClk
  port map(
    i_rst_n => DEVRST_N,
    i_clk   => OSC_CLK,
    o_rst_n => s_rst_n,
    o_clk   => s_clk );

brdLexSwx_0 : brdLexSwx
  port map(
    o_lex   => s_lex,
    o_pbx   => s_pbx );
	
myDffCnt_0 : myDffCnt
  generic map( N => s_cnt'high+1 )
  port map(
    i_rst_n => s_rst_n,
    i_clk   => s_clk,
    o_q     => s_cnt );

  s_led  <=  s_cnt(s_cnt'high downto s_cnt'high-7);
  LED0   <=  s_led(0) xor s_lex;
  LED1   <=  s_led(1) xor s_lex;
  LED2   <=  s_led(2) xor s_lex;
  LED3   <=  s_led(3) xor s_lex;
  LED4   <=  s_led(4) xor s_lex;
  LED5   <=  s_led(5) xor s_lex;
  LED6   <= (s_led(6) xor s_lex) xor (PB2 xor s_pbx);
  LED7   <= (s_led(7) xor s_lex) xor (PB1 xor s_pbx);

  UART_TXD <= UART_RXD; -- dummy

end rtl;
----------------------------------------------------------------------
