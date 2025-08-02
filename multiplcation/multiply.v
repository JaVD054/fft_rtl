module multiply #(
    WIDTH = 8
) (
    input clkin,
    input [WIDTH-1:0] a_in,
    input [WIDTH-1:0] b_in,
    output reg ready,
    output reg [2*WIDTH-1:0] product
);
    reg [WIDTH:0] a_temp;
    reg [WIDTH:0] b_temp;

    reg [WIDTH:0] a_op;
    reg [2*WIDTH:0] b_op;

    always @(posedge clkin) begin
        if (b==0) begin
            ready <= 1'b1;
        end
        else if (ready==1'b1 && a!=0 && b!=0) begin
            ready <= 1'b0;
            product <= 0;
        end
        else if (ready != 0) begin
            if (b[0] = 1'b1) begin
                product <= product + a<<;
            end
            b <= b>>1

        end
    end
endmodule