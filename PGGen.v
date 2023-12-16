module PGGen #(
    parameter bit_width = 4
) (
    input  [bit_width-1:0] in1,
    input  [bit_width-1:0] in2,
    output [bit_width-1:0] P,
    output [bit_width-1:0] G
);

    genvar i;
    generate
        for (i = 0; i < bit_width; i = i + 1) begin : PG_Gen
            assign P[i] = in1[i] ^ in2[i];
            assign G[i] = in1[i] & in2[i]; 
        end
    endgenerate

endmodule
