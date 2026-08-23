module tb_calculator_system;

    reg clk;
    reg confirm;
    reg increment;
    reg decrement;
    reg select_previous;

    wire [1:0] state;
    wire [3:0] current_value;
    wire [2:0] operation;
    wire [3:0] op1;
    wire [3:0] op2;
    wire [3:0] result;

    calculator_system uut (
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

    initial begin

        $monitor(
            "state=%b current=%b op=%b op1=%b op2=%b prev=%b confirm=%b | result=%b",
            state,
            current_value,
            operation,
            op1,
            op2,
            select_previous,
            confirm,
            result
        );

        clk = 0;
        confirm = 0;
        increment = 0;
        decrement = 0;
        select_previous = 0;


        // =================================================
        // PRIMERA OPERACIÓN
        // 3 + 2 = 5
        // =================================================


        // -------------------------------------------------
        // ESTADO 00
        // operation = 001 (suma)
        // current 0 -> 1
        // -------------------------------------------------

        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 01
        // op1 = 3
        // current 1 -> 3
        // -------------------------------------------------

        #5;
        increment = 1;

        #5; clk = 1;
        #5; clk = 0;

        #5; clk = 1;
        #5; clk = 0;

        increment = 0;

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 10
        // op2 = 2
        // current 3 -> 2
        // -------------------------------------------------

        #5;
        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        decrement = 0;

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 11
        // Esperamos result = 5
        // -------------------------------------------------

        #10;


        // =================================================
        // VOLVER AL ESTADO INICIAL
        // =================================================

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // =================================================
        // SEGUNDA OPERACIÓN
        //
        // 1 + resultado anterior
        // 1 + 5 = 6
        // =================================================


        // -------------------------------------------------
        // ESTADO 00
        // operation sigue siendo 001
        //
        // current actualmente vale 2,
        // bajamos a 1 para seleccionar suma.
        // -------------------------------------------------

        #5;
        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        decrement = 0;

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 01
        // op1 = 1
        //
        // current ya vale 1.
        // -------------------------------------------------

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 10
        //
        // Esta vez NO queremos usar op2 externo.
        // Activamos select_previous = 1.
        //
        // El valor actual de op2 no debería importar.
        // -------------------------------------------------

        select_previous = 1;

        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -------------------------------------------------
        // ESTADO 11
        //
        // Esperamos:
        // 1 + resultado_anterior
        // 1 + 5 = 6
        //
        // result = 0110
        // -------------------------------------------------

        #10;

        $finish;

    end

endmodule