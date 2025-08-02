module multiply #(
    parameter WIDTH = 8
) (
    input clkin,
    input [WIDTH-1:0] a_in,
    input [WIDTH-1:0] b_in,
    output reg ready,
    output sign,
    output [2*WIDTH-3:0] product
);

    parameter MUL_WIDTH = WIDTH - 1; // Considering last bit is signed bit

   

    reg [WIDTH-1:0] a_temp;
    reg [WIDTH-1:0] b_temp;

    reg [2*MUL_WIDTH-1:0] a_op;
    reg [MUL_WIDTH-1:0] b_op;

    reg [2*MUL_WIDTH-1:0] product_op;

    assign sign  = a_in[WIDTH-1] ^ b_in[WIDTH-1];
    assign product = product_op;

    always @(posedge clkin) begin
        
        if (a_in != a_temp || b_in != b_temp) begin
            a_temp <= a_in;
            b_temp <= b_in;
            a_op <= a_in[MUL_WIDTH-1:0];
            b_op <= b_in[MUL_WIDTH-1:0];
            ready <= 1'b0;
            product_op <= 0;
        end
        else if (!ready) begin
            if (b_op != 0) begin
                if (b_op[0] == 1'b1) begin
                    product_op <= product_op + a_op;
                end
                a_op<=a_op<<1;
                b_op <= b_op>>1;
            end else begin
                ready <= 1'b1;
            end

        end
    end
endmodule