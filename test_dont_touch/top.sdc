set PERIOD 1.0

reset_design
#set_dont_touch mem

create_clock -name CLK -period 10 [get_ports clk]
set_input_delay 3 -max -clock CLK [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 3 -max -clock CLK [all_outputs]

set_output_delay 1 -max -clock CLK  [get_pins {u_mem/rst u_mem/din}]
set_input_delay 1 -max -clock CLK  [get_pins u_mem/dout]

set_load -pin_load 0.3 [all_outputs]
