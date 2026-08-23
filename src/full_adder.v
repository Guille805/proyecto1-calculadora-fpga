module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    wire axorb;
    wire ab;
    wire cin_axorb;

    xor (axorb, a, b);
    xor (sum, axorb, cin);

    and (ab, a, b);
    and (cin_axorb, cin, axorb);

    or (cout, ab, cin_axorb);

endmodule
