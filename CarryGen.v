module CarryGen #(
    parameter bit_width=4
) (
    input [bit_width-1:0] P,
    input [bit_width-1:0] G,
    input cin,
    output [bit_width-1:0] carry,
    output cout
);

    generate
        genvar n;
        for (n = 0; n <= bit_width; n = n + 1) begin : Gen_carry
            if (n == 0) begin: assign_cin0
                assign carry[0] = cin;
            end else begin: assign_cin
                wire [n-1:0] subsum;
                wire prop;
                assign prop = cin & {&P[n-1:0]};

                genvar i;
                for (i = 0; i <= n - 1; i = i + 1) begin : Gen_subsum
                    if (n - 1 < i + 1) begin: Gi
                        assign subsum[i] = G[i];
                    end else begin: cal_subsum
                        assign subsum[i] = G[i] & {&P[n-1:i+1]};
                    end
                end

                if (n < bit_width) begin: assign_carry
                    assign carry[n] = prop | {|subsum};
                end else begin: assign_cout
                    assign cout = prop | {|subsum};
                end
            end

        end
    endgenerate
    
endmodule