module calculator_display (
    input  wire [3:0] value,
    output wire [6:0] sign_seg,
    output wire [6:0] value_seg
);

    wire sign;
    wire [3:0] magnitude_value;

    // -------------------------------------------------
    // Bit de signo
    // -------------------------------------------------

    buf (sign, value[3]);


    // -------------------------------------------------
    // Obtener magnitud del número
    //
    // Ejemplo:
    // value = 1110 (-2)
    // magnitude_value = 0010 (2)
    // -------------------------------------------------

    magnitude4 magnitude_unit (
        .value(value),
        .magnitude(magnitude_value)
    );


    // -------------------------------------------------
    // Display izquierdo: signo
    // -------------------------------------------------

    sign_to_7seg sign_display (
        .sign(sign),
        .seg(sign_seg)
    );


    // -------------------------------------------------
    // Display derecho: magnitud hexadecimal
    // -------------------------------------------------

    hex_to_7seg value_display (
        .hex(magnitude_value),
        .seg(value_seg)
    );

endmodule
