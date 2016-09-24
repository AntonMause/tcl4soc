
----------------------------------------------------------------------
-- IniPatGen
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Blink some LEDs to show results of initialisation attempts.
--
-- Result :
--  -assignments at declaration time will not work
--  -Asynch Reset will work and come for free (no etra resources)
--  -Sync Reset will work too, but may cost extra LUT resources
--
-- SRAM FPGA may support initialisation at declaration.
-- Watch your step when migrating from SRAM to FLASH FPGAs
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

----------------------------------------------------------------------
entity IniPatGen is
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
end IniPatGen;

architecture RTL of IniPatGen is
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal s_clk, s_clk2, s_rst_n, s_lex, s_pbx : std_logic;
signal s_cnt : std_logic_vector(26 downto 0);
signal s_led : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
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

  s_clk2 <= s_led(4);
  LED6   <= s_clk2;

noReset : process(s_clk2, s_rst_n)
  variable v_sft : std_logic_vector(25 downto 0) := "00001010100001011000011100";
  begin
    if (s_clk2'event and s_clk2 = '1') then
      v_sft := v_sft(0) & v_sft(v_sft'length-1 downto 1);
    end if;
    LED0 <= v_sft(0) xor s_lex;
  end process;

asyncReset : process(s_clk2, s_rst_n)
  variable v_sft : std_logic_vector(25 downto 0);
  begin
    if (s_rst_n = '0') then
      v_sft := "00001010100001011000011100";
    elsif (s_clk2'event and s_clk2 = '1') then
      v_sft := v_sft(0) & v_sft(v_sft'length-1 downto 1);
    end if;
    LED2 <= v_sft(0) xor s_lex;
  end process;

  process(s_clk2, s_rst_n)
  variable v_cnt : unsigned(2 downto 0);
  begin
    if (s_rst_n = '0') then
      v_cnt := to_unsigned(3,v_cnt'length);
    elsif (s_clk2'event and s_clk2 = '1') then
      if (v_cnt(2) = '1') then
        v_cnt := to_unsigned(3,v_cnt'length);
      else
        v_cnt := v_cnt -1;
      end if;
    end if;
    LED4 <= v_cnt(2) xor s_lex;
  end process;

  UART_TXD <= UART_RXD;

  s_led  <= s_cnt(s_cnt'high downto s_cnt'high-7);
--LED0   <= s_led(0);
--LED1   <= s_led(1);
--LED2   <= s_led(2);
--LED3   <= s_led(3);
--LED4   <= s_led(4);
--LED5   <= s_led(5);
--LED6   <= s_led(6) xor PB2;
--LED7   <= s_led(7) xor PB1;
  LED5   <= PB2;
  LED7   <= PB1;

end RTL;