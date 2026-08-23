module tb_alu4;

    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] operation;

    wire [3:0] result;

    alu4 uut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result)
    );

    initial begin

        $monitor("op=%b a=%b b=%b | result=%b",
                 operation, a, b, result);

        // 000: reinicio
        a = 4'b0101;
        b = 4'b0011;
        operation = 3'b000;
        #10;

        // 001: suma -> 5 + 3 = 8
        operation = 3'b001;
        #10;

        // 010: resta -> 5 - 3 = 2
        operation = 3'b010;
        #10;

        // 011: resta inversa -> 3 - 5 = -2 = 1110
        operation = 3'b011;
        #10;

        // 100: shift left
        // A = 0101, B[1:0] = 11 -> shift 3
        // 0101 << 3 = 1000
        operation = 3'b100;
        #10;

        // 101: shift right
        // 0101 >> 3 = 0000
        operation = 3'b101;
        #10;

        $finish;

    end

endmodule