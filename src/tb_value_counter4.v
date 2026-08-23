module tb_value_counter4;

    reg  [3:0] value;
    reg        increment;
    reg        decrement;

    wire [3:0] next_value;

    value_counter4 uut (
        .value(value),
        .increment(increment),
        .decrement(decrement),
        .next_value(next_value)
    );

    initial begin

        $monitor("value=%b inc=%b dec=%b | next=%b",
                 value, increment, decrement, next_value);

        // Mantener valor
        value = 4'b0011;
        increment = 0;
        decrement = 0;
        #10;

        // 3 + 1 = 4
        increment = 1;
        decrement = 0;
        #10;

        // 3 - 1 = 2
        increment = 0;
        decrement = 1;
        #10;

        // Overflow: 15 + 1 = 0
        value = 4'b1111;
        increment = 1;
        decrement = 0;
        #10;

        // Underflow: 0 - 1 = 15
        value = 4'b0000;
        increment = 0;
        decrement = 1;
        #10;

        $finish;

    end

endmodule
