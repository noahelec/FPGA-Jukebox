`timescale 1ns / 1ps

`define E 8'h45
`define D 8'h44
`define F 8'h46
`define B 8'h42
`define R 8'h52

module fsmlab2_tb();

    // Inputs
    reg sync_22KHz_pulse;
    reg [31:0] flash_mem_readdata;
    reg [7:0] kbdinput;

    // Outputs
    wire flash_mem_read;
    wire [22:0] flash_mem_address;
    wire [7:0] audio_data;

    // Instantiate the Unit Under Test (UUT)
    fsmlab2 uut (
        .sync_22KHz_pulse(sync_22KHz_pulse),
        .flash_mem_readdata(flash_mem_readdata),
        .kbdinput(kbdinput),
        .flash_mem_read(flash_mem_read),
        .flash_mem_address(flash_mem_address),
        .audio_data(audio_data)
    );

    initial begin
        // Initialize Inputs
        sync_22KHz_pulse = 0;
        flash_mem_readdata = 0;
        kbdinput = 0;

        // Wait for global reset to finish
        #100;
        
        // Test KEYCHECK state with `E` input
        kbdinput = `E;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test FORWARD state
        flash_mem_readdata = 32'hAABBCCDD;
        repeat(2) begin
            #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        end

        // Test transition to FORSTOP with `D` input
        kbdinput = `D;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test FORSTOP state with `E` input
        kbdinput = `E;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test BACKWARD state with `B` input
        kbdinput = `B;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test BACKSTOP state with `D` input
        kbdinput = `D;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test BACKRESET state with `R` input
        kbdinput = `R;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test transition to FORRESET with `F` input
        kbdinput = `F;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test FORRESET state with `R` input
        kbdinput = `R;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test backward data read with `B` input
        flash_mem_readdata = 32'h11223344;
        kbdinput = `B;
        repeat(2) begin
            #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        end
        kbdinput = 0;

        // Test transition to BREADEVEN with `B` input
        kbdinput = `B;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        kbdinput = 0;

        // Test BREADEVEN state
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse

        // Test BUPDATE state
        flash_mem_readdata = 32'h55667788;
        #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse

        // Test FORWARD state again with `E` input
        kbdinput = `E;
        repeat(4) begin
            #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        end
        kbdinput = 0;

        // Test final state with no input
        repeat(2) begin
            #20 sync_22KHz_pulse = 1; #20 sync_22KHz_pulse = 0; // clock pulse
        end

        // Finish the test
        $stop;
    end

    // Generate clock signal for sync_22KHz_pulse
    always begin
        #10 sync_22KHz_pulse = ~sync_22KHz_pulse;
    end

endmodule
