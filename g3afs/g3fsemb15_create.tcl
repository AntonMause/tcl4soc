#
# Microsemi Tcl Script for libero SoC
# (c) 2016 by Anton Mause 
#
# (for Fusion Embeded Dev Kit )
#
# untested
#

# 
set PATH_SOURCES   .
set PATH_LINKED    ../../11p9/g3fsEmb15_lnk
set PATH_IMPORTED  ../../11p9/g3fsEmb15_src

# where are we
puts -nonewline "Sources Path  : "
puts $PATH_SOURCES
#
puts -nonewline "Linked Path   : "
puts $PATH_LINKED
#
puts -nonewline "Imported Path : "
puts $PATH_IMPORTED

puts -nonewline "Current Path  : "
puts [pwd]

# create new project
new_project -location $PATH_LINKED -name {g3fsEmb15_lnk} -project_description {G3 Fusion Embedded Kit} \
	-block_mode 0 -standalone_peripheral_initialization 0 -use_enhanced_constraint_flow 1 -hdl {VHDL} \
	-family {Fusion} -die {M1AFS1500} -package {484 FBGA} -speed {STD} -die_voltage {1.5} \
	-part_range {COM} -adv_options {IO_DEFT_STD:LVCMOS 3.3V} -adv_options {RESTRICTPROBEPINS:1} \
	-adv_options {RESTRICTSPIPINS:0} -adv_options {TEMPR:COM} -adv_options {VCCI_1.5_VOLTR:COM} \
	-adv_options {VCCI_1.8_VOLTR:COM} -adv_options {VCCI_2.5_VOLTR:COM} \
	-adv_options {VCCI_3.3_VOLTR:COM} -adv_options {VOLTR:COM} 
	
# initialy link to source files, HDL and constraints
create_links \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./brdLexSwxEmb.vhd} \
         -hdl_source {./brdRstClk.vhd} \
         -hdl_source {./brdConstEmb_pkg.vhd} \
         -hdl_source {./myChpOsc3.vhd} \
         -hdl_source {../vhdl/myDff.vhd} \
         -hdl_source {../vhdl/myDffCnt.vhd} \
         -hdl_source {../vhdl/myRngOsc.vhd} \
         -hdl_source {../vhdl/OscRngCnt.vhd} \
         -hdl_source {../vhdl/mySerRxd.vhd} \
         -hdl_source {../vhdl/mySerTxd.vhd} \
         -hdl_source {../vhdl/OscChpCnt.vhd} \
         -hdl_source {../vhdl/OscXtlCnt.vhd} \
         -hdl_source {../vhdl/OscXtlSer.vhd} \
         -hdl_source {../vhdl/OscXtlTxd.vhd} 
#
create_links \
         -convert_EDN_to_HDL 0 \
         -pdc {./g3brdEmb.io.pdc} \
         -pdc {./g3ledEmb.io.pdc}
		 
set_root -module {OscRngCnt::work} 
organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscRngCnt::work} \
	-file {./g3ledEmb.io.pdc}

set_root -module {OscChpCnt::work} 
organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscChpCnt::work} \
	-file {./g3ledEmb.io.pdc}

set_root -module {OscXtlCnt::work} 
organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlCnt::work} \
	-file {./g3brdEmb.io.pdc} \
	-file {./g3ledEmb.io.pdc}

set_root -module {OscXtlSer::work} 
organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlSer::work} \
	-file {./g3brdEmb.io.pdc} \
	-file {./g3ledEmb.io.pdc}

set_root -module {OscXtlTxd::work} 
organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlTxd::work} \
	-file {./g3brdEmb.io.pdc} \
	-file {./g3ledEmb.io.pdc}

set_root -module {OscRngCnt::work} 
save_project 
# close_project -save 1 

# save/make copy of project changing from "linked files" to "imported files"
save_project_as -location $PATH_IMPORTED -name {g3fsEmb15_src} -replace_links 1 -files {all} -designer_views {all} 
save_project 

# copy project to ZIP archive
project_archive -location $PATH_LINKED -name {g3fsEmb15_src} -replace_links 1 -files {all} -designer_views {all} 
save_project 

# show current/process working directory
puts -nonewline "Current Path  : "
puts [pwd]

# build project if arguments passed to script
if { $::argc > 0 } {

set PATH_CURRENT   $PATH_IMPORTED
cd $PATH_CURRENT
puts -nonewline "Current Path  : "
puts $PATH_CURRENT

set_root -module {OscRngCnt::work} 
# complete toolflow for reference
run_tool -name {SYNTHESIZE} 
run_tool -name {COMPILE} 
run_tool -name {PLACEROUTE} 
run_tool -name {VERIFYTIMING} 
run_tool -name {GENERATEPROGRAMMINGDATA}  
run_tool -name {EXPORTPROGRAMMINGFILE} 
# run_tool -name {PROGRAMDEVICE} 
#
# clean up project after exporting
delete_files -file $PATH_CURRENT/designer/impl1/OscRngCnt_placeroute_log.rpt -from_disk 
clean_tool -name {PLACEROUTE} 
#
delete_files -file $PATH_CURRENT/designer/impl1/OscRngCnt.adb -from_disk 
delete_files -file $PATH_CURRENT/designer/impl1/OscRngCnt_compile_log.rpt -from_disk 
clean_tool -name {COMPILE} 
#
delete_files -file $PATH_CURRENT/synthesis/OscRngCnt.edn -from_disk 
clean_tool -name {SYNTHESIZE} 
#
save_project  
#
}
#
