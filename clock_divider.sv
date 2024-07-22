module clock_divider(inclk, outclk, rst, counto); 
	input inclk;  
	input rst;
	output reg outclk = 0; 
	input [31:0] counto; 
	reg[31:0] count;
	
	always@(posedge inclk) begin 
		if (rst) begin
			count = 0;
			outclk = 0;
		end 
		else begin
			if (count <counto) begin 
				count = count + 1; 
			end 
			else begin 
				outclk = ~outclk; 
				count = 0; 
			end 
		end
	end 

endmodule 