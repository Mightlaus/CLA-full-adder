module fadd #(
    parameter input_size = 2,
    parameter depth = 3

) (
    in1,
    in2,
    cin,
    sum,
    cout
);

    localparam bit_width = input_size ** depth;

    input [bit_width-1:0] in1;
    input [bit_width-1:0] in2;
    input cin;
    output [bit_width-1:0] sum;
    output cout;

    wire [bit_width-1:0] P;
    wire [bit_width-1:0] G;
    PGGen #(
        .bit_width(bit_width)
    ) u_PGGen (
        .in1(in1),
        .in2(in2),
        .P  (P),
        .G  (G)
    );

    wire [bit_width-1:0] carry;
    CLA #(
        .input_size(input_size),
        .depth     (depth)
    ) u_CLA (
        .G    (G),
        .P    (P),
        .cin  (cin),
        .carry(carry),
        .cout (cout),
        .Px   (),
        .Gx   ()
    );

    Sum #(
        .bit_width(bit_width)
    ) u_Sum (
        .in1  (in1),
        .in2  (in2),
        .carry(carry),
        .sum  (sum)
    );



endmodule
