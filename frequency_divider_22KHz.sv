module frequency_divider_22KHz (
    input wire clk_27MHz,     // 27MHz input clock
    input wire reset,         // Reset signal
    input wire clk_div,
    output reg clk_22khz      // 22KHz output clock
);

    reg [11:0] counter;       // 12-bit counter to divide 27MHz clock

    always @(posedge clk_27MHz or posedge reset) begin
        if (reset) begin
            counter <= 12'd0;
            clk_22khz <= 1'b0;
        end else begin
            if (counter >= 12'd1227) begin
                counter <= 12'd0;
                clk_22khz <= ~clk_22khz; // Toggle the clock
            end else begin
                counter <= counter + 12'd1;
            end
        end
    end
endmodule
