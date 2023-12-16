module PGxGen #(
    parameter bit_width = 4
) (
    input [bit_width-1:0] P,
    input [bit_width-1:0] G,
    output Px,
    output Gx
);

    assign Px = &P;

    wire [bit_width-1:0] bitwise_or;
    genvar k;
    generate
        for (k = 0; k < bit_width; k = k + 1) begin : Gen_Gx
            wire tmp;
            if (k < bit_width - 1) begin : if_P
                assign tmp = &P[bit_width-1:1+k];
            end else begin
                assign tmp = 1;
            end
            assign bitwise_or[k] = G[k] & tmp;
        end

        assign Gx = |bitwise_or;
    endgenerate

endmodule
