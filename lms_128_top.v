module lms_top (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         in_valid,           // new input sample valid
    input  wire signed [15:0] error_in,     // LMS error
    input  wire signed [15:0] feedforward_in, // optional feedback or initial feedforward
    input  wire signed [15:0] desired_in,   // desired output
    input  wire signed [15:0] u_in,         // LMS step size
    output wire signed [31:0] out_sample,   // LMS filter output
    output wire                out_valid     // output valid signal
);

    parameter TAPS = 128;

    // ------------------------
    // Internal wires
    // ------------------------
    wire signed [31:0] feedforward_core;
    wire signed [31:0] weight_adjust_core;
    wire                core_out_valid;
    wire                fir_go;
    wire                fir_done;

    wire signed [15:0] error_buf;
    wire signed [15:0] feedforward_buf;
    wire signed [15:0] desired_buf;
    wire signed [15:0] u_buf;
    wire                buf_valid;

    // ------------------------
    // Input Buffer
    // ------------------------
    input_buffer ibuf (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .error_in(error_in),
        .feedforward_in(feedforward_in),
        .desired_in(desired_in),
        .u_in(u_in),
        .error_out(error_buf),
        .feedforward_out(feedforward_buf),
        .desired_out(desired_buf),
        .u_out(u_buf),
        .outvalid(buf_valid)
    );

    // ------------------------
    // Core FSM + MAC
    // ------------------------
    core_fsm_mac core_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(buf_valid),              // use buffered valid
        .error_in(error_buf),
        .feedforward_in(feedforward_buf),
        .desired_in(desired_buf),
        .u_in(u_buf),
        .fir_done(fir_done),               // FIR handshake
        .feedforward_out(feedforward_core),
        .weight_adjust(weight_adjust_core),
        .out_sample(out_sample),                     // optional: core could output FIR capture if desired
        .out_valid(core_out_valid),
        .fir_go(fir_go)                    // signal FIR to start
    );

    // ------------------------
    // Dual-MAC FIR + Weight Module
    // ------------------------
    fir_weight #(
        .TAPS(TAPS)
    ) fir_inst (
        .clk(clk),
        .rst_n(rst_n),
        .feedforward_in(feedforward_core),
        .weight_adjust(weight_adjust_core),
        .go(fir_go),
        .out_sample(out_sample),
        .out_valid(out_valid),
        .done(fir_done)
    );

endmodule
