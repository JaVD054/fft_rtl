module multiply #(
    parameter WIDTH = 8
) (
    input clkin,
    input [WIDTH-1:0] a_in,
    input [WIDTH-1:0] b_in,
    output reg ready,
    output sign,
    output reg [2*WIDTH-2:0] product
);




    reg [WIDTH-1:0] a_temp;
    reg [WIDTH-1:0] b_temp;

    reg [2*WIDTH-2:0] product_op;
    reg [WIDTH-1:0] b_op;
    reg [2*WIDTH-3:0] a_op;

    initial begin
        a_temp = 0;
        b_temp = 0;
        ready = 0;
    end
    

    assign sign = a_in[WIDTH-1] ^ b_in[WIDTH-1];

    always @(posedge clkin) begin
        if (a_in != a_temp || b_in != b_temp) begin
            a_temp <= a_in;
            b_temp <= b_in;

            a_op <= a_in[WIDTH-1] ? -a_in : a_in;
            b_op <= b_in[WIDTH-1] ? -b_in : b_in;

            product_op <= 0;
            ready <= 0;
        end
        else if (!ready) begin
            if (b_op != 0) begin
                if (b_op[0])
                    product_op <= product_op + a_op;
                a_op <= a_op << 1;
                b_op <= b_op >> 1;
            end
            else begin
                product <= sign ? -product_op : product_op;
                ready <= 1;
            end
        end
    end
endmodule
