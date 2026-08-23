module register4 (
    input  wire [3:0] d,
    input  wire clk,
    output reg  [3:0] q
);

    always @(posedge clk) begin
        q = d;
    end

endmodule
