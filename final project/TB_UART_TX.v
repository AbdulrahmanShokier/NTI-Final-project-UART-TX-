`timescale 1ns/1ps

module TB_UART_TX();

    // Inputs
    reg clk;
    reg reset;
    reg vaild_in;
    reg [7:0] tx_data_8bit;
    reg enable_parity;

    // Outputs
    wire TX_out;
    wire busy;

    // Instantiate UART_TX
    UART_TX uut (
        .clk(clk),
        .reset(reset),
        .vaild_in(vaild_in),
        .tx_data_8bit(tx_data_8bit),
        .enable_parity(enable_parity),
        .TX_out(TX_out),
        .busy(busy)
    );

    // Clock: 20ns period
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        // Init
        reset = 1;
        vaild_in = 0;
        tx_data_8bit = 8'b00000000;
        enable_parity = 0;

        // Reset pulse
        #25;
        reset = 0;

        // ==== Test case 1: Normal transmission without parity ====
        tx_data_8bit = 8'b01100010;
        enable_parity = 0;
        vaild_in = 1;
        #20 vaild_in = 0;

        /*
        // Wait for UART to finish
        wait(busy == 1);
        wait(busy == 0);

        // === Idle period ===
        #200;

        // ==== Test case 2: Mid-transmission valid input ====
        tx_data_8bit = 8'b11001100;
        enable_parity = 1;

        // Start transmission
        vaild_in = 1;
        #20 vaild_in = 0;

        // While still transmitting, try to reassert vaild_in again mid-op
        #100; // Mid-operation point
        vaild_in = 1;
        #20 vaild_in = 0;

        // Wait for final transmission to finish
        wait(busy == 1);
        wait(busy == 0);

        */
        #100;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time: %0t | TX_out: %b | busy: %b | vaild_in: %b | data: %b", 
                  $time, TX_out, busy, vaild_in, tx_data_8bit);
    end

endmodule
