module tb_adder4;

    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    wire [3:0] sum;
    wire cout;

    adder4 uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin

        $monitor("a=%b b=%b cin=%b | sum=%b cout=%b",
                 a, b, cin, sum, cout);

        a = 4'b0011; b = 4'b0010; cin = 0;
        #10;

        a = 4'b0111; b = 4'b0001; cin = 0;
        #10;

        a = 4'b1111; b = 4'b0001; cin = 0;
        #10;

        a = 4'b1010; b = 4'b0101; cin = 0;
        #10;

        $finish;

    end

endmodule
