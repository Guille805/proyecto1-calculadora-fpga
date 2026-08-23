module shift_right4 (
    input  wire [3:0] a,
    input  wire [1:0] shift,
    output wire [3:0] result
);

    wire nshift0;
    wire nshift1;

    wire [3:0] stage1;
    wire [3:0] stage2;

    wire s1_0_a;
    wire s1_0_b;

    wire s1_1_a;
    wire s1_1_b;

    wire s1_2_a;
    wire s1_2_b;

    wire s2_0_a;
    wire s2_0_b;

    wire s2_1_a;
    wire s2_1_b;

    not (nshift0, shift[0]);
    not (nshift1, shift[1]);

    // stage1: shift de 0 o 1 posición

    and (s1_0_a, a[0], nshift0);
    and (s1_0_b, a[1], shift[0]);
    or  (stage1[0], s1_0_a, s1_0_b);

    and (s1_1_a, a[1], nshift0);
    and (s1_1_b, a[2], shift[0]);
    or  (stage1[1], s1_1_a, s1_1_b);

    and (s1_2_a, a[2], nshift0);
    and (s1_2_b, a[3], shift[0]);
    or  (stage1[2], s1_2_a, s1_2_b);

    and (stage1[3], a[3], nshift0);

    // stage2: shift adicional de 0 o 2 posiciones

    and (s2_0_a, stage1[0], nshift1);
    and (s2_0_b, stage1[2], shift[1]);
    or  (stage2[0], s2_0_a, s2_0_b);

    and (s2_1_a, stage1[1], nshift1);
    and (s2_1_b, stage1[3], shift[1]);
    or  (stage2[1], s2_1_a, s2_1_b);

    and (stage2[2], stage1[2], nshift1);
    and (stage2[3], stage1[3], nshift1);

    buf (result[0], stage2[0]);
    buf (result[1], stage2[1]);
    buf (result[2], stage2[2]);
    buf (result[3], stage2[3]);

endmodule
