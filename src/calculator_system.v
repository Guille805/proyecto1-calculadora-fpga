module calculator_system (
    input  wire       clk,
    input  wire       confirm,
    input  wire       increment,
    input  wire       decrement,
    input  wire       select_previous,

    output wire [1:0] state,
    output wire [3:0] current_value,
    output wire [2:0] operation,
    output wire [3:0] op1,
    output wire [3:0] op2,
    output wire [3:0] result
);

    wire not_confirm;
    wire execute;


    // -------------------------------------------------
    // Control de ingreso de datos
    // -------------------------------------------------

    calculator_input_control input_control (
        .clk(clk),
        .confirm(confirm),
        .increment(increment),
        .decrement(decrement),

        .operation(operation),
        .op1(op1),
        .op2(op2),
        .state(state),
        .current_value(current_value)
    );


    // -------------------------------------------------
    // Generación de señal execute
    //
    // Cuando confirmamos op2:
    // state pasa de 10 a 11 y op2 queda guardado.
    //
    // Luego, al soltar el botón confirm:
    // confirm = 0
    // state   = 11
    //
    // execute se activa y la ALU ya puede usar
    // el nuevo valor de op2.
    // -------------------------------------------------

    not (not_confirm, confirm);

    and (
        execute,
        not_confirm,
        state[1],
        state[0]
    );


    // -------------------------------------------------
    // Núcleo de la calculadora
    // -------------------------------------------------

    calculator_core core (
        .op1(op1),
        .op2(op2),
        .operation(operation),
        .select_previous(select_previous),
        .execute(execute),
        .result(result)
    );

endmodule