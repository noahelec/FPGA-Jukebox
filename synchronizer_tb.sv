module synchronizer_tb;

    // Inputs
    reg indata;
    reg clk;
    reg rst;

    // Outputs
    wire outdata;

    // Instantiate the Unit Under Test (UUT)
    synchronizer uut (
        .indata(indata), 
        .clk(clk), 
        .rst(rst), 
        .outdata(outdata)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    initial begin
        // Initialize Inputs
        indata = 0;
        clk = 0;
        rst = 0;

        // Apply reset
        #10 rst = 1; // De-assert reset after 10 time units
        #10 rst = 0; // Assert reset
        #10 rst = 1; // De-assert reset

        // Apply test cases
        #10 indata = 1; // Set indata high
        #20 indata = 0; // Set indata low
        #30 indata = 1; // Set indata high
        #40 indata = 0; // Set indata low
        #50 indata = 1; // Set indata high
        #60 indata = 0; // Set indata low

        // Finish the simulation
        #100 $stop;
    end

endmodule
