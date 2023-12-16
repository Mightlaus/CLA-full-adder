module Sum #(
    parameter bit_width = 4
) (
    input  [bit_width-1:0] in1,
    input  [bit_width-1:0] in2,
    input  [bit_width-1:0] carry,
    output [bit_width-1:0] sum
);

    genvar i;
    generate
        for (i = 0; i < bit_width; i = i + 1) begin : Gen_sum
            assign sum[i] = carry[i] ^ in1[i] ^ in2[i];
        end
    endgenerate
    
endmodule
