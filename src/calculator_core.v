module calculator_core (
    input  wire [3:0] op1,
    input  wire [3:0] op2,
    input  wire [2:0] operation,
    input  wire       select_previous,
    input  wire       execute,
    output wire [3:0] result
);

    wire [3:0] selected_op2;
    wire [3:0] alu_result;
    wire [3:0] previous_result;

    // Selección del segundo operando:
    // select_previous = 0 -> usa op2 externo
    // select_previous = 1 -> usa resultado anterior
    mux2_4bit op2_selector (
        .a(op2),
        .b(previous_result),
        .sel(select_previous),
        .y(selected_op2)
    );

    // ALU principal
    alu4 alu_unit (
        .a(op1),
        .b(selected_op2),
        .operation(operation),
        .result(alu_result)
    );

    // Registro que almacena el resultado
    register4 result_register (
        .d(alu_result),
        .clk(execute),
        .q(previous_result)
    );

    // Resultado visible
    buf (result[0], previous_result[0]);
    buf (result[1], previous_result[1]);
    buf (result[2], previous_result[2]);
    buf (result[3], previous_result[3]);

endmodule
