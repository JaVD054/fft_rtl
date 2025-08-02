
`timescale 1ns/1ps

module multiply_tb;

    parameter WIDTH = 8;
    parameter PWIDTH = 2*WIDTH - 1;

    reg clkin;
    reg [WIDTH-1:0] a_in;
    reg [WIDTH-1:0] b_in;
    wire [PWIDTH-1:0] product;
    wire sign;
    wire ready;

    // Instantiate DUT
    multiply #(.WIDTH(WIDTH)) dut (
        .clkin(clkin),
        .a_in(a_in),
        .b_in(b_in),
        .ready(ready),
        .sign(sign),
        .product(product)
    );

    // Clock generation
    initial clkin = 0;
    always #5 clkin = ~clkin; // 10ns clock period

    // Task to apply inputs and wait for result
    task test(input signed [WIDTH-1:0] a, input signed [WIDTH-1:0] b);
        integer cycles;
        reg signed [PWIDTH-1:0] expected;
        reg signed [PWIDTH-1:0] actual;
        begin
            a_in <= a;
            b_in <= b;
            expected = a * b;
            cycles = 0;

            // Wait for previous 'ready' to go low
            @(posedge clkin);
            // while (ready)
            //     @(posedge clkin);

            // Now wait for 'ready' to go high for current input
            while (!ready) begin
                @(posedge clkin);
                cycles = cycles + 1;
            end

            actual = $signed(product);

            if (actual === expected)
                $display("\033[1;32mPASS\033[0m: a = %0d, b = %0d, expected = %0d, result = %0d, sign = %0d, clocks = %0d",
                        a, b, expected, actual, sign, cycles + 1);
            else
                $display("\033[1;31mFAIL\033[0m: a = %0d, b = %0d, expected = %0d, result = %0d, sign = %0d, clocks = %0d",
                        a, b, expected, actual, sign, cycles + 1);
        end
    endtask

    reg signed [WIDTH-1:0] rand_a, rand_b;

    

    integer i;
    integer n = 20;  // Number of random tests

    initial begin
        $dumpfile("multiply_tb.vcd");
        $dumpvars(0, multiply_tb);

        // Apply random tests
        for (i = 0; i < n; i = i + 1) begin
            rand_a = $random;
            rand_b = $random;
            test(rand_a, rand_b);
        end

        #20;
        $finish;
    end

endmodule
