
tcl4soc : TCL / VHDL Playgound for Microsemi Libero SOC
======================================AntonMause=2016==

This is a pool of sources and scripts to demonstrate basic use of Libero SoC 
toolsuite and devices of the generation G4(65nm) product family.

G4 := SmartFusion2/IGLOO2/RTG4

The current snapshot is intended to use Libero SoC version 11.7 (2016q2)

Unpack ./tcl4soc-RevXYZ.zip to your projects directory and name ./tcl4soc/ .
Most generic HDL sources can be found in the "./vhdl/" folder.
Also you find several g4-NameOfKit folders, one per supported board/kit group.
The g4eval folder for the Microsemi Eval kit is intended as ref/template.

Each kit folder contains all special files to create the project from scratch.
Start Libero SoC and open Menu -> Project -> Exec Script -> Select tcl script.

Naming convention for script : g4-NameOfKit-DieSize-s/g(M2S/M2GL)_create.tcl .
For example g4kick1s_create.tcl -> Kickstart M2S010S in SmartFusion2 mode.
The RT4G/RTG4 naming is g4rt15es (engineering sample) and g4rt15pr (proto).

PDC files follow the g4-FunctionalGroup.io.pdc rule.
The minimun feature set requires 8 LED output names in "g4led.io.pdc" .
Use more board features like Osc, Reset, Uart, Sw, ... with "g4brd.io.pdc" .
By default all scripts support the enhanced constraint flow.

The script will create the directories "../LiberoVersion/g4-NameOfKit-Mode/".
Mode is "..._lnk" for a project using links to the sources in the pool.
Mode is "..._src" for a similar project that imported the sources pool.
If provided an argument the script will create/clean one toplevel project.
The _src version is made from _lnk via SaveAs and option ReplaceLinks.

Use "..._src" to try changes in a local copy outside the source pool.
This project contains a complete copy of all sources and constraints.
What ever you do here will not interfere with the sources pool.

Use "..._lnk" to commit tested local changes to the source pool.
Any change you do here will directly modify data in the pool.
Be aware of side effects your changes will have to other projects.

If all changes made in "..._src" are checked and changed/commited
to the pool directory, it should be OK to delete working copys.
In a perfect world "..._create.tcl" should recreate everything.
This is primary true for simple HDL only projects not GUIed ones.

Each project should contain most of the TopLevel code snippets.
If your kits script does not support all features yet, check out the 
code from the reference/template kits create scripts and source.

Each kit comes with its own local brdAbcXyz file to fit and tweak.
Also check PDC files for signal polarity and additional information.

Signal naming convention i_ input, o_ output, s_ local, g_ global.

See "..._create.tcl" for more details.

!! The examples provided are not intended for real world application !!
!! Take a close look at the code, it may even describe why it is bad !!

=======================================================================

OscRngCnt : Blink LEDs using ring oscillator.
-myRngOsc : Chain of delay elements to build ring oscillator
-myDffCnt : Chain of D-FlipFlops to build counter/clock divider
-myDff    : Simple D-FlipFlop (intended for use in myDffCnt)
(Toplevel with smallest amount of resources, good to verify your own board)

OscChpCnt : Blink LEDs using On chip oscillator.
-myChpOsc : Use internal G4 25/50MHz RC-Osc
(Next OnDie resource involved, go and check how it works)

OscChpMux : Blink LEDs using On chip oscillator and ngMUX.
-myCccMux : Clock Conditioning Circuit with Non Glitching Mux.
(Good chance to see how NGMUX works timingwise)

OscChpGat : Blink LEDs using On chip oscillator and GCLKINT.
-myCccGat : Clock Conditioning Circuit with Clock Gating block.
(Good chance to see how GCLKINT works timingwise)

OscCccPll : Blink LEDs using On chip oscillator and PLL.
-myPllOsc50m : Use OnChip 1MHz Osc and PLL to create 50MHz.
(Can be used to check if PLL power supply is of good quality)

brdLexSwx : Control signal polarity for each Board/Kit supported.

OscXtlCnt : Blink LEDs using clock sourced by external crystal.
(This is the most precise binky using a real xtal ;-)
-brdRstClk : One file for each Board/Kit constellation.

OscXtlTxd : Send characters via default (USB?)UART at 115200 baud.
-mySerTxd : small UART transmitter fixed clock and baud rate
(Can use bare metal txd unit for debug sessions, my little printk() )

=======================================================================
List of supported or todo kits, some SF2 Kits do IGLOO2 emulation.

-g4eval   1 (Done) M2GL010T Evaluation Kit
-g4kick   0 (ToDo) M2S010S Avnet Kickstart Kit

-Total    1 Configuration
-Total    8 Toplevel projects
=======================================================================
