
----------------------------------------------------------------------
-- myCccGat
----------------------------------------------------------------------
-- (c) 2016 by Anton Mause
--
-- Instantiate Clock Conditioning Circuit to use ClockGating
--
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;

----------------------------------------------------------------------
entity myCccGat is
port( i_clk, i_gat : in  std_logic;
      o_clk : out std_logic );
end myCccGat;

----------------------------------------------------------------------
architecture DEF_ARCH of myCccgat is

component VCC
    port( Y : out   std_logic );
end component;

component GND
    port( Y : out   std_logic );
end component;

component CCC
    generic (INIT:std_logic_vector(209 downto 0) := "00" & x"0000000000000000000000000000000000000000000000000000"; 
          VCOFREQUENCY:real := 0.0);
    port( Y0              : out   std_logic;
          Y1              : out   std_logic;
          Y2              : out   std_logic;
          Y3              : out   std_logic;
          PRDATA          : out   std_logic_vector(7 downto 0);
          LOCK            : out   std_logic;
          BUSY            : out   std_logic;
          CLK0            : in    std_logic := 'U';
          CLK1            : in    std_logic := 'U';
          CLK2            : in    std_logic := 'U';
          CLK3            : in    std_logic := 'U';
          NGMUX0_SEL      : in    std_logic := 'U';
          NGMUX1_SEL      : in    std_logic := 'U';
          NGMUX2_SEL      : in    std_logic := 'U';
          NGMUX3_SEL      : in    std_logic := 'U';
          NGMUX0_HOLD_N   : in    std_logic := 'U';
          NGMUX1_HOLD_N   : in    std_logic := 'U';
          NGMUX2_HOLD_N   : in    std_logic := 'U';
          NGMUX3_HOLD_N   : in    std_logic := 'U';
          NGMUX0_ARST_N   : in    std_logic := 'U';
          NGMUX1_ARST_N   : in    std_logic := 'U';
          NGMUX2_ARST_N   : in    std_logic := 'U';
          NGMUX3_ARST_N   : in    std_logic := 'U';
          PLL_BYPASS_N    : in    std_logic := 'U';
          PLL_ARST_N      : in    std_logic := 'U';
          PLL_POWERDOWN_N : in    std_logic := 'U';
          GPD0_ARST_N     : in    std_logic := 'U';
          GPD1_ARST_N     : in    std_logic := 'U';
          GPD2_ARST_N     : in    std_logic := 'U';
          GPD3_ARST_N     : in    std_logic := 'U';
          PRESET_N        : in    std_logic := 'U';
          PCLK            : in    std_logic := 'U';
          PSEL            : in    std_logic := 'U';
          PENABLE         : in    std_logic := 'U';
          PWRITE          : in    std_logic := 'U';
          PADDR           : in    std_logic_vector(7 downto 2) := (others => 'U');
          PWDATA          : in    std_logic_vector(7 downto 0) := (others => 'U');
          CLK0_PAD        : in    std_logic := 'U';
          CLK1_PAD        : in    std_logic := 'U';
          CLK2_PAD        : in    std_logic := 'U';
          CLK3_PAD        : in    std_logic := 'U';
          GL0             : out   std_logic;
          GL1             : out   std_logic;
          GL2             : out   std_logic;
          GL3             : out   std_logic;
          RCOSC_25_50MHZ  : in    std_logic := 'U';
          RCOSC_1MHZ      : in    std_logic := 'U';
          XTLOSC          : in    std_logic := 'U' );
end component;

component GCLKINT
    port( A : in    std_logic := 'U';
          EN : in    std_logic := 'U';
          Y : out   std_logic );
end component;

  signal gnd_net, vcc_net, GL0_net : std_logic;
  signal nc7, nc6, nc2, nc5, nc4, nc3, nc1, nc0 : std_logic;

begin

vcc_inst : VCC
      port map(Y => vcc_net);
    
gnd_inst : GND
      port map(Y => gnd_net);
    
GGL0_INST : GCLKINT
      port map(A => GL0_net, EN => i_gat, Y => o_clk);

CCC_INST : CCC
      generic map(INIT => "00" & x"004007F87FFE044164000318C6318AD318C622004040407FFFFF",
         VCOFREQUENCY => 800.000)
      port map(Y0 => OPEN, Y1 => OPEN, Y2 => OPEN, Y3 => OPEN, 
        PRDATA(7) => nc7, PRDATA(6) => nc6, PRDATA(5) => nc5, 
        PRDATA(4) => nc4, PRDATA(3) => nc3, PRDATA(2) => nc2, 
        PRDATA(1) => nc1, PRDATA(0) => nc0, LOCK => OPEN, BUSY
         => OPEN, CLK0 => i_clk, CLK1 => vcc_net, CLK2 => vcc_net, 
        CLK3 => vcc_net, NGMUX0_SEL => gnd_net, NGMUX1_SEL => 
        gnd_net, NGMUX2_SEL => gnd_net, NGMUX3_SEL => gnd_net, 
        NGMUX0_HOLD_N => vcc_net, NGMUX1_HOLD_N => vcc_net, 
        NGMUX2_HOLD_N => vcc_net, NGMUX3_HOLD_N => vcc_net, 
        NGMUX0_ARST_N => vcc_net, NGMUX1_ARST_N => vcc_net, 
        NGMUX2_ARST_N => vcc_net, NGMUX3_ARST_N => vcc_net, 
        PLL_BYPASS_N => vcc_net, PLL_ARST_N => gnd_net, 
        PLL_POWERDOWN_N => gnd_net, GPD0_ARST_N => vcc_net, 
        GPD1_ARST_N => vcc_net, GPD2_ARST_N => vcc_net, 
        GPD3_ARST_N => vcc_net, PRESET_N => gnd_net, PCLK => 
        vcc_net, PSEL => vcc_net, PENABLE => vcc_net, PWRITE => 
        vcc_net, PADDR(7) => vcc_net, PADDR(6) => vcc_net, 
        PADDR(5) => vcc_net, PADDR(4) => vcc_net, PADDR(3) => 
        vcc_net, PADDR(2) => vcc_net, PWDATA(7) => vcc_net, 
        PWDATA(6) => vcc_net, PWDATA(5) => vcc_net, PWDATA(4) => 
        vcc_net, PWDATA(3) => vcc_net, PWDATA(2) => vcc_net, 
        PWDATA(1) => vcc_net, PWDATA(0) => vcc_net, CLK0_PAD => 
        gnd_net, CLK1_PAD => gnd_net, CLK2_PAD => gnd_net, 
        CLK3_PAD => gnd_net, GL0 => GL0_net, GL1 => OPEN, GL2 => 
        OPEN, GL3 => OPEN, RCOSC_25_50MHZ => gnd_net, RCOSC_1MHZ
         => gnd_net, XTLOSC => gnd_net);

end DEF_ARCH;
------------------------------------------------------------------------------

-- HowTo : This piece of source code was creted using Libero SoC 11.7 : 
-- Create new vhdl project, block flow, SmartFusion2 M2S010S-TQ144, no template, no files.
-- Create new SmartDesign, open catalog, drag CCC Clock Conditining Circuit to canvas.
-- Configure CL0 input A to source FPGA clk0, input B sourced from FPGA clk1, all at 1 MHz.
-- Promote signal to toplevel, generate component, open hdl and extract relevant components.

------------------------------------------------------------------------------
