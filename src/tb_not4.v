module tb_not4;

    reg  [3:0] a;
    wire [3:0] y;

    not4 uut (
        .a(a),
        .y(y)
    );

    initial begin

        $monitor("a=%b | y=%b", a, y);

        a = 4'b0000;
        #10;

        a = 4'b0011;
        #10;

        a = 4'b1010;
        #10;

        a = 4'b1111;
        #10;

        $finish;

    end

endmodule
