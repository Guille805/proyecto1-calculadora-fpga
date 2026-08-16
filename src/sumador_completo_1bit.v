module sumador_completo_1bit (
    input wire a,
    input wire b,
    input wire carry_in,
    output wire sum,
    output wire carry_out
);

    // Señales internas
    wire xor_ab;
    wire carry_ab;
    wire carry_input;

    // Suma: a XOR b XOR carry_in
    xor g_xor_ab(xor_ab, a, b);
    xor g_sum(sum, xor_ab, carry_in);

    // Acarreo de salida
    and g_carry_ab(carry_ab, a, b);
    and g_carry_input(carry_input, xor_ab, carry_in);
    or g_carry_out(carry_out, carry_ab, carry_input);

endmodule