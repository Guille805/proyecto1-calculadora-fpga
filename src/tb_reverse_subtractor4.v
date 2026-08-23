module tb_reverse_subtractor4;

    reg  [3:0] a;
    reg  [3:0] b;

    wire [3:0] result;
    wire cout;

    reverse_subtractor4 uut (
        .a(a),
        .b(b),
        .result(result),
        .cout(cout)
    );

    initial begin

        $monitor("a=%b b=%b | result=%b cout=%b",
                 a, b, result, cout);

        // B - A = 7 - 3 = 4
        a = 4'b0011;
        b = 4'b0111;
        #10;

        // B - A = 3 - 7 = -4
        a = 4'b0111;
        b = 4'b0011;
        #10;

        // B - A = 5 - 5 = 0
        a = 4'b0101;
        b = 4'b0101;
        #10;

        // B - A = 1 - (-2) = 3
        a = 4'b1110;
        b = 4'b0001;
        #10;

        $finish;

    end

endmodule
