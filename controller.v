module controller (
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire                 in_valid,           // from vr_merge
    output reg                  controller_ready,   // controller ready for vr_merge

    input  wire signed [15:0]   e_in,   
    input  wire signed [15:0]   x_in,   
    input  wire signed [15:0]   a_in,   
    input  wire signed [15:0]   u_in,               // step-size 

    input  wire                 fir_done,           // FIR done signal
    output reg                  fir_go,              // FIR go signal 

    output reg  signed [15:0]   x_out,              // feed to FIR
    output reg  signed [15:0]   a_out,              // feed to FIR
    output reg  signed [15:0]   weight_adjust       // (e - a) * u
);
    // Buffered inputs (held for algorithmic cycle)
    reg signed [15:0] e_buf, x_buf, a_buf, u_buf;

    // Subtraction saturation (e-a)
    wire signed [16:0] sat_in;
    wire signed [15:0] sat_out;
    assign sat_in = {a_delay[15], a_delay} - {e_buf[15], e_buf};    // uses delayed a
    saturate #(17,16) saturate_inst (.in(sat_in), .out(sat_out));

    // Multiplier module
    reg signed [15:0] mult_a, mult_b;
    wire signed [31:0] mult_p;
    bw_mult bw_mult_weight_adjust (.a(mult_a), .b(mult_b), .p(mult_p));

    // Programmable delay for a
    localparam prog_delay_N = 4;                                // sel width for prog_delay
    localparam integer prog_delay_L = (1 << prog_delay_N);      // Length of the shift register
    wire signed [15:0] a_delay;
    prog_delay #(prog_delay_N, prog_delay_L) prog_delay_inst (
        .clk(in_valid),     // important (should be at main sample rate 48khz)
        .rst_n(rst_n),
        .a_in(a_buf),
        .a_out(a_delay),
        .sel(0));   // delay of 10 at 48khz (208us)


    localparam S_IDLE = 2'd0, S_START = 2'd1, S_PIPE = 2'd2, S_RUN = 2'd3;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            x_out <= 16'sd0;
            weight_adjust <= 16'sd0;
            fir_go <= 1'b0;
            controller_ready <= 1'b0;
            e_buf <= 16'sd0;
            x_buf <= 16'sd0;
            a_buf <= 16'sd0;
            u_buf <= 16'sd0;
        end else begin
            // Defaults     
            fir_go <= 1'b0;          
            controller_ready <= 1'b0;

            // FSM
            case (state)
                S_IDLE: begin
                    controller_ready <= 1'b1;
                    if (in_valid) begin
                        // Buffer and hold inputs
                        e_buf <= e_in;
                        x_buf <= x_in;
                        a_buf <= a_in;
                        u_buf <= u_in;

                        state <= S_START;
                    end
                end
                S_START: begin
                    // Load multiplier inputs
                    mult_a <= sat_out;  // Saturated output of (e-a_delay)
                    mult_b <= u_buf;
                    state <= S_PIPE;
                end

                S_PIPE: begin
                    weight_adjust <= mult_p >>> 15;     // q1.15*q1.15->q2.30, but first two bits are always same so drop msb and lower 15 bits to get back q1.5
                    x_out <= x_buf;     // feed input to FIR
                    a_out <= a_buf;
                    fir_go <= 1'b1;     // signal FIR to start
                    state <= S_RUN;
                end

                S_RUN: begin
                    // wait for FIR to finish
                    if (fir_done) begin
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end

endmodule
