 
----------------------------------------------------------------------
-- myRngOsc
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Generate chain of BUFD delay elements to create ring oscillator.
-- !! This source is simplified for demonstration purpose !!
-- !! It is not intended to become part of real designs !!
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity myRngOsc is
  generic (N : Integer);
  port ( i_rst_n : IN std_logic;
         o_clk : out std_logic );
end entity myRngOsc;

----------------------------------------------------------------------
architecture rtl of myRngOsc is

component BUFD -- BUF element with "do not remove" attribute
  port( A : in  std_logic;
        Y : out std_logic );
end component;

component NAND2 -- 
  port( A, B : in  std_logic;
        Y : out std_logic );
end component;

  signal s : std_logic_vector(N downto 0);

begin

NAND_0 : NAND2 port map( A => i_rst_n, B => s(0), Y => s(N) );

BUFD_0 : for I in N-1 downto 0 generate
  GEN_BUFD : BUFD port map( A => s(I+1), Y => s(I) );
end generate;

  o_clk <= s(0);

end architecture rtl;
----------------------------------------------------------------------
