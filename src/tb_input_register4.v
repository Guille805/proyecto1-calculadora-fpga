module tb_input_register4;

    reg clk;
    reg increment;
    reg decrement;

    wire [3:0] value;

    input_register4 uut (
        .clk(clk),
        .increment(increment),
        .decrement(decrement),
        .value(value)
    );

    initial begin

        $monitor("clk=%b inc=%b dec=%b | value=%b",
                 clk, increment, decrement, value);

        clk = 0;
        increment = 0;
        decrement = 0;

        // 0 -> 1
        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // 1 -> 2
        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // 2 -> 3
        #5;
        increment = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        increment = 0;

        // 3 -> 2
        #5;
        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        decrement = 0;

        // 2 -> 1
        #5;
        decrement = 1;

        #5;
        clk = 1;

        #5;
        clk = 0;
        decrement = 0;

        #5;
        $finish;

    end

endmodule
