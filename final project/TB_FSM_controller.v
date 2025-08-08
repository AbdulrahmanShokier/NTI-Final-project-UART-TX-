`timescale 1ns/1ps

module TB_FSM_controller;

    // Inputs
    reg clk;
    reg vaild_in;
    reg PISO_finish;
    reg enable_parity;

    // Outputs
    wire [2:0] mux_control;
    wire busy;
    wire serial_enable;
    wire parity_calc_reset;

    // Instantiate the DUT
    FSM_controller dut (
        .vaild_in(vaild_in),
        .clk(clk),
        .PISO_finish(PISO_finish),
        .enable_parity(enable_parity),
        .mux_control(mux_control),
        .busy(busy),
        .serial_enable(serial_enable),
        .parity_calc_reset(parity_calc_reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Stimulus
    initial begin
        // Initial values
        vaild_in = 0;
        PISO_finish = 0;
        enable_parity = 0;

        // Wait for a few cycles
        #20;

        // -- Test 1: Transmission without parity --
        enable_parity = 0;
        vaild_in = 1;         // Request transmission
        #10;                  // One clock cycle
        vaild_in = 0;         // Drop request

        #30;                  // Let it stay in PISO

        PISO_finish = 1;      // Simulate PISO is done
        #10;
        PISO_finish = 0;

        #40;                  // Wait for FSM to return to IDLE

        // -- Test 2: Transmission with parity -
        enable_parity = 1;
        vaild_in = 1;
        #10;
        vaild_in = 0;

        #30;

        PISO_finish = 1;
        #10;
        PISO_finish = 0;

        #50; // wait for FSM to complete

        // Finish simulation
        $finish;
    end

    // Monitor all signals
    initial begin
        $display("Time\tclk\tvalid_in\tPISO_finish\ten_parity\tmux\tbusy\tserial_en\tparity_reset");
        $monitor("%0dns\t%b\t%b\t\t%b\t\t%b\t\t%03b\t%b\t%b\t\t%b",
                 $time, clk, vaild_in, PISO_finish, enable_parity,
                 mux_control, busy, serial_enable, parity_calc_reset);
    end

endmodule