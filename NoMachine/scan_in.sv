// NOTE: scan_in has MSB first, with the order being twiddles, mux_en, shift_coef, and win_coef

module scan_in #(
	parameter int N = 512, // number of samples per chirp
	parameter int W = 20 // bits per sample
)(
	input logic clk_scan,
	input logic scan_in, // data in serially
	output logic [N/2-1:0][W/2-1:0] win_coef, // output for all window coeff, n/2 samples, 10 bits -> NEED TO WIRE x2!
	output logic signed [$clog2(N)-2:0][$clog2(N)-1:0] shift_coef, // idx_to_shift -> is it logic signed or signed logic?
    output logic [$clog2(N)-2:0][N-1:0] mux_en, // not_shifted_mask
    output logic signed [N/2-1:0][W-1:0] twiddles,	// output for all twiddles, 20 bit
	output logic scan_out // the last output of dff
);
// the order i want for my scan chain
// (in terms of reading, not sending data in)
// window LSB:MSB -> shift LSB:MSB -> mux_en LSB:MSB -> tw LSB:MSB -> twiddle LSB:MSB

// data is [x][y] el
// the loading order will be el[0][0],...,el[0][y],...,el[x][0],...el[x][y]

    logic win_o;
    
	// window !
    scan_part #(
        .L(N/2),
        .B(W/2)
    ) WIN (
        .clk_scan(clk_scan),
        .d_in(scan_in),
        .q(win_coef),
        .q_out(win_o)
    );
    
    logic shift_o;

	// shift coefficients !
    scan_part #(
        .L($clog2(N)-1),
        .B($clog2(N))
    ) SHIFT (
        .clk_scan(clk_scan),
        .d_in(win_o),
        .q(shift_coef),
        .q_out(shift_o)
    );

    logic mux_o;
    
	// mux enables!
	scan_part #(
        .L($clog2(N)-1),
        .B(N)
    ) MUX_EN (
        .clk_scan(clk_scan),
        .d_in(shift_o),
        .q(mux_en),
        .q_out(mux_o)
    );
    
	// twiddles
	scan_part #(
        .L(N/2),
        .B(W)
    ) TW (
        .clk_scan(clk_scan),
        .d_in(mux_o),
        .q(twiddles),
        .q_out(scan_out)
    );

endmodule
