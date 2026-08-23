module tb_button_onepulse;

    reg clk;
    reg button_in;

    wire pulse_out;

    button_onepulse uut (
        .clk(clk),
        .button_in(button_in),
        .pulse_out(pulse_out)
    );

    // Reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $monitor(
            "clk=%b button=%b | pulse=%b",
            clk,
            button_in,
            pulse_out
        );

        button_in = 0;

        // Espera inicial
        #20;

        // Presionamos el botón
        button_in = 1;

        // Lo mantenemos presionado un rato
        #40;

        // Lo soltamos
        button_in = 0;

        #30;

        // Segunda pulsación
        button_in = 1;

        #30;

        button_in = 0;

        #30;

        $finish;

    end

endmodule
