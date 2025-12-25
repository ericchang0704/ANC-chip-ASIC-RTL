
set_max_transition 0.2 [current_design]

set clk_period 10
set RSTN_period 100

create_clock -name CCLK -period $clk_period Driver_N13/C
create_clock -name RSTN -period $RSTN_period Driver_N14/C
