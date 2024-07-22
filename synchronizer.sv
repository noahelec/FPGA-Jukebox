module synchronizer (
    input wire indata,  // Asynchronous input clock
    input wire clk,   // Synchronous clock
    input wire rst,
    output wire outdata // Synchronized pulse output
);

    reg reg1, reg2;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
           reg1 <= 1'b0;
           reg2 <= 1'b0;
        end else begin
            reg1 <= indata;
            reg2 <= reg1;
        end
    end

    assign outdata = reg2;

endmodule
