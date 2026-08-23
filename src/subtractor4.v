module subtractor4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] result,
    output wire cout
);

    wire [3:0] not_b;

    not4 inv_b (
        .a(b),
        .y(not_b)
    );

    adder4 sub_adder (
        .a(a),
        .b(not_b),
        .cin(1'b1),
        .sum(result),
        .cout(cout)
    );

endmodule