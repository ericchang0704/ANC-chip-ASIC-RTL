module hardware_top (
	input wire clk;
	input wire rst_n;

	// Error mic
	input wire ws_e;
	input wire sck_e;
	input wire sd_e;

	// Reference mic
	input wire ws_x;
	input wire sck_x;
	input wire sd_x;

	// Audio input
	input wire ws_a;
	input wire sck_a;
	input wire sd_a;

	// LMS step size input
	input wire ws_u;
	input wire sck_u;
	input wire sd_u;
);

wire signed [15:0] e_in;
wire signed [15:0] x_in;
wire signed [15:0] a_in;
wire signed [15:0] u_in;

wire e_vld, e_rdy;
wire x_vld, x_rdy;
wire a_vld, a_rdy;
wire u_vld, u_rdy;

i2s_rx i2s_rx_e (.clk(clk), .rst_n(rst_n), .ws(ws_e), .sck(sck_e), .sd(sd_e), .dout(e_in), .dout_vld(e_vld), .dout_rdy(e_rdy));
i2s_rx i2s_rx_x (.clk(clk), .rst_n(rst_n), .ws(ws_x), .sck(sck_x), .sd(sd_x), .dout(x_in), .dout_vld(x_vld), .dout_rdy(x_rdy));
i2s_rx i2s_rx_a (.clk(clk), .rst_n(rst_n), .ws(ws_a), .sck(sck_a), .sd(sd_a), .dout(a_in), .dout_vld(a_vld), .dout_rdy(a_rdy));
i2s_rx i2s_rx_u (.clk(clk), .rst_n(rst_n), .ws(ws_u), .sck(sck_u), .sd(sd_u), .dout(u_in), .dout_vld(u_vld), .dout_rdy(u_rdy));

// Handshake with controller
wire data_valid;
wire controller_ready;

// Only enabling first 3 since u doesn't necessarily need to be updated and synchronized every cycle. Figure out later
vr_merge #(4) vr_merge_inst (
	.i_en(4'b1110),
	.i_valid({e_vld, x_vld, a_vld, u_vld}),
	.o_ready({e_rdy, x_rdy, a_rdy, u_rdy}),
	.o_valid(data_valid),
	.i_ready(controller_ready)
);

wire signed [15:0] out_sample;	// FIR filter output
wire               out_valid;	// output valid signal

anc_top anc_top_inst (
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(data_valid),
	.controller_ready(controller_ready);
	.u_in(u_in),
	.e_in(e_in),
	.x_in(x_in),
	.a_in(a_in),
	.out_sample(out_sample),
	.out_valid(out_valid)
)

// Plus stuff for DAC and interface with FPGA
// if out_valid (one pulse) then send out output sample

endmodule