`timescale 1ns/1ps

module tb_lms_top;

    reg clk;
    reg valid;
    reg rst_n;
    reg signed [15:0] error_in;
    reg signed [15:0] feedforward_in;
    reg signed [15:0] desired_in;
    reg signed [15:0] u_in;

    wire signed [31:0] out_sample;
    wire out_valid;

    parameter CLK_PERIOD = 10;

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Instantiate LMS top module
    lms_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(valid),
        .error_in(error_in),
        .feedforward_in(feedforward_in),
        .desired_in(desired_in),
        .u_in(u_in),
        .out_sample(out_sample),
        .out_valid(out_valid)
    );

    // Testbench stimulus
    integer i;
    reg [7:0] cycle_count;

    initial begin
        rst_n = 0;
        error_in = 0;
        feedforward_in = 0;
        desired_in = 0;
        u_in = 16'sd16384; // example step size in Q1.15
        cycle_count = 0;

        #50;
        rst_n = 1;

        // Run simulation for a while
        for (i = 0; i < 20000; i = i + 1) begin
            cycle_count = cycle_count + 1;

            if (cycle_count == 200) begin
                // Feed a new input every 200 cycles
                error_in = $random % 100 - 50;
                valid=1;
                feedforward_in = $random % 100 - 50;
                desired_in = $random % 100 - 50;
                cycle_count = 0; // reset counter
            end else begin
                error_in = 0;
                valid=0;
                feedforward_in = 0;
                desired_in = 0;
            end

            @(posedge clk);
        end

        $stop;
    end

    // Optional: monitor outputs
    initial begin
        $dumpfile("lms_tb.vcd");
        $dumpvars(0, tb_lms_top);
    end

    always @(posedge clk) begin
        if (out_valid) begin
            $display("Time %0t: out_sample = %d", $time, out_sample);
        end
    end

endmodule
