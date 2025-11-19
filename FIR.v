module fir #(
    parameter TAPS = 256,
    parameter M = 8         // for register sizing based on TAPS = 2^M
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire signed [15:0]   x_in,               // input from controller
    input  wire signed [15:0]   a_in,               // input from controller
    input  wire signed [15:0]   weight_adjust,      // weight update from controller
    input  wire                 fir_go,             // start signal from controller
    output reg  signed [15:0]   out_sample,
    output reg                  out_valid,
    output reg                  done                // signals FIR completion to controller
);

    // Accumulator register
    reg signed [M+32:0] acc;      // 7+32+1 (128 of 32 bit values + a_in)

    reg signed [15:0] w_reg [0:TAPS-1];
    reg signed [15:0] x_reg [0:TAPS-1];

    // MAC pipeline registers
    reg signed [31:0] mult_A_prod;
    reg               mult_A_prod_valid;

    reg signed [31:0] mult_B_prod;
    reg               mult_B_prod_valid;
    reg               weight_valid;
    reg               x_reg_read_valid;     // pipeline reg for output of register read-out mux
    reg               w_reg_read_valid;


    // Process counter
    reg        [M:0]  proc_idx;

    // Addition saturation (w+x*weight_adjust)
    wire signed [16:0] sat_in;
    wire signed [15:0] sat_out;
    assign sat_in = $signed(mult_A_prod[31:15]) + $signed({w_reg[proc_idx-2][15], w_reg[proc_idx-2]});
    saturate #(17,16) saturate_inst (.in(sat_in), .out(sat_out));

    // Accumulator output saturation (a+accum)
    wire signed [M+32-15:0] sat_a_in;
    wire signed [15:0] sat_a_out;
    assign sat_a_in = acc[M+32:15];     // x_reg is q1.15 so dropping right 15 bits and then saturating top bits to 16 bits
    saturate #(M+32-15+1,16) saturate_a_inst (.in(sat_a_in), .out(sat_a_out));
    
    // Multiplier modules and pipeline registers
    reg  signed [15:0] mult_A_a, mult_A_b;
    wire signed [31:0] mult_A_p;
    bw_mult bw_mult_A (.a(mult_A_a), .b(mult_A_b), .p(mult_A_p));

    reg  signed [15:0] mult_B_a, mult_B_b;
    wire signed [31:0] mult_B_p;
    bw_mult bw_mult_B (.a(mult_B_a), .b(mult_B_b), .p(mult_B_p));

    reg fir_active;
    integer i;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < TAPS; i=i+1) begin
                w_reg[i] <= 16'sd0;
                x_reg[i] <= 16'sd0;
            end
            mult_A_prod <= 32'sd0; 
            mult_A_prod_valid <= 1'b0; 
            mult_B_prod <= 32'sd0; 
            mult_B_prod_valid <= 1'b0;
            x_reg_read_valid <= 1'b0;
            w_reg_read_valid <= 1'b0;
            weight_valid <= 1'b0;
            acc <= {(M+33){1'b0}};
            out_sample <= 16'sd0;
            out_valid <= 1'b0;
            done <= 1'b0;
            proc_idx <= {(M+1){1'b0}};
            fir_active <= 1'b0;
        end else begin
            out_valid <= 1'b0;
            done <= 1'b0;

            if (fir_go && !fir_active) begin
                fir_active <= 1'b1;
                acc <= a_in;        // initialize accumulator with a_in
                proc_idx <= {(M+1){1'b0}};
                mult_A_a <= weight_adjust;

                for (i = TAPS-1; i > 0; i=i-1) begin
                    x_reg[i] <= x_reg[i-1];
                end
                x_reg[0] <=  x_in;  
            end


            if (fir_active) begin
                // ---- MAC A: weight update ----
                if (proc_idx < TAPS) begin
                    mult_A_b <= x_reg[proc_idx];    // pipeline reg for multiplier input (after register read-out mux)
                    x_reg_read_valid <= 1'b1;
                end else begin
                    x_reg_read_valid <= 1'b0;
                end

                if (x_reg_read_valid) begin
                    mult_A_prod <= mult_A_p;
                    mult_A_prod_valid <= 1'b1;
                end else begin
                    mult_A_prod <= 32'sd0;
                    mult_A_prod_valid <= 1'b0;
                end

                if (mult_A_prod_valid) begin
                    w_reg[proc_idx-2] <= sat_out;   // w_reg[proc_idx-2] + mult_A_prod
                    weight_valid <= 1'b1;
                end else begin
                    weight_valid <= 1'b0;
                end

                // ---- MAC B: output computation ----
                if (weight_valid) begin
                    mult_B_a <= w_reg[proc_idx-3];  // pipeline reg for multiplier input (after register read-out mux)
                    mult_B_b <= x_reg[proc_idx-3];
                    w_reg_read_valid <= 1'b1;
                end else begin
                    w_reg_read_valid <= 1'b0;
                end

                if (w_reg_read_valid) begin
                    mult_B_prod <= mult_B_p;        // $signed(w_reg[proc_idx-4]) * $signed(x_reg[proc_idx-4])
                    mult_B_prod_valid <= 1'b1;
                end else begin
                    mult_B_prod <= 32'sd0;
                    mult_B_prod_valid <= 1'b0;
                end

                if (mult_B_prod_valid) begin        // last done in proc_idx == TAPS + 5
                    acc <= acc + mult_B_prod;       // should be automatically sign extended
                end
                
                proc_idx <= proc_idx + 1'b1;
                // FIR done
                if (proc_idx == TAPS + 6) begin
                    out_sample <= sat_a_out;        // saturated accum value (16 bits)
                    out_valid <= 1'b1;
                    done <= 1'b1;                   // notify controller
                    fir_active <= 1'b0;             // reset for next run
                    acc <= {(M+33){1'b0}};
                    proc_idx <= {(M+1){1'b0}};
                end
            end
        end
    end

endmodule
