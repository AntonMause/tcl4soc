
----------------------------------------------------------------------
-- myChpOsc (myChpOsc3.vhd)
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Instantiate G3 Fusion 100 MHz OnChip RC Oscillator
-- 
-- Divide to 50 MHz to have same Frq as Xtal.
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library fusion;
use fusion.all;

----------------------------------------------------------------------
entity myChpOsc is
port (
	i_rst_n : IN  std_logic;
	o_clk   : OUT std_logic );
end myChpOsc;

----------------------------------------------------------------------
architecture DEF_ARCH of myChpOsc is

  component RCOSC
    port( CLKOUT : out   std_logic );
  end component;

  component CLKSRC
    port( A : in    std_logic := 'U';
          Y : out   std_logic );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component CLKINT
    port( A : in    std_logic := 'U';
          Y : out   std_logic );
  end component;

  component DFI1
    port( CLK : in  std_logic;
          D   : in  std_logic;
          QN  : out std_logic );
  end component; 

  signal CLKOUT100A, CLKOUT100B, CLKOUT100C : std_logic;

begin

  RCOSC100 : RCOSC
    port map(CLKOUT => CLKOUT100A);

  CLKSRC100 : CLKSRC
    port map(A => CLKOUT100A, Y => CLKOUT100B);

  DFI1_0 : DFI1
    port map( D   => CLKOUT100C,
              CLK => CLKOUT100B,
              QN  => CLKOUT100C );

  CLKINT100 : CLKINT
    port map(A => CLKOUT100C, Y => o_clk);

end DEF_ARCH;
------------------------------------------------------------------------------

-- HowTo : This piece of source code was created using Libero SoC 11.7 :
-- Create new vhdl project, block flow, Fusion AFS1500, no template, no files.
-- Create new SmartDesign, open catalog, drag Chip Oscillators and drop to canvas.
-- Promote signal to toplevel, generate component, open hdl and extract relevant components

------------------------------------------------------------------------------
