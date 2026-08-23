module tb_calculator_core;

    reg  [3:0] op1;
    reg  [3:0] op2;
    reg  [2:0] operation;
    reg        select_previous;
    reg        execute;

    wire [3:0] result;

    calculator_core uut (
        .op1(op1),
        .op2(op2),
        .operation(operation),
        .select_previous(select_previous),
        .execute(execute),
        .result(result)
    );

    initial begin
    
        $dumpfile("calculator_core.vcd");
        $dumpvars(0, tb_calculator_core);

        $monitor("op=%b op1=%b op2=%b prev=%b exec=%b | result=%b",
                 operation, op1, op2, select_previous, execute, result);

        execute = 0;

        // ------------------------------------------------
        // Primera operación: 3 + 2 = 5
        // ------------------------------------------------
        op1 = 4'b0011;
        op2 = 4'b0010;
        operation = 3'b001;
        select_previous = 0;

        #10;
        execute = 1;

        #10;
        execute = 0;

        // ------------------------------------------------
        // Segunda operación:
        // 1 + resultado_anterior
        // 1 + 5 = 6
        // ------------------------------------------------
        op1 = 4'b0001;
        op2 = 4'b1111;   // este valor debería ignorarse
        operation = 3'b001;
        select_previous = 1;

        #10;
        execute = 1;

        #10;
        execute = 0;

        // ------------------------------------------------
        // Tercera operación:
        // Reinicio -> resultado = 0000
        // ------------------------------------------------
        operation = 3'b000;
        select_previous = 0;

        #10;
        execute = 1;

        #10;
        execute = 0;

        $finish;

    end

endmodule