module input_register4 (
    input  wire       clk,
    input  wire       increment,
    input  wire       decrement,
    output reg  [3:0] value
);

    wire [3:0] next_value;

    // Calcula cuál debería ser el próximo valor
    value_counter4 counter_unit (
        .value(value),
        .increment(increment),
        .decrement(decrement),
        .next_value(next_value)
    );

    // Valor inicial
    initial begin
        value = 4'b0000;
    end

    // Guarda el nuevo valor en cada flanco de reloj
    always @(posedge clk) begin
        value = next_value;
    end

endmodule
