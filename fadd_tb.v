module fadd_cla_tb #(
    parameter input_size = 2,
    parameter depth = 5,
    parameter cycles = 100
) ();

    localparam bit_width = input_size ** depth;
    reg [bit_width-1:0] in1;
    reg [bit_width-1:0] in2;
    reg [bit_width-1:0] sum;
    reg cin, cout;

    fadd #(
        .input_size(input_size),
        .depth     (depth)
    ) u_fadd (
        .in1 (in1),
        .in2 (in2),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );


    initial begin
        $dumpfile("circuit.vcd");
        $dumpvars;
    end

    integer i;
    initial begin
        for (i = 0; i < cycles; i = i + 1) begin
            #80;
            in1 = $random;
            in2 = $random;
            cin = $random;
            #20;
            $display("====================%d====================", i);
            $display("in1:%b\nin2:%b\ncin:%b\nsum:%b\ncout:%b\n\n", in1, in2,
                     cin, sum, cout);
        end

        $finish;
    end

endmodule
