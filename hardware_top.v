module hardware_top (
	input wire clk,
	input wire rst_n,

	output wire ws,
	output wire sck,

	// Error mic
	input wire sd_e,
	// Reference mic
	input wire sd_x,
	// Audio input
	input wire sd_a,
	// LMS step size input
	input wire sd_u,

	//OUT TO DAC
	output wire ws_out,
	output wire sck_out,
	output wire sd_out,

	// Initialization bits (serially shifted in on reset)
	input wire init_in,
    
        // FPGA bypass
        input       signed  [25:0]  weight_inject
);

wire signed [15:0] e_in;
wire signed [15:0] x_in;
wire signed [15:0] a_in;
wire signed [15:0] u_in;

wire e_vld, e_rdy;
wire x_vld, x_rdy;
wire a_vld, a_rdy;
wire u_vld, u_rdy;

i2s_rx i2s_rx_e (.clk(clk), .rst_n(rst_n), .ws(ws), .sck(sck), .sd(sd_e), .dout(e_in), .dout_vld(e_vld), .dout_rdy(e_rdy), .sck_period(i2s_in_clk_period));
i2s_rx i2s_rx_x (.clk(clk), .rst_n(rst_n), .sd(sd_x), .dout(x_in), .dout_vld(x_vld), .dout_rdy(x_rdy), .sck_period(i2s_in_clk_period));
i2s_rx i2s_rx_a (.clk(clk), .rst_n(rst_n), .sd(sd_a), .dout(a_in), .dout_vld(a_vld), .dout_rdy(a_rdy), .sck_period(i2s_in_clk_period));
i2s_rx i2s_rx_u (.clk(clk), .rst_n(rst_n), .sd(sd_u), .dout(u_in), .dout_vld(u_vld), .dout_rdy(u_rdy), .sck_period(i2s_in_clk_period));

// Handshake with controller
wire data_valid;
wire controller_ready;

// Only enabling first 3 since u doesn't necessarily need to be updated and synchronized every cycle. Figure out later
vr_merge #(4) vr_merge_inst (
	.i_en(4'b1111),
	.i_valid({e_vld, x_vld, a_vld, u_vld}),
	.o_ready({e_rdy, x_rdy, a_rdy, u_rdy}),
	.o_valid(data_valid),
	.i_ready(controller_ready)
);

// Initialization Sequence: Shifting in Initialization Bits
localparam init_len = 22;	// *Need to change counter length too, also see google sheets on current def
reg [init_len-1:0] init_bits;
reg [4:0] init_cnt;
wire [7:0] i2s_in_clk_period, i2s_out_clk_period;
wire bypass_mode_sel;
wire [4:0] prog_delay_sel;

assign {i2s_in_clk_period, i2s_out_clk_period, bypass_mode_sel, prog_delay_sel} = init_bits;

always @ (posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		init_bits <= '0;
		init_cnt <= '0;
	end else if (!init_done) begin
		init_bits <= {init_in, init_bits[init_len-1:1]};

		if (init_cnt == init_len-1) begin
			init_done <= 1'b1;
		end else begin
			init_cnt <= init_cnt + 1;
		end
	end
end


// wire signed [15:0] out_sample;	// FIR filter output
// wire               out_valid;	// output valid signal

anc_top anc_top_inst (
	.clk(clk),
	.rst_n(rst_n),
	.init_done(init_done),
	.prog_delay_sel(prog_delay_sel),
	.bypass_mode_sel(bypass_mode_sel),
	.in_valid(data_valid),
	.controller_ready(controller_ready),
	.u_in(u_in),
	.e_in(e_in),
	.x_in(x_in),
	.a_in(a_in),
	.out_sample(out_sample),
	.out_valid(out_valid),
        .weight_inject  ( weight_inject )
);

i2s_tx i2s_tx_inst (
    .clk        (clk),
    .rst_n      (rst_n),
    .bclk_period(i2s_out_clk_period),

    .sample_vld (out_valid),
    .sample     (out_sample),

    .lr_clk     (ws_out),
    .bclk       (sck_out),
    .dout       (sd_out)
);


// Plus stuff for DAC and interface with FPGA
// if out_valid (one pulse) then send out output sample

endmodule
