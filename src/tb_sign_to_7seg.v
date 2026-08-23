module tb_sign_to_7seg;

    reg sign;
    wire [6:0] seg;

    sign_to_7seg uut (
        .sign(sign),
        .seg(seg)
    );

    initial begin

        $monitor("sign=%b | seg=%b", sign, seg);

        sign = 0;
        #10;

        sign = 1;
        #10;

        $finish;

    end

endmodule