`timescale 1ns / 1ps

module tb;

    // Testbench signals
    logic        clk;
    logic        reset;
    logic        start;
    logic [3:0]  predicted_digit;
    logic  done;

    // Instantiate the Top Module
    top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .predicted_digit(predicted_digit),
        .done(done)
    );

    // Generate 100 MHz Clock (10ns period)
    always #5 clk = ~clk;

   // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;

        // Wait for 20ns, then release reset
        #20;
        reset = 0;

        // Wait another 20ns, then pulse start
        #20;
        @(posedge clk);
        start = 1;       // Assert start
        @(posedge clk);
        start = 0;       // Drop start back to 0 after 1 cycle

        // Wait until FSM finishes processing (done goes high)
        @(posedge done);

        // Display final result to the Tcl console
        $display("Calculation Complete!");
        $display("Final Predicted digit (Dec): %0d", predicted_digit);
   
        #50;
        // End simulation
        $finish;
    end
   endmodule
