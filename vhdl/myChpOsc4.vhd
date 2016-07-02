
----------------------------------------------------------------------
-- myChpOsc
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Instantiate 50 MHz OnChip RC Oscillator
-- 
-- !!Watch Out!! Think twice where the OnChip Oscillator can be used.
-- The datasheet allows it to be up to 7% off, beside having 1% typ.
-- In real world you face silicon, power and temperature variations.
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;

----------------------------------------------------------------------
entity myChpOsc is
port (
	i_rst_n : IN  std_logic;
	o_clk   : OUT std_logic );
end myChpOsc;

----------------------------------------------------------------------
architecture DEF_ARCH of myChpOsc is

  component RCOSC_25_50MHZ
    generic (FREQUENCY:real := 50.0);
    port( CLKOUT : out   std_logic );
  end component;

  component RCOSC_25_50MHZ_FAB
    port( A      : in    std_logic := 'U';
          CLKOUT : out   std_logic );
  end component;

  component CLKINT
    port( A : in    std_logic := 'U';
          Y : out   std_logic );
  end component;

  signal N_RCOSC_25_50MHZ_CLKINT, N_RCOSC_25_50MHZ_CLKOUT : std_logic;

begin

  I_RCOSC_25_50MHZ : RCOSC_25_50MHZ
    generic map(FREQUENCY => 50.0)
    port map(CLKOUT => N_RCOSC_25_50MHZ_CLKOUT);
    
  I_RCOSC_25_50MHZ_FAB : RCOSC_25_50MHZ_FAB
    port map(A => N_RCOSC_25_50MHZ_CLKOUT, CLKOUT => N_RCOSC_25_50MHZ_CLKINT);

  I_RCOSC_25_50MHZ_FAB_CLKINT : CLKINT
    port map(A => N_RCOSC_25_50MHZ_CLKINT, Y => o_clk);

end DEF_ARCH;
------------------------------------------------------------------------------

-- HowTo : This piece of source code was created using Libero SoC 11.7 :
-- Create new vhdl project, block flow, SmartFusion2 M2S010S-TQ144, no template, no files.
-- Create new SmartDesign, open catalog, drag Chip Oscillators and drop to canvas.
-- Configure ChipOsc to enable OnChip 25/50MHz RC Oscillator to drive fabric logic
-- Promote signal to toplevel, generate component, open hdl and extract relevant components

------------------------------------------------------------------------------
