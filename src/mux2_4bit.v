module mux2_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire sel,
    output wire [3:0] y
);

    mux2_1bit mux0 (
        .a(a[0]),
        .b(b[0]),
        .sel(sel),
        .y(y[0])
    );

    mux2_1bit mux1 (
        .a(a[1]),
        .b(b[1]),
        .sel(sel),
        .y(y[1])
    );

    mux2_1bit mux2 (
        .a(a[2]),
        .b(b[2]),
        .sel(sel),
        .y(y[2])
    );

    mux2_1bit mux3 (
        .a(a[3]),
        .b(b[3]),
        .sel(sel),
        .y(y[3])
    );

endmodule
