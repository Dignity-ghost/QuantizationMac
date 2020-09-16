set synopsys_dc_setup_file 0

if { $synopsys_dc_setup_file == 0} {
set target_library [ list /home/eda/project/lib/smic180/std/synopsys/typical.db]

set link_library "* $target_library"}

define_design_lib WORK -path "work"

analyze -library WORK -format verilog ../rtl/core.v
analyze -library WORK -format systemverilog ../rtl/instruction.sv

elaborate -architecture verilog -library WORK core

check_design

create_clock clk -name ideal_clock1 -period 1000000
set_input_delay 0 [remove_from_collection [all_inputs] clk] -clock ideal_clock1
set_output_delay 0 [all_outputs] -clock ideal_clock1

set_max_area 0

compile -map_effort medium -area_effort medium

report_area >  synth_area.rpt
report_cell >  synth_cells.rpt
report_qor >  synth_qor.rpt
report_resources >  synth_resoutces.rpt
report_timing -max_paths 100000 >  synth_timing.rpt
write_sdc core.sdc

write -f ddc -hierarchy -output core.ddc

write -hierarchy -format verilog -output core.v