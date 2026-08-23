module previous_selector (
    input  wire clk,
    input  wire select_pulse,
    input  wire clear,
    output reg  selected
);

    wire not_clear;
    wire keep_selected;
    wire set_selected;
    wire next_selected;

    initial begin
        selected = 1'b0;
    end

    not (not_clear, clear);

    and (
        keep_selected,
        selected,
        not_clear
    );

    and (
        set_selected,
        select_pulse,
        not_clear
    );

    or (
        next_selected,
        keep_selected,
        set_selected
    );

    always @(posedge clk) begin
        selected = next_selected;
    end

endmodule