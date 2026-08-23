module tb_calculator_input_control;

    reg clk;
    reg confirm;
    reg increment;
    reg decrement;

    wire [2:0] operation;
    wire [3:0] op1;
    wire [3:0] op2;
    wire [1:0] state;
    wire [3:0] current_value;

    calculator_input_control uut (
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

    initial begin

        $monitor(
            "state=%b current=%b | operation=%b op1=%b op2=%b",
            state, current_value, operation, op1, op2
        );

        clk = 0;
        confirm = 0;
        increment = 0;
        decrement = 0;

        // -----------------------------------------
        // Estado 00: elegir operación = 001
        // -----------------------------------------

        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // Confirmar operación
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -----------------------------------------
        // Estado 01: elegir op1
        // current_value parte en 1
        // subimos hasta 3
        // -----------------------------------------

        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // Confirmar op1 = 3
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -----------------------------------------
        // Estado 10: elegir op2
        // current_value sigue en 3
        // bajamos a 2
        // -----------------------------------------

        #5;
        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        decrement = 0;

        // Confirmar op2 = 2
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // -----------------------------------------
        // Estado 11: resultado
        // confirmar no debería modificar
        // operation, op1 ni op2
        // -----------------------------------------

        #5;
        confirm = 1;

        #5;
        confirm = 0;

        #10;
        $finish;

    end

endmodule