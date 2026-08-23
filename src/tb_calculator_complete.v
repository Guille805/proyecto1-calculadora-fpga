module tb_calculator_complete;

    reg clk;
    reg confirm;
    reg increment;
    reg decrement;
    reg select_previous;

    wire [2:0] leds;
    wire [6:0] sign_seg;
    wire [6:0] value_seg;

    wire [1:0] state;
    wire [3:0] current_value;
    wire [2:0] operation;
    wire [3:0] op1;
    wire [3:0] op2;
    wire [3:0] result;

    calculator_complete uut (
        .clk(clk),
        .confirm(confirm),
        .increment(increment),
        .decrement(decrement),
        .select_previous(select_previous),

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

    initial begin

        $monitor(
            "state=%b current=%b op=%b op1=%b op2=%b result=%b | leds=%b sign=%b value=%b",
            state,
            current_value,
            operation,
            op1,
            op2,
            result,
            leds,
            sign_seg,
            value_seg
        );

        clk = 0;
        confirm = 0;
        increment = 0;
        decrement = 0;
        select_previous = 0;


        // =========================================
        // Operación 010 = resta
        // =========================================

        // current: 0 -> 2
        #5;
        increment = 1;

        #5; clk = 1;
        #5; clk = 0;

        #5; clk = 1;
        #5; clk = 0;

        increment = 0;

        // Confirmar operation = 010
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // =========================================
        // op1 = 3
        // current: 2 -> 3
        // =========================================

        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // Confirmar op1
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // =========================================
        // op2 = 5
        // current: 3 -> 5
        // =========================================

        #5;
        increment = 1;

        #5; clk = 1;
        #5; clk = 0;

        #5; clk = 1;
        #5; clk = 0;

        increment = 0;

        // Confirmar op2
        #5;
        confirm = 1;

        #5;
        confirm = 0;


        // =========================================
        // Resultado esperado:
        // 3 - 5 = -2
        // result = 1110
        //
        // LEDs = 010
        // signo = "-"
        // valor = E
        // =========================================

        #10;

        $finish;

    end

endmodule