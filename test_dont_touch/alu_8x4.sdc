create_clock -period 0 -name vclk
set_input_delay -max 0 -clock vclk [all_inputs]
set_output_delay -max 0 -clock vclk [all_outputs]
