module tb_mux2_4bit;

    reg  [3:0] a;
    reg  [3:0] b;
    reg  sel;

    wire [3:0] y;

    mux2_4bit uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin

        $monitor("a=%b b=%b sel=%b | y=%b",
                 a, b, sel, y);

        a = 4'b0011;
        b = 4'b1100;
        sel = 0;
        #10;

        sel = 1;
        #10;

        a = 4'b1010;
        b = 4'b0101;
        sel = 0;
        #10;

        sel = 1;
        #10;

        $finish;

    end

endmodule