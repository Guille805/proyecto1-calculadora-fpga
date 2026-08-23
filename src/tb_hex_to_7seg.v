module tb_hex_to_7seg;

    reg  [3:0] hex;
    wire [6:0] seg;

    hex_to_7seg uut (
        .hex(hex),
        .seg(seg)
    );

    initial begin

        $monitor("hex=%h | seg=%b", hex, seg);

        hex = 4'h0;
        #10;

        hex = 4'h1;
        #10;

        hex = 4'h2;
        #10;

        hex = 4'hA;
        #10;

        hex = 4'hE;
        #10;

        hex = 4'hF;
        #10;

        $finish;

    end

endmodule