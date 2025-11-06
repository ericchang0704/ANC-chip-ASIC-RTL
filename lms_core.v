module core_fsm_mac #(
    parameter FRAC = 15
)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         in_valid,          // from input_buffer
    input  wire signed [15:0] error_in,
    input  wire signed [15:0] feedforward_in,
    input  wire signed [15:0] desired_in,
    input  wire signed [15:0] u_in,        // step-size

    input  wire         fir_done,          // FIR done signal

    output reg signed [31:0] feedforward_out, // feed to FIR
    output reg signed [31:0] weight_adjust,   // (error - desired) * u
    output reg               out_valid,       // core output ready
    output reg               fir_go           // go signal for FIR
);

    localparam S_IDLE = 2'd0, S_RUN = 2'd1, S_DONE = 2'd2;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            feedforward_out <= 32'sd0;
            weight_adjust <= 32'sd0;
            out_valid <= 1'b0;
            fir_go <= 1'b0;
        end else begin
            out_valid <= 1'b0; // default
            fir_go <= 1'b0;    // default

            case (state)
                S_IDLE: begin
                    if (in_valid) begin
                        // compute weight adjustment
                        weight_adjust <= ($signed(error_in) - $signed(desired_in)) * $signed(u_in);
                        feedforward_out <= feedforward_in;  // feed input to FIR
                        fir_go <= 1'b1;                     // signal FIR to start
                        state <= S_RUN;
                    end
                end

                S_RUN: begin
                
                    if (fir_done) begin
                        out_valid <= 1'b1;  // core output ready
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    state <= S_IDLE; // ready for next input
                end
            endcase
        end
    end

endmodule
