module fetch_flash (
    input clk,
    input start,
    input data_valid,
    input waitrequest,
    input read,
    output reg finish
);

logic [4:0] state;

// State encoding
localparam IDLE = 5'b00000;
localparam CHECK_READ = 5'b00100;
localparam SLAVE_READY = 5'b01000;
localparam WAIT_READ = 5'b01100;
localparam FINISHED = 5'b10001;

always_ff @(posedge clk) begin
    // Default finish signal
    finish <= 0;

    case (state)
        IDLE: begin
            if (start) 
                state <= CHECK_READ;
        end

        CHECK_READ: begin
            if (read) 
                state <= SLAVE_READY;
        end

        SLAVE_READY: begin
            if (!waitrequest) 
                state <= WAIT_READ;
        end

        WAIT_READ: begin
            if (!data_valid) 
                state <= FINISHED;
        end

        FINISHED: begin
            finish <= 1;
            state <= IDLE;
        end

        default: begin
            state <= IDLE;
        end
    endcase
end

endmodule
