module calculator_input_control (
    input  wire       clk,
    input  wire       confirm,
    input  wire       increment,
    input  wire       decrement,

    output reg  [2:0] operation,
    output reg  [3:0] op1,
    output reg  [3:0] op2,
    output wire [1:0] state,
    output wire [3:0] current_value
);

    wire [3:0] editable_value;

    wire not_state0;
    wire not_state1;

    wire load_operation;
    wire load_op1;
    wire load_op2;

    wire [2:0] next_operation;
    wire [3:0] next_op1;
    wire [3:0] next_op2;


    // -------------------------------------------------
    // FSM de control
    // -------------------------------------------------

    control_fsm fsm_unit (
        .confirm(confirm),
        .state(state)
    );


    // -------------------------------------------------
    // Valor que el usuario incrementa/disminuye
    // -------------------------------------------------

    input_register4 value_unit (
        .clk(clk),
        .increment(increment),
        .decrement(decrement),
        .value(editable_value)
    );


    // -------------------------------------------------
    // Valor actualmente seleccionado
    // -------------------------------------------------

    buf (current_value[0], editable_value[0]);
    buf (current_value[1], editable_value[1]);
    buf (current_value[2], editable_value[2]);
    buf (current_value[3], editable_value[3]);


    // -------------------------------------------------
    // Decodificación del estado
    // -------------------------------------------------

    not (not_state0, state[0]);
    not (not_state1, state[1]);

    // state = 00 -> guardar operación
    and (load_operation, not_state1, not_state0);

    // state = 01 -> guardar op1
    and (load_op1, not_state1, state[0]);

    // state = 10 -> guardar op2
    and (load_op2, state[1], not_state0);


    // -------------------------------------------------
    // Próximo valor de operation
    // -------------------------------------------------

    mux2_1bit mux_operation0 (
        .a(operation[0]),
        .b(editable_value[0]),
        .sel(load_operation),
        .y(next_operation[0])
    );

    mux2_1bit mux_operation1 (
        .a(operation[1]),
        .b(editable_value[1]),
        .sel(load_operation),
        .y(next_operation[1])
    );

    mux2_1bit mux_operation2 (
        .a(operation[2]),
        .b(editable_value[2]),
        .sel(load_operation),
        .y(next_operation[2])
    );


    // -------------------------------------------------
    // Próximo valor de op1
    // -------------------------------------------------

    mux2_4bit mux_op1 (
        .a(op1),
        .b(editable_value),
        .sel(load_op1),
        .y(next_op1)
    );


    // -------------------------------------------------
    // Próximo valor de op2
    // -------------------------------------------------

    mux2_4bit mux_op2 (
        .a(op2),
        .b(editable_value),
        .sel(load_op2),
        .y(next_op2)
    );


    // -------------------------------------------------
    // Valores iniciales
    // -------------------------------------------------

    initial begin
        operation = 3'b000;
        op1 = 4'b0000;
        op2 = 4'b0000;
    end


    // -------------------------------------------------
    // Guardar datos al confirmar
    // -------------------------------------------------

    always @(posedge confirm) begin
        operation = next_operation;
        op1 = next_op1;
        op2 = next_op2;
    end

endmodule
