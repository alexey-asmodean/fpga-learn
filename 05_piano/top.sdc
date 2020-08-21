create_clock -name {clk} -period 48Mhz [get_ports {clk}]
derive_clock_uncertainty
set_false_path -from [get_clocks {clk}] -to [get_ports {q}]
set_false_path -from [get_ports {s1}] -to [get_clocks {clk}]
set_false_path -from [get_ports {s2}] -to [get_clocks {clk}]
set_false_path -from [get_ports {s3}] -to [get_clocks {clk}]
set_false_path -from [get_ports {s4}] -to [get_clocks {clk}]
