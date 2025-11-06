module input_buffer (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         in_valid,
    input  wire signed [15:0] error_in,
    input  wire signed [15:0] feedforward_in,
    input  wire signed [15:0] desired_in,
    input  wire signed [15:0] u_in,

    output reg  signed [15:0] error_out,
    output reg  signed [15:0] feedforward_out,
    output reg  signed [15:0] desired_out,
    output reg  signed [15:0] u_out,
    output reg                outvalid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin

            error_out       <= 16'sd0;
            feedforward_out <= 16'sd0;
            desired_out     <= 16'sd0;
            u_out           <= 16'sd0;
            outvalid        <= 1'b0;
        end else if (in_valid) begin
            error_out       <= error_in;
            feedforward_out <= feedforward_in;
            desired_out     <= desired_in;
            u_out           <= u_in;
            outvalid        <= 1'b1;
        end else begin
            outvalid <= 1'b0;
        end
    end

endmodule
