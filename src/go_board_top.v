module go_board_top (
    input  wire i_Clk,

    input  wire i_Switch_1,
    input  wire i_Switch_2,
    input  wire i_Switch_3,
    input  wire i_Switch_4,

    output wire o_LED_1,
    output wire o_LED_2,
    output wire o_LED_3,
    output wire o_LED_4,

    output wire o_Segment1_A,
    output wire o_Segment1_B,
    output wire o_Segment1_C,
    output wire o_Segment1_D,
    output wire o_Segment1_E,
    output wire o_Segment1_F,
    output wire o_Segment1_G,

    output wire o_Segment2_A,
    output wire o_Segment2_B,
    output wire o_Segment2_C,
    output wire o_Segment2_D,
    output wire o_Segment2_E,
    output wire o_Segment2_F,
    output wire o_Segment2_G
);

    // -------------------------------------------------
    // Señales de botones con debounce
    // -------------------------------------------------

    wire switch1_debounced;
    wire switch2_debounced;
    wire switch3_debounced;
    wire switch4_debounced;


    // -------------------------------------------------
    // Pulsos de un ciclo
    // -------------------------------------------------

    wire increment_pulse;
    wire decrement_pulse;
    wire confirm_pulse;
    wire previous_pulse;


    // -------------------------------------------------
    // Selector de resultado anterior
    // -------------------------------------------------

    wire previous_selected;
    wire clear_previous;

    wire not_state0;
    wire not_state1;


    // -------------------------------------------------
    // Señales internas de la calculadora
    // -------------------------------------------------

    wire [2:0] leds;
    wire [6:0] sign_seg;
    wire [6:0] value_seg;

    wire [1:0] state;
    wire [3:0] current_value;
    wire [2:0] operation;
    wire [3:0] op1;
    wire [3:0] op2;
    wire [3:0] result;


    // =================================================
    // DEBOUNCE DE LOS CUATRO BOTONES
    // =================================================


    // -------------------------------------------------
    // Switch 1: incrementar
    // -------------------------------------------------

    debounce_button debounce_switch1 (
        .clk(i_Clk),
        .button_in(i_Switch_1),
        .button_out(switch1_debounced)
    );


    // -------------------------------------------------
    // Switch 2: disminuir
    // -------------------------------------------------

    debounce_button debounce_switch2 (
        .clk(i_Clk),
        .button_in(i_Switch_2),
        .button_out(switch2_debounced)
    );


    // -------------------------------------------------
    // Switch 3: confirmar
    // -------------------------------------------------

    debounce_button debounce_switch3 (
        .clk(i_Clk),
        .button_in(i_Switch_3),
        .button_out(switch3_debounced)
    );


    // -------------------------------------------------
    // Switch 4: resultado anterior
    // -------------------------------------------------

    debounce_button debounce_switch4 (
        .clk(i_Clk),
        .button_in(i_Switch_4),
        .button_out(switch4_debounced)
    );


    // =================================================
    // GENERACIÓN DE UN SOLO PULSO POR BOTÓN
    // =================================================


    // -------------------------------------------------
    // Botón 1: incrementar
    // -------------------------------------------------

    button_onepulse button_increment (
        .clk(i_Clk),
        .button_in(switch1_debounced),
        .pulse_out(increment_pulse)
    );


    // -------------------------------------------------
    // Botón 2: disminuir
    // -------------------------------------------------

    button_onepulse button_decrement (
        .clk(i_Clk),
        .button_in(switch2_debounced),
        .pulse_out(decrement_pulse)
    );


    // -------------------------------------------------
    // Botón 3: confirmar
    // -------------------------------------------------

    button_onepulse button_confirm (
        .clk(i_Clk),
        .button_in(switch3_debounced),
        .pulse_out(confirm_pulse)
    );


    // -------------------------------------------------
    // Botón 4: seleccionar resultado anterior
    // -------------------------------------------------

    button_onepulse button_previous (
        .clk(i_Clk),
        .button_in(switch4_debounced),
        .pulse_out(previous_pulse)
    );


    // =================================================
    // DETECTAR ESTADO 00
    //
    // Después de terminar una operación y confirmar
    // desde state = 11, la FSM vuelve a state = 00.
    //
    // Mientras confirm_pulse sigue activo usamos esto
    // para limpiar previous_selected.
    // =================================================

    not (not_state0, state[0]);
    not (not_state1, state[1]);

    and (
        clear_previous,
        confirm_pulse,
        not_state1,
        not_state0
    );


    // =================================================
    // MEMORIZAR SELECCIÓN DE RESULTADO ANTERIOR
    // =================================================

    previous_selector previous_selector_unit (
        .clk(i_Clk),
        .select_pulse(previous_pulse),
        .clear(clear_previous),
        .selected(previous_selected)
    );


    // =================================================
    // CALCULADORA COMPLETA
    // =================================================

    calculator_complete calculator (
        .clk(i_Clk),

        .confirm(confirm_pulse),
        .increment(increment_pulse),
        .decrement(decrement_pulse),

        .select_previous(previous_selected),

        .leds(leds),
        .sign_seg(sign_seg),
        .value_seg(value_seg),

        .state(state),
        .current_value(current_value),
        .operation(operation),
        .op1(op1),
        .op2(op2),
        .result(result)
    );


    // =================================================
    // LEDs
    // =================================================

    buf (o_LED_1, leds[0]);
    buf (o_LED_2, leds[1]);
    buf (o_LED_3, leds[2]);

    // LED 4 indica si está seleccionado
    // el resultado anterior.

    buf (o_LED_4, previous_selected);


    // =================================================
    // DISPLAY 1 = SIGNO
    //
    // Salidas físicas activas en bajo.
    // =================================================

    not (o_Segment1_A, sign_seg[6]);
    not (o_Segment1_B, sign_seg[5]);
    not (o_Segment1_C, sign_seg[4]);
    not (o_Segment1_D, sign_seg[3]);
    not (o_Segment1_E, sign_seg[2]);
    not (o_Segment1_F, sign_seg[1]);
    not (o_Segment1_G, sign_seg[0]);


    // =================================================
    // DISPLAY 2 = VALOR HEXADECIMAL
    //
    // Salidas físicas activas en bajo.
    // =================================================

    not (o_Segment2_A, value_seg[6]);
    not (o_Segment2_B, value_seg[5]);
    not (o_Segment2_C, value_seg[4]);
    not (o_Segment2_D, value_seg[3]);
    not (o_Segment2_E, value_seg[2]);
    not (o_Segment2_F, value_seg[1]);
    not (o_Segment2_G, value_seg[0]);

endmodule