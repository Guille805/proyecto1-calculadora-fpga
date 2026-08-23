module button_onepulse (
    input  wire clk,
    input  wire button_in,
    output wire pulse_out
);

    reg button_sync_0;
    reg button_sync_1;
    reg button_prev;

    wire button_prev_not;
    wire button_rising;

    initial begin
        button_sync_0 = 1'b0;
        button_sync_1 = 1'b0;
        button_prev   = 1'b0;
    end


    // -------------------------------------------------
    // Sincronización y almacenamiento del estado previo
    //
    // El orden es importante al utilizar asignaciones
    // bloqueantes.
    // -------------------------------------------------

    always @(posedge clk) begin

        button_prev   = button_sync_1;
        button_sync_1 = button_sync_0;
        button_sync_0 = button_in;

    end


    // -------------------------------------------------
    // Detección de flanco ascendente
    // -------------------------------------------------

    not (button_prev_not, button_prev);

    and (
        button_rising,
        button_sync_1,
        button_prev_not
    );

    buf (pulse_out, button_rising);

endmodule