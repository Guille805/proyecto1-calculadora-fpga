module selector_operando (
    input wire [3:0] op2,
    input wire [3:0] previous,
    input wire use_previous,
    output wire [3:0] selected
);

    // Señales internas
    wire not_use_previous;
    wire [3:0] op2_enabled;
    wire [3:0] previous_enabled;

    // Invertir la señal de selección
    not g_not(not_use_previous, use_previous);

    // Permitir op2 cuando use_previous vale 0
    and g_op2_0(op2_enabled[0], op2[0], not_use_previous);
    and g_op2_1(op2_enabled[1], op2[1], not_use_previous);
    and g_op2_2(op2_enabled[2], op2[2], not_use_previous);
    and g_op2_3(op2_enabled[3], op2[3], not_use_previous);

    // Permitir previous cuando use_previous vale 1
    and g_previous_0(previous_enabled[0], previous[0], use_previous);
    and g_previous_1(previous_enabled[1], previous[1], use_previous);
    and g_previous_2(previous_enabled[2], previous[2], use_previous);
    and g_previous_3(previous_enabled[3], previous[3], use_previous);

    // Unir ambas posibilidades
    or g_output_0(selected[0], op2_enabled[0], previous_enabled[0]);
    or g_output_1(selected[1], op2_enabled[1], previous_enabled[1]);
    or g_output_2(selected[2], op2_enabled[2], previous_enabled[2]);
    or g_output_3(selected[3], op2_enabled[3], previous_enabled[3]);

endmodule