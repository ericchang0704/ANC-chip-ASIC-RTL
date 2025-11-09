module saturate # (
	parameter IN_W 	= 17,
	parameter OUT_W = 16
) (
	input  wire signed [IN_W-1:0]  in,
	output wire signed [OUT_W-1:0] out
);

wire not_oververflow;
assign not_oververflow = &(in[IN_W-1:OUT_W-1]) | ~(|in[IN_W-1:OUT_W-1]);	// truncated range and sign bit same
assign not_oververflow ? in[OUT_W-1:0] :
						{in[IN_W-1], {(OUT_W-1){~in[IN_W-1]}}};				// set max(pos)/min(neg) depending on sign bit

endmodule