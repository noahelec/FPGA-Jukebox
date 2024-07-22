module speed_controller(
    input speed_up,  // Signal to increase the counter
    input speed_down,  // Signal to decrease the counter
    input speed_rst,  // Signal to reset the counter
    input clk,  // Clock signal
    output logic [31:0] count_out  // 32-bit output for the counter value
);
					
    // Temporary counter initialized to 1136 (0x470 in hexadecimal)
    logic [31:0] counter = 1227; 
	
    // Always block triggered on the rising edge of the clock
    always_ff @(posedge clk) begin 
        // Check the combination of control signals
        case ({speed_up, speed_down, speed_rst})
            3'b001: counter <= 1227;  // Reset the counter to 1136
            3'b010: counter <= counter + 32'h0000004;  // Decrease the counter by 16
            3'b100: counter <= counter - 32'h0000004;  // Increase the counter by 16
            default: counter <= counter;  // Maintain the current counter value
        endcase 
    end 
	
    // Assign the temporary counter value to the output
    assign count_out = counter; 
	
endmodule 


