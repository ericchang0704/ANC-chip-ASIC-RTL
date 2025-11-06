`timescale 1ns/1ps

module tb_lms_128;
    reg clk, rst_n;
    reg in_valid;
    reg signed [15:0] in_sample, error_in, u_in;
    wire signed [31:0] out_sample;
    wire out_valid;

    lms_128_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_sample(in_sample),
        .error_in(error_in),
        .u_in(u_in),
        .out_sample(out_sample),
        .out_valid(out_valid)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_lms_128.vcd");
        $dumpvars(0, tb_lms_128);

        rst_n = 0;
        in_valid = 0;
        in_sample = 0;
        error_in = 0;
        u_in = 0;
        #20 rst_n = 1;

        repeat (4) @(posedge clk);

        u_in = 16'sd100;
        for (int n = 0; n < 10; n++) begin
            @(posedge clk);
            in_valid = 1;
            in_sample = n * 100;
            error_in = (10 - n) * 100;
            @(posedge clk);
            in_valid = 0;
            wait(out_valid);
            $display("Output @%0t: %d", $time, out_sample);
        end

        #100 $finish;
    end
endmodule
