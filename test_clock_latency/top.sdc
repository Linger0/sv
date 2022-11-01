reset_design
create_clock -period 3 -waveform {1.5 3} -name clk [get_ports clk]

set_clock_latency 0.5 [get_clocks clk]
# set_clock_uncertainty -setup 0.6 clk

set_multicycle_path 0 -setup -from [get_ports {op1 op2}]
set_input_delay 0 -max -clock_fall -network_latency_included -clock clk [get_ports {op1 op2 en1 en2}]
set_output_delay 0 -clock_fall -network_latency_included -clock clk [get_ports {res}]