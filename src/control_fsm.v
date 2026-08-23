module control_fsm (
    input  wire confirm,
    output reg  [1:0] state
);

    wire next0;
    wire next1;
    wire not_state0;

    // Estado inicial al encender la FPGA
    initial begin
        state = 2'b00;
    end

    // Próximo estado:
    // 00 -> 01
    // 01 -> 10
    // 10 -> 11
    // 11 -> 00

    not (not_state0, state[0]);

    buf (next0, not_state0);
    xor (next1, state[1], state[0]);

    // El botón de confirmar hace avanzar la FSM
    always @(posedge confirm) begin
        state[0] = next0;
        state[1] = next1;
    end

endmodule
