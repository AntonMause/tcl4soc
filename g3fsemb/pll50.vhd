-- Version: v11.7 11.7.0.119

library ieee;
use ieee.std_logic_1164.all;
library fusion;
use fusion.all;

entity pll50 is

    port( CLKOUT : out   std_logic
        );

end pll50;

architecture DEF_ARCH of pll50 is 

  component RCOSC
    port( CLKOUT : out   std_logic
        );
  end component;

  component CLKSRC
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

    signal CLKOUTTEMP, \GND\ : std_logic;
    signal GND_power_net1 : std_logic;

begin 

    \GND\ <= GND_power_net1;

    RCOSC1 : RCOSC
      port map(CLKOUT => CLKOUTTEMP);
    
    clksrc1 : CLKSRC
      port map(A => CLKOUTTEMP, Y => CLKOUT);
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);


end DEF_ARCH; 

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:11.7.0.119
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA3SOC
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_CCC_RCOSC
-- LPM_HINT:NONE
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:T
-- DESDIR:D:/Anton/11p7/g3fsemb15_src/smartgen\pll50
-- GEN_BEHV_MODULE:F
-- SMARTGEN_DIE:M1IR10X10M3
-- SMARTGEN_PACKAGE:fg484
-- AGENIII_IS_SUBPROJECT_LIBERO:T
-- DRIVE_MODE:0

-- _End_Comments_

