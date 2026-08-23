module tb_calculator_display;

    reg  [3:0] value;
    wire [6:0] sign_seg;
    wire [6:0] value_seg;

    calculator_display dut (
        .value(value),
        .sign_seg(sign_seg),
        .value_seg(value_seg)
    );

    initial begin

        value = 4'b0011;
        #10;
        $display("value=0011 (+3) | sign=%b value_seg=%b",
                 sign_seg, value_seg);

        value = 4'b1110;
        #10;
        $display("value=1110 (-2) | sign=%b value_seg=%b",
                 sign_seg, value_seg);

        value = 4'b1101;
        #10;
        $display("value=1101 (-3) | sign=%b value_seg=%b",
                 sign_seg, value_seg);

        value = 4'b1000;
        #10;
        $display("value=1000 (-8) | sign=%b value_seg=%b",
                 sign_seg, value_seg);

        $finish;
    end

endmodule