module freq_div_tb;
    // Testbench signals
    reg clk_27MHz_tb;
    reg reset_tb;
    wire clk_22KHz_tb;

    // Instantiate the frequency divider module
    frequency_divider_22KHz uut (
        .clk_27MHz(clk_27MHz_tb),
        .reset(reset_tb),
        .clk_22KHz(clk_22KHz_tb)
    );

    // Clock generation
    initial begin
        clk_27MHz_tb = 0;
        forever #18.52 clk_27MHz_tb = ~clk_27MHz_tb; // Generate a 27MHz clock (37ns period)
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset_tb = 1;
        #100; // Hold reset for 100ns
        reset_tb = 0;

        // Run the simulation for a sufficient amount of time to observe clk_22KHz
        #1000000; // 1ms simulation time

        $stop; // End the simulation
    end

    // Monitor the signals
    initial begin
        $monitor("Time: %0dns, reset: %b, clk_27MHz: %b, clk_22KHz: %b",
                 $time, reset_tb, clk_27MHz_tb, clk_22KHz_tb);
    end
endmodule
