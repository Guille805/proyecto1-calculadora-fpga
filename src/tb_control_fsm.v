module tb_control_fsm;

    reg confirm;
    wire [1:0] state;

    control_fsm uut (
        .confirm(confirm),
        .state(state)
    );

    initial begin

        $monitor("confirm=%b | state=%b",
                 confirm, state);

        confirm = 0;

        #10;
        confirm = 1;

        #10;
        confirm = 0;

        #10;
        confirm = 1;

        #10;
        confirm = 0;

        #10;
        confirm = 1;

        #10;
        confirm = 0;

        #10;
        confirm = 1;

        #10;
        confirm = 0;

        $finish;

    end

endmodule