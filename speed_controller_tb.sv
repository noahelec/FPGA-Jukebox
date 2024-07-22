`timescale 1ns / 1ps

module speed_controller_tb;

    // Inputs
    reg speed_up;
    reg speed_down;
    reg speed_rst;
    reg clk;

    // Outputs
    wire [31:0] count_out;

    // Instantiate the speed_controller module
    speed_controller uut (
        .speed_up(speed_up),
        .speed_down(speed_down),
        .speed_rst(speed_rst),
        .clk(clk),
        .count_out(count_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        speed_up = 0;
        speed_down = 0;
        speed_rst = 0;

        // Wait for global reset
        #10;

        // Reset the counter
        speed_rst = 1;
        #10;
        speed_rst = 0;
        #10;
        
        // Increase the counter
        speed_up = 1;
        #10;
        speed_up = 0;
        #10;

        // Decrease the counter
        speed_down = 1;
        #10;
        speed_down = 0;
        #10;

        // Increase the counter again
        speed_up = 1;
        #10;
        speed_up = 0;
        #10;

        // Reset the counter again
        speed_rst = 1;
        #10;
        speed_rst = 0;
        #10;

        // Finish simulation
        $stop;
    end

endmodule
