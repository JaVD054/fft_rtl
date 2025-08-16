// this module expect width as power of two

module multiply #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [2*WIDTH-1:0] product
);

parameter STAGES = $clog2(WIDTH);
parameter SUM_ARRAY_SIZE = 2*WIDTH -2;

wire [2*WIDTH-1:0] partial [WIDTH-1:0];

wire [2*WIDTH-1:0] sum [SUM_ARRAY_SIZE:0];

 
genvar p;
generate
    for (p = 0; p < WIDTH; p = p + 1) begin : PARTIALS
        assign partial[p] = b[p] ? (a << p) : {2*WIDTH{1'b0}};
        assign sum[p] = partial[p];
    end
endgenerate

genvar i;

generate
    for (i = WIDTH; i <=SUM_ARRAY_SIZE; i = i+1) begin : SUM

        for ( j = offset; j< offset+WIDTH>>i; ) begin
            
        end
        offset = j
    end
endgenerate

assign product = sum[0];

endmodule