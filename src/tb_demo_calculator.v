module tb_demo_calculator;

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


    // =================================================
    // ARCHIVO PARA GTKWAVE
    // =================================================

    initial begin
        $dumpfile("demo_calculator.vcd");
        $dumpvars(0, tb_demo_calculator);
    end


    // =================================================
    // MONITOR
    // =================================================

    initial begin
        $monitor(
            "state=%b current=%b op=%b op1=%b op2=%b previous=%b confirm=%b | result=%b",
            state,
            current_value,
            operation,
            op1,
            op2,
            select_previous,
            confirm,
            result
        );
    end


    // =================================================
    // PULSO DE INCREMENTO
    // =================================================

    task pulse_increment;
    begin

        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;

        increment = 0;

        #5;

    end
    endtask


    // =================================================
    // PULSO DE DECREMENTO
    // =================================================

    task pulse_decrement;
    begin

        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;

        decrement = 0;

        #5;

    end
    endtask


    // =================================================
    // PULSO DE CONFIRMACION
    // =================================================

    task pulse_confirm;
    begin

        confirm = 1;
        #10;

        confirm = 0;
        #10;

    end
    endtask


    // =================================================
    // SUBIR HASTA UN VALOR
    //
    // Este bloque asume que conocemos el valor actual.
    // Para la demo usaremos increment/decrement según
    // corresponda.
    // =================================================

    task increment_n;
        input integer n;
        integer i;

        begin

            for (i = 0; i < n; i = i + 1) begin
                pulse_increment;
            end

        end
    endtask


    task decrement_n;
        input integer n;
        integer i;

        begin

            for (i = 0; i < n; i = i + 1) begin
                pulse_decrement;
            end

        end
    endtask


    // =================================================
    // PRUEBA PRINCIPAL
    // =================================================

    initial begin

        clk = 0;
        confirm = 0;
        increment = 0;
        decrement = 0;
        select_previous = 0;

        #10;


        // =================================================
        // CAMBIAR SOLO ESTA ZONA PARA LA DEMO
        //
        // EJEMPLO:
        // 3 - 5 = -2
        //
        // operation = 010
        // op1 = 3
        // op2 = 5
        // =================================================


        // -------------------------------------------------
        // OPERACION = 010
        // current comienza en 0
        // subir 2 veces
        // -------------------------------------------------

        increment_n(2);

        pulse_confirm;


        // -------------------------------------------------
        // OP1 = 3
        //
        // current vale 2
        // subir 1
        // -------------------------------------------------

        increment_n(1);

        pulse_confirm;


        // -------------------------------------------------
        // OP2 = 5
        //
        // current vale 3
        // subir 2
        // -------------------------------------------------

        increment_n(2);

        pulse_confirm;


        // -------------------------------------------------
        // RESULTADO
        //
        // Esperamos:
        //
        // 3 - 5 = -2
        // result = 1110
        // -------------------------------------------------

        #30;


        $display("--------------------------------");
        $display("RESULTADO FINAL");
        $display("operation = %b", operation);
        $display("op1       = %b", op1);
        $display("op2       = %b", op2);
        $display("result     = %b", result);
        $display("--------------------------------");


        #20;

        $finish;

    end

endmodule
