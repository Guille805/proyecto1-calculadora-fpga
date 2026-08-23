module tb_register4;

    reg  [3:0] d;
    reg  clk;

    wire [3:0] q;

    register4 uut (
        .d(d),
        .clk(clk),
        .q(q)
    );

    initial begin

        $monitor("clk=%b d=%b | q=%b",
                 clk, d, q);

        clk = 0;
        d = 4'b0011;

        #5;
        clk = 1;

        #5;
        clk = 0;

        d = 4'b1010;

        #5;
        clk = 1;

        #5;
        clk = 0;

        d = 4'b1111;

        #5;
        clk = 1;

        #5;
        clk = 0;

        $finish;

    end

endmodule
