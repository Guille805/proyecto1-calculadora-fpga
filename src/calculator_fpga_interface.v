module calculator_fpga_interface (
    input  wire [1:0] state,
    input  wire [3:0] current_value,
    input  wire [3:0] result,
    input  wire [2:0] operation,

    output wire [2:0] leds,
    output wire [6:0] sign_seg,
    output wire [6:0] value_seg
);

    wire not_state0;
    wire not_state1;

    wire state00;
    wire state01;
    wire state10;
    wire state11;

    wire show_current;

    wire [3:0] current_path;
    wire [3:0] result_path;
    wire [3:0] display_value;


    // =================================================
    // DECODIFICACIÓN DE ESTADOS
    // =================================================

    not (not_state0, state[0]);
    not (not_state1, state[1]);

    // 00 = selección de operación
    and (state00, not_state1, not_state0);

    // 01 = ingreso de op1
    and (state01, not_state1, state[0]);

    // 10 = ingreso de op2
    and (state10, state[1], not_state0);

    // 11 = mostrar resultado
    and (state11, state[1], state[0]);


    // =================================================
    // LEDs
    //
    // Durante state = 00:
    // muestran los 3 bits inferiores de current_value,
    // porque la operación es de 3 bits.
    //
    // Después de confirmar la operación:
    // muestran operation ya almacenada.
    // =================================================

    mux2_1bit led_mux0 (
        .a(operation[0]),
        .b(current_value[0]),
        .sel(state00),
        .y(leds[0])
    );

    mux2_1bit led_mux1 (
        .a(operation[1]),
        .b(current_value[1]),
        .sel(state00),
        .y(leds[1])
    );

    mux2_1bit led_mux2 (
        .a(operation[2]),
        .b(current_value[2]),
        .sel(state00),
        .y(leds[2])
    );


    // =================================================
    // DISPLAY
    //
    // state = 00:
    // display apagado / valor 0
    //
    // state = 01:
    // mostrar current_value COMPLETO DE 4 BITS
    // mientras se selecciona op1
    //
    // state = 10:
    // mostrar current_value COMPLETO DE 4 BITS
    // mientras se selecciona op2
    //
    // state = 11:
    // mostrar result COMPLETO DE 4 BITS
    // =================================================

    or (
        show_current,
        state01,
        state10
    );


    // -------------------------------------------------
    // BIT 0
    // -------------------------------------------------

    and (
        current_path[0],
        current_value[0],
        show_current
    );

    and (
        result_path[0],
        result[0],
        state11
    );

    or (
        display_value[0],
        current_path[0],
        result_path[0]
    );


    // -------------------------------------------------
    // BIT 1
    // -------------------------------------------------

    and (
        current_path[1],
        current_value[1],
        show_current
    );

    and (
        result_path[1],
        result[1],
        state11
    );

    or (
        display_value[1],
        current_path[1],
        result_path[1]
    );


    // -------------------------------------------------
    // BIT 2
    // -------------------------------------------------

    and (
        current_path[2],
        current_value[2],
        show_current
    );

    and (
        result_path[2],
        result[2],
        state11
    );

    or (
        display_value[2],
        current_path[2],
        result_path[2]
    );


    // -------------------------------------------------
    // BIT 3
    // -------------------------------------------------

    and (
        current_path[3],
        current_value[3],
        show_current
    );

    and (
        result_path[3],
        result[3],
        state11
    );

    or (
        display_value[3],
        current_path[3],
        result_path[3]
    );


    // =================================================
    // CONVERSIÓN A DISPLAYS DE 7 SEGMENTOS
    // =================================================

    calculator_display display_unit (
        .value(display_value),
        .sign_seg(sign_seg),
        .value_seg(value_seg)
    );

endmodule
