module tb_shift_left4;

    reg  [3:0] a;
    reg  [1:0] shift;

    wire [3:0] result;

    shift_left4 uut (
        .a(a),
        .shift(shift),
        .result(result)
    );

    initial begin

        $monitor("a=%b shift=%b | result=%b",
                 a, shift, result);

        // 0011 desplazado 0 posiciones = 0011
        a = 4'b0011;
        shift = 2'b00;
        #10;

        // 0011 desplazado 1 posición = 0110
        shift = 2'b01;
        #10;

        // 0011 desplazado 2 posiciones = 1100
        shift = 2'b10;
        #10;

        // 0011 desplazado 3 posiciones = 1000
        shift = 2'b11;
        #10;

        $finish;

    end

endmodule
