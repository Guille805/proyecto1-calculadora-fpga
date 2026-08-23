module tb_previous_selector;

    reg clk;
    reg select_pulse;
    reg clear;

    wire selected;

    previous_selector uut (
        .clk(clk),
        .select_pulse(select_pulse),
        .clear(clear),
        .selected(selected)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $monitor(
            "clk=%b select=%b clear=%b | selected=%b",
            clk,
            select_pulse,
            clear,
            selected
        );

        select_pulse = 0;
        clear = 0;

        #20;

        // Activar uso de resultado anterior
        select_pulse = 1;
        #10;
        select_pulse = 0;

        // Debe mantenerse seleccionado
        #30;

        // Limpiar selección
        clear = 1;
        #10;
        clear = 0;

        #20;

        $finish;

    end

endmodule
