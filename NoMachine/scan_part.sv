module scan_part #(
    parameter int L,
    parameter int B
)(
    input logic clk_scan, // clock used
    input logic d_in, // d_in of first dff
    output logic [L-1:0][B-1:0] q, // q's of dff
    output logic q_out
);

genvar x, y;

generate
    for (x=0; x<L; x++) begin : X
        for (y=0; y<B; y++) begin : Y
            if (x==0 && y==0) begin
                dff dff (
                    .CLK(clk_scan),
                    .D(d_in),
                    .Q(q[x][y])
                );
            end else if (y == 0) begin
                dff dff (
                    .CLK(clk_scan),
                    .D(q[x-1][B-1]),
                    .Q(q[x][y])
                );
            end else begin
                dff dff (
                    .CLK(clk_scan),
                    .D(q[x][y-1]),
                    .Q(q[x][y])
                );
            end
        end
    end
endgenerate

assign q_out = q[L-1][B-1];

endmodule
