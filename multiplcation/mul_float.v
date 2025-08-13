module mul_float (
    input  wire [31:0] a,      // IEEE 754 single-precision float
    input  wire [31:0] b,      // IEEE 754 single-precision float
    output wire [31:0] result  // IEEE 754 single-precision float
);

    // Extract sign, exponent, mantissa
    wire sign_a     = a[31];
    wire sign_b     = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mant_a = a[22:0];
    wire [22:0] mant_b = b[22:0];

    // Add implicit leading 1 for normalized numbers
    wire [23:0] frac_a = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};
    wire [23:0] frac_b = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

    // Calculate sign
    wire sign_res = sign_a ^ sign_b;

    // Exponent calculation
    wire [8:0] exp_sum = exp_a + exp_b - 8'd127;



    // Mantissa multiplication using multiply module
    wire [47:0] mant_prod;
    multiply #(.WIDTH(24)) mant_mult (
        .a(frac_a),
        .b(frac_b),
        .product(mant_prod)
    );


    // Normalize result
    wire norm = mant_prod[47];
    wire [7:0] exp_res = exp_sum + norm;
    wire [22:0] mant_res = norm ? mant_prod[46:24] : mant_prod[45:23];

    // Handle zero, infinity, NaN
    wire a_zero = (exp_a == 0) && (mant_a == 0);
    wire b_zero = (exp_b == 0) && (mant_b == 0);
    wire a_inf  = (exp_a == 8'hFF) && (mant_a == 0);
    wire b_inf  = (exp_b == 8'hFF) && (mant_b == 0);
    wire a_nan  = (exp_a == 8'hFF) && (mant_a != 0);
    wire b_nan  = (exp_b == 8'hFF) && (mant_b != 0);

    reg [31:0] res;
    always @(*) begin
        if (a_nan || b_nan) begin
            res = 32'h7FC00000; // NaN
        end else if (a_inf || b_inf) begin
            if (a_zero || b_zero)
                res = 32'h7FC00000; // Inf * 0 = NaN
            else
                res = {sign_res, 8'hFF, 23'd0}; // Inf
        end else if (a_zero || b_zero) begin
            res = {sign_res, 8'd0, 23'd0}; // Zero
        end else begin
            res = {sign_res, exp_res, mant_res};
        end
    end

    assign result = res;

endmodule