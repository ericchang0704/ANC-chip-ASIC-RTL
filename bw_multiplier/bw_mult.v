module bw_mult # (
	parameter N = 4
) (
	input wire [N-1:0] a, b,
	output wire [2*N-1:0] p
);

wire [N:0] FA_cout;		// Final row of FA chain
assign FA_cout[0] = 1'b1;


genvar r, i, j;
generate
	// Matrix of signals
	for (r = 0; r <= N; r = r + 1) begin: ROW
		wire [N:0]   sout_row;
		wire [N-1:0] cout_row;
		if (r == 0) begin
			assign cout_row = 'b0;
			assign sout_row = 'b0;
		end else begin
			assign p[r-1] = sout_row[0];	// Connect to output
			if (r == N) begin
				assign sout_row[N] = 1'b1;
			end else begin
				assign sout_row[N] = 1'b0;
			end
		end
	end

	// Cell array
	for (i=0; i<N; i=i+1) begin
		for (j=0; j<N; j=j+1) begin
			if (((i != N-1) & (j == N-1)) | ((i == N-1) & (j != N-1))) begin
				bw_nand_cell b0 (.a(a[j]), .b(b[i]), .cin(ROW[i].cout_row[j]), .sin(ROW[i].sout_row[j+1]), .cout(ROW[i+1].cout_row[j]), .sout(ROW[i+1].sout_row[j]));
			end else begin
				bw_and_cell  b0 (.a(a[j]), .b(b[i]), .cin(ROW[i].cout_row[j]), .sin(ROW[i].sout_row[j+1]), .cout(ROW[i+1].cout_row[j]), .sout(ROW[i+1].sout_row[j]));
			end
		end
	end

	// Final row of FA
	for (j=0; j<N; j=j+1) begin
		FA f0 (.a(ROW[N].cout_row[j]), .b(FA_cout[j]), .cin(ROW[N].sout_row[j+1]), .s(p[N+j]), .cout(FA_cout[j+1]));
	end
endgenerate
endmodule