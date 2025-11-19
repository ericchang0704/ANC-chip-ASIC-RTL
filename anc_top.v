module anc_top (
    input  wire               clk,
    input  wire               rst_n,

    input  wire               in_valid,           // new input sample valid
    output wire               controller_ready,   // controller ready for vr_merge

    input  wire signed [15:0] e_in,         // LMS e
    input  wire signed [15:0] x_in,         // optional feedback or initial x
    input  wire signed [15:0] a_in,         // desired output
    input  wire signed [15:0] u_in,         // LMS step size (learning rate)
    output wire signed [15:0] out_sample,   // FIR filter output
    output wire               out_valid     // output valid signal
);

parameter TAPS = 128;

// ------------------------
// Internal wires
// ------------------------
wire signed [15:0] x_controller;        // samples held by controller
wire signed [15:0] a_controller;
wire signed [15:0] weight_adjust_controller;
wire signed [15:0] fir_out;
wire               fir_done;
wire               fir_go;


// ------------------------
// Controller FSM + MAC
// ------------------------
controller controller_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .controller_ready(controller_ready),
    .e_in(e_in),
    .x_in(x_in),
    .a_in(a_in),
    .u_in(u_in),
    .fir_done(fir_done),               // signal back when FIR is done
    .fir_go(fir_go),                   // signal for FIR to start
    .x_out(x_controller),
    .a_out(a_controller),
    .weight_adjust(weight_adjust_controller)
);

// ------------------------
// Dual-MAC FIR + Weight Module
// ------------------------
fir #(
    .TAPS(TAPS)
) fir_inst (
    .clk(clk),
    .rst_n(rst_n),
    .x_in(x_controller),
    .a_in(a_controller),
    .weight_adjust(weight_adjust_controller),
    .fir_go(fir_go),
    .out_sample(out_sample),
    .out_valid(out_valid),
    .done(fir_done)
);

endmodule
