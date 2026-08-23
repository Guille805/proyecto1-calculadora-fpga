module calculator_complete (
    input  wire       clk,
    input  wire       confirm,
    input  wire       increment,
    input  wire       decrement,
    input  wire       select_previous,

    output wire [2:0] leds,
    output wire [6:0] sign_seg,
    output wire [6:0] value_seg,

    output wire [1:0] state,
    output wire [3:0] current_value,
    output wire [2:0] operation,
    output wire [3:0] op1,
    output wire [3:0] op2,
    output wire [3:0] result
);

    // -------------------------------------------------
    // Sistema principal de la calculadora
    // -------------------------------------------------

    calculator_system system_unit (
        .clk(clk),
        .confirm(confirm),
        .increment(increment),
        .decrement(decrement),
        .select_previous(select_previous),

        .state(state),
        .current_value(current_value),
        .operation(operation),
        .op1(op1),
        .op2(op2),
        .result(result)
    );


    // -------------------------------------------------
    // Interfaz visual:
    // LEDs + displays de 7 segmentos
    // -------------------------------------------------

    calculator_fpga_interface interface_unit (
        .state(state),
        .current_value(current_value),
        .result(result),
        .operation(operation),

        .leds(leds),
        .sign_seg(sign_seg),
        .value_seg(value_seg)
    );

endmodule