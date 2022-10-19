create_clock -name vclk -period 2 
set_input_delay -min 0 -clock vclk [all_inputs]
set_output_delay -min -2 -clock vclk [all_outputs]
set_fix_hold vclk
