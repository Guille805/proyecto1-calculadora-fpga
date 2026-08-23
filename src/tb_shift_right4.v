module tb_shift_right4;

    reg  [3:0] a;
    reg  [1:0] shift;

    wire [3:0] result;

    shift_right4 uut (
        .a(a),
        .shift(shift),
        .result(result)
    );

    initial begin

        $monitor("a=%b shift=%b | result=%b",
                 a, shift, result);

        // 1100 desplazado 0 posiciones = 1100
        a = 4'b1100;
        shift = 2'b00;
        #10;

        // 1100 desplazado 1 posición = 0110
        shift = 2'b01;
        #10;

        // 1100 desplazado 2 posiciones = 0011
        shift = 2'b10;
        #10;

        // 1100 desplazado 3 posiciones = 0001
        shift = 2'b11;
        #10;

        $finish;

    end

endmodule