module tb_previous_integration;

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


    // -------------------------------------------------
    // Reloj
    // -------------------------------------------------

    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk;
    end


    initial begin

        $monitor(
            "SW3=%b SW4=%b | LED4=%b",
            i_Switch_3,
            i_Switch_4,
            o_LED_4
        );

        i_Switch_1 = 0;
        i_Switch_2 = 0;
        i_Switch_3 = 0;
        i_Switch_4 = 0;

        #30;


        // =================================================
        // ACTIVAR RESULTADO ANTERIOR
        // =================================================

        i_Switch_4 = 1;
        #30;

        i_Switch_4 = 0;
        #40;

        // Aquí LED4 debe seguir en 1


        // =================================================
        // CONFIRMACIÓN 1
        // state 00 -> 01
        // =================================================

        i_Switch_3 = 1;
        #30;

        i_Switch_3 = 0;
        #30;


        // =================================================
        // CONFIRMACIÓN 2
        // state 01 -> 10
        // =================================================

        i_Switch_3 = 1;
        #30;

        i_Switch_3 = 0;
        #30;


        // =================================================
        // CONFIRMACIÓN 3
        // state 10 -> 11
        // Ejecuta la operación
        // =================================================

        i_Switch_3 = 1;
        #30;

        i_Switch_3 = 0;
        #40;

        // LED4 todavía debería estar en 1


        // =================================================
        // CONFIRMACIÓN 4
        // state 11 -> 00
        //
        // Aquí previous_selected debe limpiarse
        // y LED4 debe volver a 0
        // =================================================

        i_Switch_3 = 1;
        #30;

        i_Switch_3 = 0;

        #50;

        $finish;

    end

endmodule