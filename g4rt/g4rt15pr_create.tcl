#
# Microsemi Tcl Script for libero SoC
# (c) 2016 by Anton Mause 
#
# Microsemi RTG4 Proto Kit for (2015)
# Board populated with production silicon
#
# tested with board RevB silicon Rev2
#

# 
set PATH_SOURCES   .
set PATH_LINKED    ../../11p9/g4rt15pr_lnk
set PATH_IMPORTED  ../../11p9/g4rt15pr_src

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
new_project -location $PATH_LINKED -name {g4rt15pr_lnk} -project_description {RTG4 150 Proto DevKit} \
	-block_mode 0 -standalone_peripheral_initialization 0 -use_enhanced_constraint_flow 1 -hdl {VHDL} \
	-family {RTG4} -die {RT4G150} -package {1657 CG} -speed {STD} -die_voltage {1.2} \
	-part_range {MIL} -adv_options {IO_DEFT_STD:LVCMOS 2.5V} \
	-adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} \
	-adv_options {TEMPR:MIL} -adv_options {VCCI_1.2_VOLTR:MIL} -adv_options {VCCI_1.5_VOLTR:MIL} \
	-adv_options {VCCI_1.8_VOLTR:MIL} -adv_options {VCCI_2.5_VOLTR:MIL} \
	-adv_options {VCCI_3.3_VOLTR:MIL} -adv_options {VOLTR:MIL} 

# initialy link to source files, HDL and constraints
create_links \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./brdLexSwx.vhd} \
         -hdl_source {./brdRstClk.vhd} \
         -hdl_source {./brdConst_pkg.vhd} \
         -hdl_source {./IniSftDiv.vhd} \
         -hdl_source {./myCccMux.vhd} \
         -hdl_source {./myChpOsc.vhd} \
         -hdl_source {../vhdl/myDff.vhd} \
         -hdl_source {../vhdl/myDffCnt.vhd} \
         -hdl_source {./myPllOsc1x50.vhd} \
         -hdl_source {../vhdl/myRngOsc.vhd} \
         -hdl_source {../vhdl/mySerRxd.vhd} \
         -hdl_source {../vhdl/mySerTxd.vhd} \
         -hdl_source {../vhdl/OscCccPll.vhd} \
         -hdl_source {../vhdl/OscChpCnt.vhd} \
         -hdl_source {../vhdl/OscChpMux.vhd} \
         -hdl_source {../vhdl/OscRngCnt.vhd} \
         -hdl_source {../vhdl/OscXtlCnt.vhd} \
         -hdl_source {../vhdl/OscXtlSer.vhd} \
         -hdl_source {../vhdl/OscXtlTxd.vhd} 
#        -hdl_source {../vhdl/mySynRst.vhd} 
#
create_links \
         -convert_EDN_to_HDL 0 \
         -io_pdc {./g4brd.io.pdc} \
         -io_pdc {./g4led.io.pdc}

set_root -module {OscRngCnt::work} 

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscRngCnt::work} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscChpCnt::work} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscChpMux::work} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscCccPll::work} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlCnt::work} \
	-file {./g4brd.io.pdc} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlSer::work} \
	-file {./g4brd.io.pdc} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {OscXtlTxd::work} \
	-file {./g4brd.io.pdc} \
	-file {./g4led.io.pdc}

organize_tool_files -tool {COMPILE} -input_type {constraint} -module {IniSftDiv::work} \
	-file {./g4brd.io.pdc} \
	-file {./g4led.io.pdc}

configure_tool -name {PLACEROUTE} -params {DELAY_ANALYSIS:MAX} -params {EFFORT_LEVEL:false} \
	-params {INCRPLACEANDROUTE:false} -params {MULTI_PASS_CRITERIA:VIOLATIONS} \
	-params {MULTI_PASS_LAYOUT:false} -params {NUM_MULTI_PASSES:5} -params {PDPR:false} \
	-params {REPAIR_MIN_DELAY:false} -params {SLACK_CRITERIA:WORST_SLACK} -params {SPECIFIC_CLOCK:} \
	-params {START_SEED_INDEX:1} -params {STOP_ON_FIRST_PASS:false} -params {TDPR:false} 

save_project 
# close_project -save 1 

# save/make copy of project changing from "linked files" to "imported files"
save_project_as -location $PATH_IMPORTED -name {g4rt15pr_src} -replace_links 1 -files {all} -designer_views {all} 
save_project 

# copy project to ZIP archive
project_archive -location $PATH_LINKED -name {g4rt15pr_src} -replace_links 1 -files {all} -designer_views {all} 
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
run_tool -name {GENERATEPROGRAMMINGFILE} 
export_bitstream_file \
         -file_name {OscRngCnt} \
         -export_dir {.\designer\OscRngCnt\export} \
         -format {STP} \
         -master_file 0 \
         -master_file_components {} \
         -encrypted_uek1_file 0 \
         -encrypted_uek1_file_components {} \
         -encrypted_uek2_file 0 \
         -encrypted_uek2_file_components {} \
         -trusted_facility_file 1 \
         -trusted_facility_file_components {FABRIC} \
         -add_golden_image 0 \
         -golden_image_address {} \
         -golden_image_design_version {} \
         -add_update_image 0 \
         -update_image_address {} \
         -update_image_design_version {} \
         -serialization_stapl_type {SINGLE} \
         -serialization_target_solution {FLASHPRO_3_4_5} 
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
