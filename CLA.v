// CLA <- (CLA*, CarryGen, PGxgen)

module CLA #(
    parameter input_size = 4,  // Bit width of each CarryGen
    parameter depth = 2  // Recursion depth of CLA, starting from 1
) (
    G,
    P,
    cin,
    carry,
    cout,
    Px,
    Gx
);

    // The total bit width CLA supporting is input_size^depth
    localparam bit_width = input_size ** depth;
    input [bit_width-1:0] G;
    input [bit_width-1:0] P;
    input cin;
    output [bit_width-1:0] carry;
    output cout;
    output Px;  // Propogration signal transfering to CLA of upper level 
    output Gx;  // Generation signal transfering to CLA of upper level

    generate
        if (depth == 1) begin : deepestLevel
            // At the deepest level, CLA is comprised entirely of Carry Generator(CarryGen) and Propograte/Generate Generator(PGxGen) 
            // [input_size]P [input_size]G cin -> [input_size]carry cout
            CarryGen #(
                .bit_width(input_size)
            ) u_CarryGen (
                .P    (P),
                .G    (G),
                .cin  (cin),
                .carry(carry),
                .cout (cout)
            );

            // [input_size]P [input_size]G -> Px Gx
            PGxGen #(
                .bit_width(input_size)
            ) u_PGxGen (
                .P (P),
                .G (G),
                .Px(Px),
                .Gx(Gx)
            );

        end else begin : upperLevel
            // The ultimate goal is to find the P G signals that are transmitted to the parent CarryGen, and distribute the output from the parent CarryGen downward to serve as cin for sub CarryGen.
            reg [input_size-1:0] Pup;  // == Px,Gx of sub CarryGen == P G of parent CarryGen
            reg [input_size-1:0] Gup;
            reg [input_size-1:0] Carrydown; // == cin of sub CarryGen == carry of parent CarryGen

            genvar i;
            // For upper level, the whole CLA is partitioned into "input_size" individual sub CLAs, recursively.
            for (i = 0; i < input_size; i = i + 1) begin : sub_CLA
                // Partition the P G of upper level into the right size of lower level.
                reg [input_size**(depth-1)-1:0] P_sub;
                reg [input_size**(depth-1)-1:0] G_sub;
                reg [input_size**(depth-1)-1:0] carry_sub;

                localparam sel_begin = i * (input_size ** (depth - 1));
                localparam sel_end = sel_begin + (input_size**(depth-1)) -1;
                always @(*) begin
                    P_sub <= P[sel_end : sel_begin];
                    G_sub <= G[sel_end : sel_begin];
                end

                CLA #(
                    .input_size(input_size),
                    .depth     (depth - 1)
                ) u_CLA_sub (
                    .G    (G_sub),
                    .P    (P_sub),
                    .cin  (Carrydown[i]),
                    .carry(carry_sub),
                    .cout (),
                    .Px   (Pup[i]),
                    .Gx   (Gup[i])
                );

                // The output carries of each individual sub CLA correspond to the respective portion of the parent CLA carry.
                assign carry[sel_end:sel_begin] = carry_sub;
            end

            // Parent CarryGen
            CarryGen #(
                .bit_width(input_size)
            ) u_CarryGen (
                .P    (Pup),
                .G    (Gup),
                .cin  (cin),
                .carry(Carrydown),
                .cout (cout)
            );

            // Parent PGxGen
            PGxGen #(
                .bit_width(input_size)
            ) u_PGxGen (
                .P (Pup),
                .G (Gup),
                .Px(Px),
                .Gx(Gx)
            );

        end
    endgenerate
endmodule
