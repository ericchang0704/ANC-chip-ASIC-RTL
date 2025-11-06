module fir_weight #(
    parameter TAPS = 128,
    parameter FRAC = 15
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire signed [31:0]   feedforward_in,   // input from core
    input  wire signed [31:0]   weight_adjust,    // weight update from core
    input  wire                 go,               // start signal from core
    output reg  signed [31:0]   out_sample,
    output reg                  out_valid,
    output reg                  done              // signals FIR completion to core
);

    reg signed [31:0] w_reg [0:TAPS-1];
    reg signed [31:0] x_reg [0:TAPS-1];

    // MAC pipeline registers
    reg signed [47:0] deltaA;
    reg               deltaA_valid;

    reg signed [47:0] prodB;
    reg               prodB_valid;

    reg signed [63:0] acc;
    reg [7:0] proc_idx;

    reg fir_active;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < TAPS; i=i+1) begin
                w_reg[i] <= 32'sd0;
                x_reg[i] <= 32'sd0;
            end
            deltaA <= 48'sd0; deltaA_reg <= 48'sd0;
            deltaA_valid <= 1'b0; deltaA_reg_valid <= 1'b0;
            prodB <= 48'sd0; prodB_reg <= 48'sd0;
            prodB_valid <= 1'b0; prodB_reg_valid <= 1'b0;
            acc <= 64'sd0;
            out_sample <= 32'sd0;
            out_valid <= 1'b0;
            done <= 1'b0;
            proc_idx <= 0;
            fir_active <= 1'b0;
        end else begin
            out_valid <= 1'b0;
            done <= 1'b0;

            if (go && !fir_active) begin
                fir_active <= 1'b1;
                acc <= 64'sd0;
                proc_idx <= 0;

                for (i = TAPS-1; i > 0; i=i-1) begin
                    x_reg[i] <= x_reg[i-1];
                end
                x_reg[0] <=  feedforward_in;  
            end

            if (fir_active) begin
                // ---- MAC A: weight update ----
                if (proc_idx < TAPS) begin
                    deltaA <= $signed(weight_adjust) * $signed(x_reg[proc_idx]);
                    deltaA_valid <= 1'b1;
                end else begin
                    deltaA <= 48'sd0;
                    deltaA_valid <= 1'b0;
                end

                if (deltaA_valid && proc_idx != 0) begin
                    w_reg[proc_idx-1] <= w_reg[proc_idx-1] + ($signed(deltaA) >>> FRAC);
                end

                // ---- MAC B: output computation ----
                if (proc_idx-1 != 0 && deltaA_reg_valid) begin
                    prodB <= $signed(w_reg[proc_idx-2]) * $signed(x_reg[proc_idx-2]);
                    prodB_valid <= 1'b1;
                end else begin
                    prodB <= 48'sd0;
                    prodB_valid <= 1'b0;
                end

                // pipeline shift
                prodB_reg <= prodB;
                prodB_reg_valid <= prodB_valid;

                if (prodB_reg_valid) begin
                    acc <= acc + ($signed(prodB_reg) >>> FRAC);
                end

                // increment index
                proc_idx <= proc_idx + 1'b1;

                // FIR done
                if (proc_idx == TAPS + 2) begin
                    out_sample <= acc[31:0];
                    out_valid <= 1'b1;
                    done <= 1'b1;       // notify core
                    fir_active <= 1'b0; // reset for next run
                    acc <= 64'sd0;
                    proc_idx <= 0;
                end
            end
        end
    end

endmodule
