module sign_to_7seg (
    input  wire sign,
    output wire [6:0] seg
);

    // A
    and (seg[6], 1'b0, sign);

    // B
    and (seg[5], 1'b0, sign);

    // C
    and (seg[4], 1'b0, sign);

    // D
    and (seg[3], 1'b0, sign);

    // E
    and (seg[2], 1'b0, sign);

    // F
    and (seg[1], 1'b0, sign);

    // G: se enciende solo si sign = 1
    buf (seg[0], sign);

endmodule