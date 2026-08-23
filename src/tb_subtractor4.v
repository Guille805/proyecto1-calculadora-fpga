module tb_subtractor4;

    reg  [3:0] a;
    reg  [3:0] b;

    wire [3:0] result;
    wire cout;

    subtractor4 uut (
        .a(a),
        .b(b),
        .result(result),
        .cout(cout)
    );

    initial begin

        $monitor("a=%b b=%b | result=%b cout=%b",
                 a, b, result, cout);

        // 7 - 3 = 4
        a = 4'b0111;
        b = 4'b0011;
        #10;

        // 3 - 7 = -4 = 1100 en complemento a dos
        a = 4'b0011;
        b = 4'b0111;
        #10;

        // 5 - 5 = 0
        a = 4'b0101;
        b = 4'b0101;
        #10;

        // -2 - 1 = -3
        // -2 = 1110
        a = 4'b1110;
        b = 4'b0001;
        #10;

        $finish;

    end

endmodule
