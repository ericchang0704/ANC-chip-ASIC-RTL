module mac_unit #(
    parameter FRAC = 15
)(
    input  wire              clk,
    input  wire              rst_n,
    input  wire              enable,
    input  wire signed [31:0] w,
    input  wire signed [15:0] x,
    output reg  signed [47:0] prod_out,
    output reg               valid_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prod_out  <= 0;
            valid_out <= 0;
        end else if (enable) begin
            prod_out  <= $signed(w) * $signed(x);
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule
