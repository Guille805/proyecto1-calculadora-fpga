module magnitude4 (
    input  wire [3:0] value,
    output wire [3:0] magnitude
);

    wire [3:0] inverted_value;
    wire [3:0] negative_magnitude;
    wire       unused_cout;


    // -------------------------------------------------
    // Invertir todos los bits
    // -------------------------------------------------

    not4 invert_unit (
        .a(value),
        .y(inverted_value)
    );


    // -------------------------------------------------
    // Obtener complemento a dos
    //
    // Primero se invierten los bits y luego
    // se incrementa el resultado en una unidad.
    //
    // El incremento se realiza mediante adder4.
    // -------------------------------------------------

    adder4 add_one_unit (
        .a(inverted_value),
        .b(4'b0000),
        .cin(1'b1),
        .sum(negative_magnitude),
        .cout(unused_cout)
    );


    // -------------------------------------------------
    // Selección de magnitud
    //
    // value[3] = 0:
    // magnitude = value
    //
    // value[3] = 1:
    // magnitude = complemento a dos de value
    // -------------------------------------------------

    mux2_4bit magnitude_selector (
        .a(value),
        .b(negative_magnitude),
        .sel(value[3]),
        .y(magnitude)
    );

endmodule
