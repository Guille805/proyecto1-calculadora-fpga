`timescale 1ns/1ps

module tb_go_board_top;

    reg i_Clk;

    reg i_Switch_1;
    reg i_Switch_2;
    reg i_Switch_3;
    reg i_Switch_4;

    wire o_LED_1;
    wire o_LED_2;
    wire o_LED_3;
    wire o_LED_4;

    wire o_Segment1_A;
    wire o_Segment1_B;
    wire o_Segment1_C;
    wire o_Segment1_D;
    wire o_Segment1_E;
    wire o_Segment1_F;
    wire o_Segment1_G;

    wire o_Segment2_A;
    wire o_Segment2_B;
    wire o_Segment2_C;
    wire o_Segment2_D;
    wire o_Segment2_E;
    wire o_Segment2_F;
    wire o_Segment2_G;


    // =================================================
    // DUT
    // =================================================

    go_board_top uut (
        .i_Clk(i_Clk),

        .i_Switch_1(i_Switch_1),
        .i_Switch_2(i_Switch_2),
        .i_Switch_3(i_Switch_3),
        .i_Switch_4(i_Switch_4),

        .o_LED_1(o_LED_1),
        .o_LED_2(o_LED_2),
        .o_LED_3(o_LED_3),
        .o_LED_4(o_LED_4),

        .o_Segment1_A(o_Segment1_A),
        .o_Segment1_B(o_Segment1_B),
        .o_Segment1_C(o_Segment1_C),
        .o_Segment1_D(o_Segment1_D),
        .o_Segment1_E(o_Segment1_E),
        .o_Segment1_F(o_Segment1_F),
        .o_Segment1_G(o_Segment1_G),

        .o_Segment2_A(o_Segment2_A),
        .o_Segment2_B(o_Segment2_B),
        .o_Segment2_C(o_Segment2_C),
        .o_Segment2_D(o_Segment2_D),
        .o_Segment2_E(o_Segment2_E),
        .o_Segment2_F(o_Segment2_F),
        .o_Segment2_G(o_Segment2_G)
    );


    // =================================================
    // RELOJ 25 MHz
    // Periodo = 40 ns
    // =================================================

    initial begin
        i_Clk = 1'b0;

        forever begin
            #20;
            i_Clk = ~i_Clk;
        end
    end


    // =================================================
    // TAREAS PARA LOS BOTONES
    //
    // Cada pulsación dura 12 ms.
    // El debounce necesita aproximadamente 10.5 ms.
    // =================================================

    task press_increment;
    begin
        i_Switch_1 = 1'b1;
        #12000000;

        i_Switch_1 = 1'b0;
        #12000000;
    end
    endtask


    task press_decrement;
    begin
        i_Switch_2 = 1'b1;
        #12000000;

        i_Switch_2 = 1'b0;
        #12000000;
    end
    endtask


    task press_confirm;
    begin
        i_Switch_3 = 1'b1;
        #12000000;

        i_Switch_3 = 1'b0;
        #12000000;
    end
    endtask


    task press_previous;
    begin
        i_Switch_4 = 1'b1;
        #12000000;

        i_Switch_4 = 1'b0;
        #12000000;
    end
    endtask


    // =================================================
    // MONITOR
    // =================================================

    initial begin

        $monitor(
            "time=%0t | SW=%b%b%b%b | LED=%b%b%b%b | SEG1=%b%b%b%b%b%b%b | SEG2=%b%b%b%b%b%b%b",
            $time,

            i_Switch_4,
            i_Switch_3,
            i_Switch_2,
            i_Switch_1,

            o_LED_4,
            o_LED_3,
            o_LED_2,
            o_LED_1,

            o_Segment1_A,
            o_Segment1_B,
            o_Segment1_C,
            o_Segment1_D,
            o_Segment1_E,
            o_Segment1_F,
            o_Segment1_G,

            o_Segment2_A,
            o_Segment2_B,
            o_Segment2_C,
            o_Segment2_D,
            o_Segment2_E,
            o_Segment2_F,
            o_Segment2_G
        );

    end


    // =================================================
    // PRUEBA COMPLETA
    //
    // Operación:
    // 010 = A - B
    //
    // A = 3
    // B = 5
    //
    // Resultado esperado:
    // 3 - 5 = -2
    //
    // Complemento a dos:
    // result = 1110
    //
    // Display físico esperado:
    // Display 1 = signo "-"
    // Display 2 = 2
    // =================================================

    initial begin

        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b0;
        i_Switch_4 = 1'b0;

        // Esperar estabilización inicial
        #12000000;


        // =================================================
        // PASO 1
        // Seleccionar operación 010
        //
        // current_value comienza en 0000
        //
        // Incrementamos dos veces:
        // 0000 -> 0001 -> 0010
        // =================================================

        press_increment;
        press_increment;

        $display("");
        $display("OPERACION SELECCIONADA");
        $display("LED esperado = 0010");
        $display("");

        press_confirm;


        // =================================================
        // PASO 2
        // Seleccionar op1 = 3
        //
        // current_value quedó en 2.
        // Incrementamos una vez:
        //
        // 2 -> 3
        // =================================================

        press_increment;

        $display("");
        $display("OP1 SELECCIONADO = 3");
        $display("");

        press_confirm;


        // =================================================
        // PASO 3
        // Seleccionar op2 = 5
        //
        // current_value quedó en 3.
        // Incrementamos dos veces:
        //
        // 3 -> 4 -> 5
        // =================================================

        press_increment;
        press_increment;

        $display("");
        $display("OP2 SELECCIONADO = 5");
        $display("");

        press_confirm;


        // =================================================
        // RESULTADO
        //
        // Esperado:
        // 3 - 5 = -2
        //
        // Display 1 = "-"
        // Display 2 = "2"
        // =================================================

        #12000000;

        $display("");
        $display("====================================");
        $display("RESULTADO FINAL ESPERADO: -2");
        $display("SEG1 debe representar '-'");
        $display("SEG2 debe representar '2'");
        $display("====================================");
        $display("");


        #1000000;

        $finish;

    end

endmodule