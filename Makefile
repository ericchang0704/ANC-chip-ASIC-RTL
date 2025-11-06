# Simple Makefile for LMS simulation
TOP = tb_lms_128
SRC = tb_lms_128.v lms_128_top.v lms_core.v input_buffer.v FIR.v mac_unit.v

all: run

compile:
	iverilog -o sim.vvp $(SRC)

run: compile
	vvp sim.vvp

wave:
	gtkwave tb_lms_128.vcd &

clean:
	rm -f sim.vvp tb_lms_128.vcd
