
----------------------------------------------------------------------
-- mySerRxd.vhd
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- My simple fixed speed UART serial receiver.
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

----------------------------------------------------------------------
entity mySerRxd is
  generic ( 
    baud   : positive :=     115_200;
    freq   : positive :=  50_000_000);
  port ( 
    i_clk   : in std_logic;
    i_rst_n : in std_logic;
    i_rxd   : in std_logic;
    o_dat   : out std_logic_vector(7 downto 0);
    o_str   : out std_logic );
end mySerRxd;

----------------------------------------------------------------------
architecture rtl of mySerRxd is

  constant c_bd_div1 : integer := ((freq / baud)-2);
  constant c_bd_div2 : integer := ((freq / (16*baud))-2);
  constant c_bd_div_width : integer := integer(log2(real(c_bd_div1))) + 1;
  signal s_bd_div, s_bd_cnt : unsigned(c_bd_div_width downto 0);
  signal s_dat : std_logic_vector(7 downto 0);
  signal s_bit : std_logic_vector(9 downto 0);
  signal s_bsy, s_tck : std_logic;

begin

  s_bd_div <= to_unsigned(c_bd_div1,s_bd_cnt'length) when (s_bsy='1' and s_bit(9) = '0') 
         else to_unsigned(c_bd_div2,s_bd_cnt'length);

  process(i_clk,i_rst_n) -- clock & shift divider
--process(i_clk)
  begin
    if (i_rst_n='0') then
      s_bd_cnt <= (others=>'0');
    elsif (i_clk'event and i_clk = '1') then
      if (s_bd_cnt(s_bd_cnt'length-1) = '1') then
        s_bd_cnt <= s_bd_div;
      else
        s_bd_cnt <= s_bd_cnt -1;
      end if;
    end if;
  end process;
  s_tck <= s_bd_cnt(s_bd_cnt'length-1);

  process(i_clk,i_rst_n) -- receiver
  begin
    if (i_rst_n='0') then
      s_dat <= (others => '1');
      s_bit <= (others => '0');
      s_bsy <= '0';
      o_dat <= (others => '0');
      o_str <= '0';
    elsif (i_clk'event and i_clk = '1') then
      s_dat <= s_dat;
      o_str <= '0';
      if (s_tck = '1') then
        s_bit <= s_bit(s_bit'length-2 downto 0) & '0';
        if (s_bsy = '0') then
          if (s_dat(0) = '0') then -- found start bit
        s_bit <= s_bit(s_bit'length-2 downto 0) & '1';
            s_bsy <= '1';
          end if;
          s_dat <= i_rxd & s_dat(s_dat'length-1 downto 1);
        else -- s_bsy
          if (s_bit(8) = '1') then -- last databit
            o_dat <= i_rxd & s_dat(s_dat'length-1 downto 1);
          end if;
          if (s_bit(9) = '1') then -- stop bit
            s_dat <= (others => '1');
            s_bsy <= '0';
            o_str <= '1';
          else -- any data bit
            s_dat <= i_rxd & s_dat(s_dat'length-1 downto 1);
          end if;
        end if; -- s_bsy
      end if; -- s_tck
    end if; -- rst
  end process;

end architecture rtl;
----------------------------------------------------------------------
