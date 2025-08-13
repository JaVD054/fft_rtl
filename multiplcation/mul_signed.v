module multiply #(
    parameter WIDTH = 8
) (
    input clkin,
    input signed [WIDTH-1:0] a_in,
    input signed [WIDTH-1:0] b_in,
    output ready,
    output sign,
    output reg [2*WIDTH-2:0] product
);



    reg prod_ready;
    reg [WIDTH-1:0] a_temp;
    reg [WIDTH-1:0] b_temp;

    reg [2*WIDTH-2:0] product_op;
    reg [WIDTH-1:0] b_op;
    reg [2*WIDTH-2:0] a_op;

    wire [WIDTH-1:0] a_abs = a_in[WIDTH-1] ? -a_in : a_in;
    wire [WIDTH-1:0] b_abs = b_in[WIDTH-1] ? -b_in : b_in;

    initial begin
        a_temp = 0;
        b_temp = 0;
        prod_ready = 0;
    end

    assign new_vlaue = a_in != a_temp || b_in != b_temp;
    
    assign ready = prod_ready && !new_vlaue;

    assign sign = a_in[WIDTH-1] ^ b_in[WIDTH-1];

    always @(posedge clkin) begin
        if (new_vlaue) begin
            a_temp <= a_in;
            b_temp <= b_in;
            if (a_abs > b_abs) begin
                a_op <= a_abs;
                b_op <= b_abs;
            end else begin
                a_op <= b_abs;
                b_op <= a_abs;
            end
            product_op <= 0;
            prod_ready <= 0;
        end
        else if (!prod_ready) begin
            if (b_op != 0) begin
                if (b_op[0])
                    product_op <= product_op + a_op;
                a_op <= a_op << 1;
                b_op <= b_op >> 1;
            end
            else begin
                product <= sign ? -product_op : product_op;
                prod_ready <= 1;
            end
        end
    end
endmodule
