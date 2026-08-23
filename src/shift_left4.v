module shift_left4 (
    input  wire [3:0] a,
    input  wire [1:0] shift,
    output wire [3:0] result
);

    wire nshift0;
    wire nshift1;

    wire [3:0] stage1;
    wire [3:0] stage2;

    wire s1_1_a;
    wire s1_1_b;

    wire s1_2_a;
    wire s1_2_b;

    wire s1_3_a;
    wire s1_3_b;

    wire s2_2_a;
    wire s2_2_b;

    wire s2_3_a;
    wire s2_3_b;

    not (nshift0, shift[0]);
    not (nshift1, shift[1]);

    // stage1: shift de 0 o 1 posición
    and (stage1[0], a[0], nshift0);

    and (s1_1_a, a[1], nshift0);
    and (s1_1_b, a[0], shift[0]);
    or  (stage1[1], s1_1_a, s1_1_b);

    and (s1_2_a, a[2], nshift0);
    and (s1_2_b, a[1], shift[0]);
    or  (stage1[2], s1_2_a, s1_2_b);

    and (s1_3_a, a[3], nshift0);
    and (s1_3_b, a[2], shift[0]);
    or  (stage1[3], s1_3_a, s1_3_b);

    // stage2: shift adicional de 0 o 2 posiciones
    and (stage2[0], stage1[0], nshift1);
    and (stage2[1], stage1[1], nshift1);

    and (s2_2_a, stage1[2], nshift1);
    and (s2_2_b, stage1[0], shift[1]);
    or  (stage2[2], s2_2_a, s2_2_b);

    and (s2_3_a, stage1[3], nshift1);
    and (s2_3_b, stage1[1], shift[1]);
    or  (stage2[3], s2_3_a, s2_3_b);

    buf (result[0], stage2[0]);
    buf (result[1], stage2[1]);
    buf (result[2], stage2[2]);
    buf (result[3], stage2[3]);

endmodule