----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Apr 18 21:32:25 2016
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: mySerTxd_tb.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010S> <Package::144 TQ>
-- Author: <Name>
--
--------------------------------------------------------------------------------

-- for simulation, initialise vectors, edit code below in mySerTxd.vhd
--  signal bd_cur, bd_nxt : unsigned(c_bd_div_width downto 0) := (others=>'0');
--  signal s_dat, s_bsy : std_logic_vector(10 downto 0) := (others=>'0');


library ieee;
use ieee.std_logic_1164.all;

entity mySerTxd_tb is
end mySerTxd_tb;

architecture behavioral of mySerTxd_tb is

    constant SYSCLK_PERIOD : time := 20 ns;

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';
    signal txd, busy, strobe : std_logic := '0';
    signal data : std_logic_vector(7 downto 0) := x"55";

    component mySerTxd
        generic ( 
            baud   : positive;
            freq   : positive );
        port( 
            i_clk   : in std_logic;
            i_rst_n : in std_logic;
            i_str   : in std_logic;
            i_dat   : in std_logic_vector(7 downto 0);
            o_bsy   : out std_logic;
            o_txd   : out std_logic );
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
            wait for ( SYSCLK_PERIOD * 2 );

            strobe <= '1';
            wait for ( SYSCLK_PERIOD * 1 );

            strobe <= '0';
            wait for ( SYSCLK_PERIOD * 600 );

            data <= x"33";
            wait for ( SYSCLK_PERIOD * 1 );

            strobe <= '1';
            wait for ( SYSCLK_PERIOD * 1 );

            strobe <= '0';
            wait for ( SYSCLK_PERIOD * 600 );

            data <= x"66";
            wait for ( SYSCLK_PERIOD * 1 );

            strobe <= '1';
            wait for ( SYSCLK_PERIOD * 1 );

            strobe <= '0';
            wait for ( SYSCLK_PERIOD * 600 );

            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  mySerTxd
    mySerTxd_0 : mySerTxd
        generic map( 
            baud  => 1,
            freq  => 32 )
        port map( 
            i_clk   => SYSCLK,
            i_rst_n => NSYSRESET,
            i_str   => strobe,
            i_dat   => data,
            o_bsy   => busy,
            o_txd   => txd );

end behavioral;

