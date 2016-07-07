
----------------------------------------------------------------------
-- OscXtlTxd
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Use External Xtal, adjust its signal to 50 MHz.
-- Divide down to some Hz as stimulus pattern. 
-- ->Send pattern via UART at 115200 or 921600 Baud
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity OscXtlTxd is
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
end OscXtlTxd;

----------------------------------------------------------------------
architecture rtl of OscXtlTxd is

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

component mySerTxd
  generic ( baud, freq : positive );
  port ( i_clk   : in std_logic;
         i_rst_n : in std_logic;
         i_str   : in std_logic;
         i_dat   : in std_logic_vector(7 downto 0);
         o_bsy   : out std_logic;
         o_txd   : out std_logic );
end component;

----------------------------------------------------------------------
constant c_baud : positive :=    115_200; -- default for most setups
--constant c_baud : positive :=  921_600; -- maximum tested via USB
constant c_freq : positive := 50_000_000;
signal s_clk, s_rst_n, s_lex, s_pbx : std_logic;
signal s_cnt : std_logic_vector(28 downto 0);
signal s_dat, s_led : std_logic_vector(7 downto 0);
signal s_str, s_txd, s_one, s_two : std_logic;

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

  process(s_clk, s_rst_n)
  begin
    if s_rst_n = '0' then
      s_one <= '0';
      s_two <= '0';
    elsif (s_clk'event and s_clk = '1') then
      s_one <= s_cnt(s_cnt'high -6);
      s_two <= s_one;
      s_str <= s_one and (not s_two);
    end if;
  end process;

  s_dat   <= "01" & s_cnt(s_cnt'high downto s_cnt'high-5);

mySerTxd_0 : mySerTxd
  generic map( 
            baud    => c_baud,
            freq    => c_freq )
  port map( i_clk   => s_clk,
            i_rst_n => s_rst_n,
            i_str   => s_str,
            i_dat   => s_dat,
            o_bsy   => open,
            o_txd   => s_txd );

  s_led  <= s_cnt(s_cnt'high downto s_cnt'high-7);
  LED0   <=  s_lex xor s_led(0);
  LED1   <=  s_lex xor s_led(1);
  LED2   <=  s_lex xor s_led(2);
  LED3   <=  s_lex xor s_led(3);
  LED4   <=  s_lex xor s_led(4);
  LED5   <=  s_lex xor s_led(5);
  LED6   <= (s_lex xor s_led(6)) xor (PB2 xor s_pbx);
  LED7   <= (s_lex xor s_led(7)) xor (PB1 xor s_pbx);

  UART_TXD <= UART_RXD and s_txd;

end rtl;
----------------------------------------------------------------------
