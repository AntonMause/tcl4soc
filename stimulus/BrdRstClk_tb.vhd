----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Wed Apr 13 23:57:16 2016
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: BrdRstClk_tb.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO> <Die::AGL600V2> <Package::256 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity BrdRstClk_tb is
end BrdRstClk_tb;

architecture behavioral of BrdRstClk_tb is

    constant SYSCLK_PERIOD : time := 20 ns; -- 50MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';
    signal RST_N : std_logic;
    signal CLK_OUT : std_logic;

    component BrdRstClk
      port ( i_rst_n, i_clk : in std_logic;
             o_rst_n, o_clk : out std_logic );
    end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 2 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  BrdRstClk
    BrdRstClk_0 : BrdRstClk
        -- port map
        port map( 
            -- Inputs
            i_rst_n => NSYSRESET,
            i_clk   => SYSCLK,

            -- Outputs
            o_rst_n =>  RST_N,
            o_clk   =>  CLK_OUT

            -- Inouts

        );

end behavioral;

