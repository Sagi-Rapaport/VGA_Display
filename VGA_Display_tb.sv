`timescale 1ns/1ps

module VGA_Display_tb;
    
    // Testbench-controlled inputs to DUT
    logic clk = 0;
    logic reset = 0;

    // Output from DUT
    logic H_sync;
    logic V_sync;
    logic [3:0] Red;
    logic [3:0] Green;
    logic [3:0] Blue;

    // Clock generation (50 MHz clock = 20ns period)
    always #10 clk = ~clk;

// Instantiate the DUT
VGA_top DUT (
    // Inputs
    .clk(clk),
    .reset(reset),
    // Outputs
    .H_sync(H_sync),
    .V_sync(V_sync),
    .Red(Red),
    .Green(Green),
    .Blue(Blue)
);

    // Stimulus block
    initial begin
        // Initial reset
        #80;
        reset = 1;
        #80;
        reset = 0;
        #1684000;

        $stop;
        
    end
    
endmodule