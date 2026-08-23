module reverse_subtractor4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] result,
    output wire cout
);

    subtractor4 sub_reverse (
        .a(b),
        .b(a),
        .result(result),
        .cout(cout)
    );

endmodule
