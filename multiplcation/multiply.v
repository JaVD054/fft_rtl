module multiply #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [2*WIDTH-1:0] product
);

wire [2*WIDTH-1:0] partial [WIDTH-1:0];
wire [2*WIDTH-1:0] sum [WIDTH:0];

assign sum[0] = {2*WIDTH{1'b0}};

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : PARTIALS
        assign partial[i] = b[i] ? (a << i) : {2*WIDTH{1'b0}};
        assign sum[i+1] = sum[i] + partial[i];
    end
endgenerate

assign product = sum[WIDTH];

endmodule