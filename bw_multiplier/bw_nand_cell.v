module bw_nand_cell (
	input wire a,
	input wire b,
	input wire cin,
	input wire sin,
	output wire cout,
	output wire sout
);

FA f0 (.a(~(a & b)), .b(cin), .cin(sin), .s(sout), .cout(cout));

endmodule
