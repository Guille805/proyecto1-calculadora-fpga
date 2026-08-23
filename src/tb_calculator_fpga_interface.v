module tb_calculator_fpga_interface;

    reg  [1:0] state;
    reg  [3:0] op1;
    reg  [3:0] op2;
    reg  [3:0] result;
    reg  [2:0] operation;

    wire [2:0] leds;
    wire [6:0] sign_seg;
    wire [6:0] value_seg;

    calculator_fpga_interface uut (
        .state(state),
        .op1(op1),
        .op2(op2),
        .result(result),
        .operation(operation),

        .leds(leds),
        .sign_seg(sign_seg),
        .value_seg(value_seg)
    );

    initial begin

        $monitor(
            "state=%b op=%b leds=%b op1=%b op2=%b result=%b | sign=%b value=%b",
            state,
            operation,
            leds,
            op1,
            op2,
            result,
            sign_seg,
            value_seg
        );

        operation = 3'b010;
        op1 = 4'b0011;
        op2 = 4'b0101;
        result = 4'b1110;


        // state 00:
        // LEDs muestran operación
        state = 2'b00;
        #10;


        // state 01:
        // display muestra op1 = 3
        state = 2'b01;
        #10;


        // state 10:
        // display muestra op2 = 5
        state = 2'b10;
        #10;


        // state 11:
        // display muestra result = 1110
        // signo = "-"
        // valor hexadecimal = E
        state = 2'b11;
        #10;


        $finish;

    end

endmodule
