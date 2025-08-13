module mul_double (
    input  wire [63:0] a,      
    input  wire [63:0] b,       
    output wire [63:0] result   
);

    // Extract sign, exponent, mantissa
    wire sign_a     = a[63];
    wire sign_b     = b[63];
    wire [10:0] exp_a = a[62:52];
    wire [10:0] exp_b = b[62:52];
    wire [51:0] mant_a = a[51:0];
    wire [51:0] mant_b = b[51:0];

    // Add implicit leading 1 for normalized numbers
    wire [52:0] frac_a = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};
    wire [52:0] frac_b = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

    // Calculate sign
    wire sign_res = sign_a ^ sign_b;

    // Exponent calculation (bias is 1023 for double)
    wire [12:0] exp_sum = exp_a + exp_b - 11'd1023;

    // Mantissa multiplication using multiply module
    wire [105:0] mant_prod;

    multiply #(.WIDTH(53)) mant_mult (
        .a(frac_a),
        .b(frac_b),
        .product(mant_prod)
    );

    // Normalize
    wire norm = mant_prod[105];
    wire [10:0] exp_res = exp_sum + norm;
    wire [51:0] mant_res = norm ? mant_prod[104:53] : mant_prod[103:52];

    // Handle zero, infinity, NaN
    wire a_zero = (exp_a == 0) && (mant_a == 0);
    wire b_zero = (exp_b == 0) && (mant_b == 0);
    wire a_inf  = (exp_a == 11'h7FF) && (mant_a == 0);
    wire b_inf  = (exp_b == 11'h7FF) && (mant_b == 0);
    wire a_nan  = (exp_a == 11'h7FF) && (mant_a != 0);
    wire b_nan  = (exp_b == 11'h7FF) && (mant_b != 0);

    reg [63:0] res;
    always @(*) begin
        if (a_nan || b_nan) begin
            res = 64'h7FF8000000000000; // NaN
        end else if (a_inf || b_inf) begin
            if (a_zero || b_zero)
                res = 64'h7FF8000000000000; // Inf * 0 = NaN
            else
                res = {sign_res, 11'h7FF, 52'd0}; // Inf
        end else if (a_zero || b_zero) begin
            res = {sign_res, 11'd0, 52'd0}; // Zero
        end else begin
            res = {sign_res, exp_res, mant_res};
        end
    end

    assign result = res;

endmodule