module not4 (
    input  wire [3:0] a,
    output wire [3:0] y
);

    not (y[0], a[0]);
    not (y[1], a[1]);
    not (y[2], a[2]);
    not (y[3], a[3]);

endmodule
