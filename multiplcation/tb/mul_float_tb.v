`timescale 1ns / 1ps

module tb_mul_float;

    reg  [31:0] a, b;
    wire [31:0] result;
    reg  [31:0] expected;

    // Instantiate DUT
    mul_float dut (
        .a(a),
        .b(b),
        .result(result)
    );

    task run_test;
        input [31:0] in_a;
        input [31:0] in_b;
        input [31:0] exp;
        begin
            a = in_a;
            b = in_b;
            expected = exp;
            #1;
            if (result === expected)
                $display("PASS: a=%h b=%h result=%h expected=%h",
                          a, b, result, expected);
            else
                $display("FAIL: a=%h b=%h result=%h expected=%h",
                          a, b, result, expected);
        end
    endtask

    initial begin
        // VCD dump
        $dumpfile("mul_float_tb.vcd");
        $dumpvars(0, tb_mul_float);

        $display("---- mul_float Testbench ----");

        run_test(32'h40200000, 32'h40400000, 32'h40F00000); // 2.5 * 3.0 = 7.5
        run_test(32'hBFC00000, 32'h40800000, 32'hC0C00000); // -1.5 * 4.0 = -6.0
        run_test(32'h00000000, 32'h40A00000, 32'h00000000); // 0.0 * 5.0 = 0.0
        run_test(32'h7F800000, 32'h40000000, 32'h7F800000); // Inf * 2.0 = Inf
        run_test(32'h7F800000, 32'h00000000, 32'h7FC00000); // Inf * 0.0 = NaN
        run_test(32'h7FC00000, 32'h3F800000, 32'h7FC00000); // NaN * 1.0 = NaN
        run_test(32'h3E800000, 32'h3F000000, 32'h3E000000); // 0.25 * 0.5 = 0.125

        $display("---- End of Test ----");
        $finish;
    end

endmodule
