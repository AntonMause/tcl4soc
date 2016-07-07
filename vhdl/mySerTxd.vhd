
----------------------------------------------------------------------
-- mySerTxd.vhd
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- My simple fixed speed UART serial transmitter.
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

----------------------------------------------------------------------
entity mySerTxd is
  generic ( 
    baud   : positive :=     115_200;
    freq   : positive :=  50_000_000);
  port ( 
    i_clk   : in std_logic;
    i_rst_n : in std_logic;
    i_str   : in std_logic;
    i_dat   : in std_logic_vector(7 downto 0);
    o_bsy   : out std_logic;
    o_txd   : out std_logic );
end mySerTxd;

----------------------------------------------------------------------
architecture rtl of mySerTxd is

  constant c_bd_div : integer := ((freq / baud)-2);
  constant c_bd_div_width : integer := integer(log2(real(c_bd_div))) + 1;
  signal bd_cur, bd_nxt : unsigned(c_bd_div_width downto 0);
  signal s_dat, s_bsy : std_logic_vector(10 downto 0);
  signal s_tck : std_logic;

begin

  process(i_clk) -- clock divider
  begin
    if (i_clk'event and i_clk = '1') then
      if (bd_nxt(bd_nxt'length-1) = '1') then
        bd_nxt <= to_unsigned(c_bd_div,bd_cur'length);
      else
        bd_nxt <= bd_nxt -1;
      end if;
    end if;
  end process;
  s_tck <= bd_nxt(bd_nxt'length-1);

  process(i_clk,i_rst_n) -- transmitter
  begin
    if (i_rst_n='0') then
      s_dat <= (others => '1');
      s_bsy <= (others => '0');
    elsif (i_clk'event and i_clk = '1') then
      s_dat <= s_dat;
      s_bsy <= s_bsy;
      if (s_bsy(0) = '0') then
        if (i_str = '1') then
          s_dat <= '1' & i_dat & "01";
          s_bsy <= (others => '1');
        end if;
      else
        if (s_tck = '1') then
          s_dat <= '1' & s_dat(s_dat'length-1 downto 1);
          s_bsy <= '0' & s_bsy(s_bsy'length-1 downto 1);
        end if;
      end if;
    end if;
  end process;

  o_bsy  <= s_tck;
  o_txd  <= s_dat(0);

end rtl;
----------------------------------------------------------------------
