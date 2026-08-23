module value_counter4 (
    input  wire [3:0] value,
    input  wire       increment,
    input  wire       decrement,
    output wire [3:0] next_value
);

    wire [3:0] incremented_value;
    wire [3:0] decremented_value;

    wire [3:0] after_increment;

    wire inc_cout;
    wire dec_cout;


    // -------------------------------------------------
    // Incrementar value en una unidad
    // -------------------------------------------------

    adder4 increment_unit (
        .a(value),
        .b(4'b0001),
        .cin(1'b0),
        .sum(incremented_value),
        .cout(inc_cout)
    );


    // -------------------------------------------------
    // Disminuir value en una unidad
    // -------------------------------------------------

    subtractor4 decrement_unit (
        .a(value),
        .b(4'b0001),
        .result(decremented_value),
        .cout(dec_cout)
    );


    // -------------------------------------------------
    // Selección de incremento
    //
    // increment = 0: mantiene value
    // increment = 1: utiliza incremented_value
    // -------------------------------------------------

    mux2_4bit increment_selector (
        .a(value),
        .b(incremented_value),
        .sel(increment),
        .y(after_increment)
    );


    // -------------------------------------------------
    // Selección de decremento
    //
    // decrement = 0: mantiene el valor anterior
    // decrement = 1: utiliza decremented_value
    // -------------------------------------------------

    mux2_4bit decrement_selector (
        .a(after_increment),
        .b(decremented_value),
        .sel(decrement),
        .y(next_value)
    );

endmodule