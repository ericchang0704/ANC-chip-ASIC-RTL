// lms_128.v
// 128-tap LMS with two MAC pipelines (behavioral, synthesizable).
// Assumptions:
//  - Inputs, error, u: signed [15:0] (Q1.15 assumed)
//  - Weights stored as signed [31:0] (Q17.15 assumed) to allow accumulation
//  - Multiplications are signed, intermediate widths chosen to avoid overflow
//  - Fixed-point fractional bits (FRAC) = 15 (changeable)

module lms_128 (
    input  wire         clk,
    input  wire         rst_n,        // active-low reset
    // Streaming input sample (from microphone)
    input  wire         in_valid,     // one cycle pulse when new sample is available
    input  wire signed [15:0] in_sample,
    input  wire signed [15:0] error_in, // LMS error for this new sample
    input  wire signed [15:0] u_in,     // step-size (mu)
    // Output
    output reg  signed [31:0] out_sample, // accumulated output (scaled)
    output reg              out_valid
);

    parameter TAPS = 128;
    parameter IDX_W = 7; // ceil(log2(128)) = 7
    parameter FRAC = 15; // fractional bits (Q1.15)

    // Inputs shift register (128 x 16)
    reg signed [15:0] x_reg [0:TAPS-1];

    // Weights register: keep wider to track updates (32-bit signed)
    reg signed [31:0] w_reg [0:TAPS-1];

    // Internal pipeline / control
    reg [1:0] state;
    localparam S_IDLE  = 2'd0;
    localparam S_RUN   = 2'd1;
    localparam S_DONE  = 2'd2;

    reg [IDX_W:0] proc_idx; // index 0..TAPS (extra bit for flush)
    reg signed [31:0] eu;   // error * u (32-bit signed)

    // MAC A pipeline: compute delta = eu * x[i]  => width: 32 * 16 -> 48
    reg signed [47:0] deltaA;       // computed this cycle
    reg                deltaA_valid;
    reg signed [47:0] deltaA_reg;   // delayed one cycle (applied to weight next cycle)
    reg                deltaA_reg_valid;

    // MAC B pipeline: compute prod = w_new[i] * x[i] => 32 * 16 -> 48
    reg signed [47:0] prodB;        // computed this cycle
    reg                prodB_valid;
    reg signed [47:0] prodB_reg;    // delayed one cycle (accumulate next cycle)
    reg                prodB_reg_valid;

    // Accumulator for output (wide)
    reg signed [63:0] acc; // wide accumulator to avoid overflow

    integer i;

    // Initialization of weights to zero
    initial begin
        for (i = 0; i < TAPS; i = i + 1) begin
            x_reg[i] = 16'sd0;
            w_reg[i] = 32'sd0;
        end
    end

    // Sample input handling: on in_valid, shift inputs and store new sample,
    // set up eu and start processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            state <= S_IDLE;
            proc_idx <= 0;
            eu <= 32'sd0;
            deltaA <= 48'sd0;
            deltaA_valid <= 1'b0;
            deltaA_reg <= 48'sd0;
            deltaA_reg_valid <= 1'b0;
            prodB <= 48'sd0;
            prodB_valid <= 1'b0;
            prodB_reg <= 48'sd0;
            prodB_reg_valid <= 1'b0;
            acc <= 64'sd0;
            out_sample <= 32'sd0;
            out_valid <= 1'b0;
        end else begin
            out_valid <= 1'b0; // default low each cycle; asserted only when done

            if (in_valid && state == S_IDLE) begin
                // Shift input register (x_reg): newest sample pushed at index 0
                for (i = TAPS-1; i > 0; i = i - 1) begin
                    x_reg[i] <= x_reg[i-1];
                end
                x_reg[0] <= in_sample;

                // compute eu = error_in * u_in (signed multiply)
                eu <= $signed(error_in) * $signed(u_in); // 16x16 -> 32

                // Initialize pipeline control
                proc_idx <= 0;
                acc <= 64'sd0;
                deltaA_valid <= 1'b0;
                deltaA_reg_valid <= 1'b0;
                prodB_valid <= 1'b0;
                prodB_reg_valid <= 1'b0;

                // Move to RUN state
                state <= S_RUN;
            end else if (state == S_RUN) begin
                // ---- MAC A: start computing delta for current proc_idx (if in range) ----
                if (proc_idx < TAPS) begin
                    // delta = eu * x_reg[proc_idx]  : eu is 32-bit, x is 16-bit -> 48-bit
                    deltaA <= $signed(eu) * $signed(x_reg[proc_idx]); // 32*16 -> 48
                    deltaA_valid <= 1'b1;
                end else begin
                    deltaA_valid <= 1'b0;
                    deltaA <= 48'sd0;
                end

                // ---- pipeline shift for deltaA -> will be applied to weight next cycle ----
                deltaA_reg <= deltaA;
                deltaA_reg_valid <= deltaA_valid;

                // ---- Apply previous delta to weight (for index proc_idx-1) ----
                if (deltaA_reg_valid) begin
                    // target index:
                    if (proc_idx != 0) begin
                        // apply to w[proc_idx-1]
                        // deltaA_reg is 48-bit (eu * x)
                        // shift right by FRAC to bring fixed-point scaling back to weight Q-format
                        // w_new = w_old + (delta >> FRAC)
                        w_reg[proc_idx-1] <= $signed(w_reg[proc_idx-1]) + ($signed(deltaA_reg) >>> FRAC);
                    end else begin
                        // idx==0: no previous weight to apply to (shouldn't happen because deltaA_reg_valid for idx==0 will be false on first)
                    end
                end

                // ---- MAC B: start computing product for index proc_idx-1 using newly-updated weight ----
                // We want prodB to use the "new" weight value for idx-1. Because we just wrote w_reg[proc_idx-1] above,
                // reading it in the same cycle is allowed in most synchronous semantics for combinational multiply, but
                // to model realistic pipelining we use the written value in next cycle. Here we'll start prodB for idx-1
                // when proc_idx > 0 (i.e. previous weight was updated this cycle).
                if (proc_idx != 0 && deltaA_reg_valid) begin
                    // multiply updated weight by x[proc_idx-1]
                    // w_reg[proc_idx-1] is 32-bit signed (Q17.15), x_reg[proc_idx-1] is 16-bit (Q1.15)
                    // product width 32*16 -> 48
                    prodB <= $signed(w_reg[proc_idx-1]) * $signed(x_reg[proc_idx-1]);
                    prodB_valid <= 1'b1;
                end else begin
                    prodB_valid <= 1'b0;
                    prodB <= 48'sd0;
                end

                // pipeline shift for prodB
                prodB_reg <= prodB;
                prodB_reg_valid <= prodB_valid;

                // ---- Accumulate prodB_reg into acc (apply same FRAC shift to align) ----
                if (prodB_reg_valid) begin
                    // scale down by FRAC to align fixed point and accumulate
                    acc <= acc + ($signed(prodB_reg) >>> FRAC);
                end

                // increment proc_idx. We run until we've kicked off TAPS computations, then allow pipeline to flush.
                proc_idx <= proc_idx + 1'b1;

                // When we've advanced past all taps and drained pipeline (proc_idx == TAPS+2), we're done
                if (proc_idx == TAPS + 2) begin
                    // produce output: acc truncated to 32-bit for out_sample
                    out_sample <= acc[31:0];
                    out_valid <= 1'b1;
                    state <= S_DONE;
                end
            end else if (state == S_DONE) begin
                // stay DONE until next in_valid (which returns to IDLE) or we can auto-return
                // we'll return to IDLE and wait for next in_valid
                state <= S_IDLE;
            end
        end
    end

endmodule