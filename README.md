
# tcl4soc

 2016 by Anton Mause

##TCL / VHDL Playground for Microsemi Libero SOC

This is a pool of sources and scripts to demonstrate basic use of Libero SoC 
toolsuite and devices of the generation G3(130nm) & G4(65nm) product families.

#### G3 := ProASIC3/IGLOO(1)/Fusion/SmartFusion(1)/RT3PE
#### G4 := SmartFusion2/IGLOO2/RTG4

The current snapshot is intended to use Libero SoC version 11.9 (2018q4)

Unpack ./tcl4soc-RevXYZ.zip to your projects directory and name ./tcl4soc/ .
Most generic HDL sources can be found in the "./vhdl/" folder.

Also you find several g4-NameOfKit folders, one per supported board/kit group.
The g4eval folder for the Microsemi Eval kit is intended as ref/template.

Each kit folder contains all special files to create the project from scratch.
Start Libero SoC and open Menu -> Project -> Exec Script -> Select tcl script.

Naming convention for g3 script : g3-Family-NameOfKit-DieSize_create.tcl .
For example g3fsemb15_create.tcl -> Fusion, Embeded Kit M1AFS1500.
(gl=Igloo, pa=ProAsic3, fs=Fusion, sf=SmartFusion, for most kits)

Naming convention for g4 script : g4-NameOfKit-DieSize-s/g(M2S/M2GL)_create.tcl .
For example g4kick1s_create.tcl -> Kickstart M2S010S in SmartFusion2 mode.
The RT4G/RTG4 naming is g4rt15es (engineering sample) and g4rt15pr (proto).

To compare resources divide G3 number by 100 to get G4 scaling (very coarse).

PDC files follow the g4-FunctionalGroup.io.pdc rule.
The minimun feature set requires 8 LED output names in "g4led.io.pdc" .
Use more board features like Osc, Reset, Uart, Sw, ... with "g4brd.io.pdc" .
By default all scripts support/require the enhanced constraint flow.

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

Each kit comes with its own local brdAbcXyz files to fit and tweak.
Also check PDC files for signal hints and additional information.

Signal naming convention i_ input, o_ output, s_ local, g_ global.

See "..._create.tcl" for more details.

!! The examples provided are not intended for real world application !!

!! Take a close look at the code, it may even describe why it is bad !!


## List of toplevel projects :

1. OscRngCnt : Blink LEDs using ring oscillator.
-myRngOsc : Chain of delay elements to build ring oscillator
-myDffCnt : Chain of D-FlipFlops to build counter/clock divider
-myDff    : Simple D-FlipFlop (intended for use in myDffCnt)
(Toplevel with smallest amount of resources, good to verify your own board)

1. OscChpCnt : Blink LEDs using On chip oscillator.
-myChpOsc : Use internal RC-Oscillator (supported in all G4 & some G3)
(Next OnDie resource involved, go and check how it works)

1. OscChpMux : Blink LEDs using On chip oscillator and ngMUX.
-myCccMux : Clock Conditioning Circuit with Non Glitching Mux.
(Good chance to see how NGMUX works timingwise)

1. OscChpGat : Blink LEDs using On chip oscillator and GCLKINT.
-myCccGat : Clock Conditioning Circuit with Clock Gating block.
(Good chance to see how GCLKINT works timingwise)

1. OscCccPll : Blink LEDs using On chip oscillator and PLL.
-myPllOsc50m : Use OnChip 1MHz Osc and PLL to create 50MHz.
(Can be used to check if PLL power supply is of good quality)
brdLexSwx :  Control signal polarity for each Board/Kit supported.

1. OscXtlCnt : Blink LEDs using clock sourced by external crystal.
(This is the most precise binky using a real xtal ;-)
-brdRstClk : One file for each Board/Kit constellation.

1. OscXtlTxd : Send characters via default (USB?)UART at 115200 baud.
-mySerTxd : small UART transmitter fixed clock and baud rate
(Can use bare metal txd unit for debug sessions, my little printk() )

1. OscXtlSer : Receive characters via default (USB?)UART at 115200 baud.
-mySerRxd : small UART receiver fixed clock and baud rate
(May use bare metal rxd/txd units for debug sessions)

1. FsmSftDiv : Shift register based clock divider with No/aSync/Sync Reset.
(Can be used to understand what is different here from SRAM FPGAs)

1. FsmPatGen : Pattern Generators with No/aSync Reset.

## List of supported kits :

1. g3afs (Test/4) Fusion Kits (M1/AFS1500/AFS600)

1. g3eval (Test/1) ProASIC3 Eval Kit (LCD/OLED)

1. g3icicle (Done/1) AGL125V2 Icicle Kit

1. g3sfeva (Test/1) A2F200 Evaluation Kit

1. g3scs (Test/7) ProAsic3/Igloo(1)/... M1/M7/... SCS/Dev Kits

1. g4adv (Test/2) M2S150TS Advanced Development Board

1. g4craft (Test/5) M2S010, M2S... EmCraft SoM FG484

1. g4dev (Done/2) M2S050T, Development Kit (PoE, CAN, ...)

1. g4eval (Done/6) M2GL010T, M2S025T, M2S090TS, Evaluation Kit

1. g4img (Test/2) M2S025T IMG Nordhausen Development Kit

1. g4kick (Done/2) M2S010S Avnet Kickstart Kit

1. g4rt (Test/2) RTG4 Development Kit (ES/PROTO)

1. g4start (Test/2) M2S050ES, EmCraft Starter Kit FG896

#### Total of 37 Configurations

#### Total of 10 Toplevel projects

B.t.w. : Some SF2 Kits support IGLOO2 emulation.

## List of highlighted features :

1. myRngOsc : Instantiate elements via GENERATE.

1. myDffCnt : Generate something in a loop.

1. brdConst_pkg : Use package for project wide constants.

1. mySerTxd : Forward constant/generic to instantiation.

1. mySerRxD : Calculate vector length from value.

1. FsmPatGen : HowTo initialize (or not) FLASH FPGAs.

1. FsmSftDiv : Fast clock divider using shift register.

1. mySynRst : Sync reset to clock.

1. g3icicle : Use macros for GLOBAL/CLOCK macro instantiation in brdRstClk.

1. g3icicle : Use macros for IO-PAD macro instantiation in brdRstClk.

1. g4eval : ./stimulus/*_tb testbenches

=======================================================================
