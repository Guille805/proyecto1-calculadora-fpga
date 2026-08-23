module alu4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] operation,
    output wire [3:0] result
);

    wire [3:0] sum_result;
    wire [3:0] sub_result;
    wire [3:0] reverse_sub_result;
    wire [3:0] shift_left_result;
    wire [3:0] shift_right_result;

    wire sum_cout;
    wire sub_cout;
    wire reverse_sub_cout;

    wire nop0;
    wire nop1;
    wire nop2;

    wire select_sum;
    wire select_sub;
    wire select_reverse_sub;
    wire select_shift_left;
    wire select_shift_right;

    wire [3:0] sum_path;
    wire [3:0] sub_path;
    wire [3:0] reverse_sub_path;
    wire [3:0] shift_left_path;
    wire [3:0] shift_right_path;


    // -------------------------------------------------
    // Operaciones
    // -------------------------------------------------

    adder4 sum_unit (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(sum_result),
        .cout(sum_cout)
    );

    subtractor4 sub_unit (
        .a(a),
        .b(b),
        .result(sub_result),
        .cout(sub_cout)
    );

    reverse_subtractor4 reverse_sub_unit (
        .a(a),
        .b(b),
        .result(reverse_sub_result),
        .cout(reverse_sub_cout)
    );

    shift_left4 shift_left_unit (
        .a(a),
        .shift(b[1:0]),
        .result(shift_left_result)
    );

    shift_right4 shift_right_unit (
        .a(a),
        .shift(b[1:0]),
        .result(shift_right_result)
    );


    // -------------------------------------------------
    // Invertimos los bits del código de operación
    // -------------------------------------------------

    not (nop0, operation[0]);
    not (nop1, operation[1]);
    not (nop2, operation[2]);


    // -------------------------------------------------
    // Decodificación de operación
    // -------------------------------------------------

    // 001 = suma
    and (select_sum,
         nop2,
         nop1,
         operation[0]);

    // 010 = resta
    and (select_sub,
         nop2,
         operation[1],
         nop0);

    // 011 = resta inversa
    and (select_reverse_sub,
         nop2,
         operation[1],
         operation[0]);

    // 100 = shift left
    and (select_shift_left,
         operation[2],
         nop1,
         nop0);

    // 101 = shift right
    and (select_shift_right,
         operation[2],
         nop1,
         operation[0]);


    // -------------------------------------------------
    // Bit 0
    // -------------------------------------------------

    and (sum_path[0], sum_result[0], select_sum);
    and (sub_path[0], sub_result[0], select_sub);
    and (reverse_sub_path[0], reverse_sub_result[0], select_reverse_sub);
    and (shift_left_path[0], shift_left_result[0], select_shift_left);
    and (shift_right_path[0], shift_right_result[0], select_shift_right);

    or (result[0],
        sum_path[0],
        sub_path[0],
        reverse_sub_path[0],
        shift_left_path[0],
        shift_right_path[0]);


    // -------------------------------------------------
    // Bit 1
    // -------------------------------------------------

    and (sum_path[1], sum_result[1], select_sum);
    and (sub_path[1], sub_result[1], select_sub);
    and (reverse_sub_path[1], reverse_sub_result[1], select_reverse_sub);
    and (shift_left_path[1], shift_left_result[1], select_shift_left);
    and (shift_right_path[1], shift_right_result[1], select_shift_right);

    or (result[1],
        sum_path[1],
        sub_path[1],
        reverse_sub_path[1],
        shift_left_path[1],
        shift_right_path[1]);


    // -------------------------------------------------
    // Bit 2
    // -------------------------------------------------

    and (sum_path[2], sum_result[2], select_sum);
    and (sub_path[2], sub_result[2], select_sub);
    and (reverse_sub_path[2], reverse_sub_result[2], select_reverse_sub);
    and (shift_left_path[2], shift_left_result[2], select_shift_left);
    and (shift_right_path[2], shift_right_result[2], select_shift_right);

    or (result[2],
        sum_path[2],
        sub_path[2],
        reverse_sub_path[2],
        shift_left_path[2],
        shift_right_path[2]);


    // -------------------------------------------------
    // Bit 3
    // -------------------------------------------------

    and (sum_path[3], sum_result[3], select_sum);
    and (sub_path[3], sub_result[3], select_sub);
    and (reverse_sub_path[3], reverse_sub_result[3], select_reverse_sub);
    and (shift_left_path[3], shift_left_result[3], select_shift_left);
    and (shift_right_path[3], shift_right_result[3], select_shift_right);

    or (result[3],
        sum_path[3],
        sub_path[3],
        reverse_sub_path[3],
        shift_left_path[3],
        shift_right_path[3]);

endmodule
