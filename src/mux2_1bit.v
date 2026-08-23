module mux2_1bit (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);

    wire nsel;
    wire a_path;
    wire b_path;

    not (nsel, sel);

    and (a_path, a, nsel);
    and (b_path, b, sel);

    or  (y, a_path, b_path);

endmodule
