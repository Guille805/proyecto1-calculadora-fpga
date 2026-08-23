module debounce_button (
    input  wire clk,
    input  wire button_in,
    output wire button_out
);

    reg button_sync_0;
    reg button_sync_1;

    reg debounced_state;
    reg [17:0] counter;

    wire [17:0] incremented_counter;
    wire [17:0] next_counter;
    wire [17:0] carry;

    wire mismatch;
    wire counter_full;
    wire update_state;
    wire next_debounced_state;


    // =================================================
    // VALORES INICIALES
    // =================================================

    initial begin
        button_sync_0 = 1'b0;
        button_sync_1 = 1'b0;
        debounced_state = 1'b0;
        counter = 18'b000000000000000000;
    end


    // =================================================
    // DETECTAR CAMBIO EN EL BOTÓN
    // =================================================

    xor (
        mismatch,
        button_sync_1,
        debounced_state
    );


    // =================================================
    // INCREMENTADOR DE 18 BITS
    // =================================================

    full_adder fa0 (
        .a(counter[0]),
        .b(1'b0),
        .cin(1'b1),
        .sum(incremented_counter[0]),
        .cout(carry[0])
    );

    full_adder fa1 (
        .a(counter[1]),
        .b(1'b0),
        .cin(carry[0]),
        .sum(incremented_counter[1]),
        .cout(carry[1])
    );

    full_adder fa2 (
        .a(counter[2]),
        .b(1'b0),
        .cin(carry[1]),
        .sum(incremented_counter[2]),
        .cout(carry[2])
    );

    full_adder fa3 (
        .a(counter[3]),
        .b(1'b0),
        .cin(carry[2]),
        .sum(incremented_counter[3]),
        .cout(carry[3])
    );

    full_adder fa4 (
        .a(counter[4]),
        .b(1'b0),
        .cin(carry[3]),
        .sum(incremented_counter[4]),
        .cout(carry[4])
    );

    full_adder fa5 (
        .a(counter[5]),
        .b(1'b0),
        .cin(carry[4]),
        .sum(incremented_counter[5]),
        .cout(carry[5])
    );

    full_adder fa6 (
        .a(counter[6]),
        .b(1'b0),
        .cin(carry[5]),
        .sum(incremented_counter[6]),
        .cout(carry[6])
    );

    full_adder fa7 (
        .a(counter[7]),
        .b(1'b0),
        .cin(carry[6]),
        .sum(incremented_counter[7]),
        .cout(carry[7])
    );

    full_adder fa8 (
        .a(counter[8]),
        .b(1'b0),
        .cin(carry[7]),
        .sum(incremented_counter[8]),
        .cout(carry[8])
    );

    full_adder fa9 (
        .a(counter[9]),
        .b(1'b0),
        .cin(carry[8]),
        .sum(incremented_counter[9]),
        .cout(carry[9])
    );

    full_adder fa10 (
        .a(counter[10]),
        .b(1'b0),
        .cin(carry[9]),
        .sum(incremented_counter[10]),
        .cout(carry[10])
    );

    full_adder fa11 (
        .a(counter[11]),
        .b(1'b0),
        .cin(carry[10]),
        .sum(incremented_counter[11]),
        .cout(carry[11])
    );

    full_adder fa12 (
        .a(counter[12]),
        .b(1'b0),
        .cin(carry[11]),
        .sum(incremented_counter[12]),
        .cout(carry[12])
    );

    full_adder fa13 (
        .a(counter[13]),
        .b(1'b0),
        .cin(carry[12]),
        .sum(incremented_counter[13]),
        .cout(carry[13])
    );

    full_adder fa14 (
        .a(counter[14]),
        .b(1'b0),
        .cin(carry[13]),
        .sum(incremented_counter[14]),
        .cout(carry[14])
    );

    full_adder fa15 (
        .a(counter[15]),
        .b(1'b0),
        .cin(carry[14]),
        .sum(incremented_counter[15]),
        .cout(carry[15])
    );

    full_adder fa16 (
        .a(counter[16]),
        .b(1'b0),
        .cin(carry[15]),
        .sum(incremented_counter[16]),
        .cout(carry[16])
    );

    full_adder fa17 (
        .a(counter[17]),
        .b(1'b0),
        .cin(carry[16]),
        .sum(incremented_counter[17]),
        .cout(carry[17])
    );


    // =================================================
    // CONTADOR
    // =================================================

    and (next_counter[0],  incremented_counter[0],  mismatch);
    and (next_counter[1],  incremented_counter[1],  mismatch);
    and (next_counter[2],  incremented_counter[2],  mismatch);
    and (next_counter[3],  incremented_counter[3],  mismatch);
    and (next_counter[4],  incremented_counter[4],  mismatch);
    and (next_counter[5],  incremented_counter[5],  mismatch);
    and (next_counter[6],  incremented_counter[6],  mismatch);
    and (next_counter[7],  incremented_counter[7],  mismatch);
    and (next_counter[8],  incremented_counter[8],  mismatch);
    and (next_counter[9],  incremented_counter[9],  mismatch);
    and (next_counter[10], incremented_counter[10], mismatch);
    and (next_counter[11], incremented_counter[11], mismatch);
    and (next_counter[12], incremented_counter[12], mismatch);
    and (next_counter[13], incremented_counter[13], mismatch);
    and (next_counter[14], incremented_counter[14], mismatch);
    and (next_counter[15], incremented_counter[15], mismatch);
    and (next_counter[16], incremented_counter[16], mismatch);
    and (next_counter[17], incremented_counter[17], mismatch);


    // =================================================
    // DETECTAR TIEMPO DE ESTABILIDAD
    // =================================================

    and (
        counter_full,
        counter[0],
        counter[1],
        counter[2],
        counter[3],
        counter[4],
        counter[5],
        counter[6],
        counter[7],
        counter[8],
        counter[9],
        counter[10],
        counter[11],
        counter[12],
        counter[13],
        counter[14],
        counter[15],
        counter[16],
        counter[17]
    );

    and (
        update_state,
        counter_full,
        mismatch
    );


    // =================================================
    // NUEVO ESTADO DEL BOTÓN
    // =================================================

    mux2_1bit state_selector (
        .a(debounced_state),
        .b(button_sync_1),
        .sel(update_state),
        .y(next_debounced_state)
    );


    // =================================================
    // REGISTROS
    //
    // El orden de las asignaciones es importante
    // al utilizar asignaciones bloqueantes.
    // =================================================

    always @(posedge clk) begin

        button_sync_1 = button_sync_0;
        button_sync_0 = button_in;

        counter = next_counter;
        debounced_state = next_debounced_state;

    end


    // =================================================
    // SALIDA
    // =================================================

    buf (
        button_out,
        debounced_state
    );

endmodule