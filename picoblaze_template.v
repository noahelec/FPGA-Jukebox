
`default_nettype none
 `define USE_PACOBLAZE
module 
picoblaze_template
#(
parameter clk_freq_in_hz = 25000000
) (
				output reg[7:0] led_volume,
				output reg led_blinker,
            //inout [7:0] lcd_d,
            //output reg lcd_rs,
            //output lcd_rw,
            //output reg lcd_e, 
				input logic interr_sig, 
				input logic clk, 
				input logic [7:0] input_data
			     );


  
//--
//------------------------------------------------------------------------------------
//--
//-- Signals used to connect KCPSM3 to program ROM and I/O logic
//--

wire[9:0]  address;
wire[17:0]  instruction;
wire[7:0]  port_id;
wire[7:0]  out_port;
reg[7:0]  in_port;
wire  write_strobe;
wire  read_strobe;
reg  interrupt;
wire  interrupt_ack;
wire  kcpsm3_reset;

//--
//-- Signals used to generate interrupt 
//--
reg[26:0] int_count;
reg onehertz;

//-- Signals for LCD operation
//--
//--

reg        lcd_rw_control;
reg[7:0]   lcd_output_data;
pacoblaze3 led_8seg_kcpsm
(
                  .address(address),
               .instruction(instruction),
                   .port_id(port_id),
              .write_strobe(write_strobe),
                  .out_port(out_port),
               .read_strobe(read_strobe),
                   .in_port(in_port),
                 .interrupt(interrupt),
             .interrupt_ack(interrupt_ack),
                     .reset(kcpsm3_reset),
                       .clk(clk));

 wire [19:0] raw_instruction;
	
	pacoblaze_instruction_memory 
	pacoblaze_instruction_memory_inst(
     	.addr(address),
	    .outdata(raw_instruction)
	);
	
	always @ (posedge clk)
	begin
	      instruction <= raw_instruction[17:0];
	end

    assign kcpsm3_reset = 0;                       
  
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- Interrupt 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- Interrupt is used to provide a 1 second time reference.
//  --
//  --
//  -- A simple binary counter is used to divide the 50MHz system clock and provide interrupt pulses.
//  --



assign onehertz = interr_sig ? 1'b1 : 1'b0;

always @ (posedge clk or posedge interrupt_ack)  // Flip-flop with clock "clk" and reset "interrupt_ack"
begin
    if (interrupt_ack)  // If reset is activated, clear interrupt to wait for the next clock cycle
        interrupt <= 0;
    else if (onehertz)  // If onehertz is enabled, set interrupt
        interrupt <= 1;
    else
        interrupt <= interrupt;  // Otherwise, maintain the current state of interrupt
end


//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 input ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- The inputs connect via a pipelined multiplexer
//  --

 always @ (posedge clk)
 begin
    case (port_id[7:0])
        8'h0:    in_port <= input_data;
        default: in_port <= 8'bx;
    endcase
end

//
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 output ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  -- adding the output registers to the processor
//  --
//   
  always @ (posedge clk)
  begin

        //LED[9:2] is port 80 hex 
        if (write_strobe & port_id[7])  //clock enable 
          led_volume <= out_port;
       
//      LED[0] is at port 40 hex 
        if (write_strobe & port_id[6])  //clock enable
          led_blinker <= out_port;
		  
      

  end



endmodule