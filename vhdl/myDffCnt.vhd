 
----------------------------------------------------------------------
-- myDffCnt
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Generate chain of N D-FlipFlip to create toggle counter.
-- !! This source is simplified for demonstration purpose !!
-- !! It is not intended to become part of real designs !!
--
-- WatchOut : Instantiation of myDff() passes arguments by index.
-- This can lead to trouble when modifying parameters in component.
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------
entity myDffCnt is
  generic (N : Integer:=8);
  port ( i_rst_n, i_clk : in std_logic;
         o_q : out std_logic_vector(N-1 downto 0) );
end entity myDffCnt;

----------------------------------------------------------------------
architecture rtl of myDffCnt is

component myDff
  port (i_rst_n, i_clk, i_d : in std_logic;
        o_q, o_nq : out std_logic);
end component myDff;

  signal s : std_logic_vector(N downto 0);

begin

  s(0) <= i_clk;

  GEN_FF : for I in N-1 downto 0 generate
    D_FF : myDff port map
      (i_rst_n,  s(I), s(I+1), o_q(I), s(I+1));
    end generate;

end architecture rtl;
----------------------------------------------------------------------
