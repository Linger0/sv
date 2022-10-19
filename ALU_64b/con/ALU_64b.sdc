create_clock -period 1 -name vclk
set_input_delay 0 -clock vclk [all_inputs]
set_output_delay 0 -clock vclk [all_outputs]
