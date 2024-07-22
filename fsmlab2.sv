`define E 8'h45
`define D 8'h44
`define F 8'h46
`define B 8'h42
`define R 8'h52

module fsmlab2 (
    input wire sync_22KHz_pulse,
    input wire [31:0] flash_mem_readdata,
    input logic [7:0] kbdinput,
    output reg flash_mem_read,
    output reg [22:0] flash_mem_address,
    output reg [7:0] audio_data,
    output reg vol_signal
);

    localparam KEYCHECK = 4'b0000;
    localparam READEVEN = 4'b0001;
    localparam READODD = 4'b0010;
    localparam UPDATE = 4'b0011;
    localparam BACKWARD = 4'b0100;
    localparam FORWARD = 4'b0101;
    localparam FORSTOP = 4'b0110;
    localparam BACKSTOP = 4'b0111;
    localparam FORRESET = 4'b1000;
    localparam BACKRESET = 4'b1001;
    localparam BREADEVEN = 4'b1010;
    localparam BREADODD = 4'b1011;
    localparam BUPDATE = 4'b1100;
    localparam SET_FADDRESS = 4'b1101;
    localparam SET_BADDRESS = 4'b1110;
    localparam INTERRUPT = 4'b1111;

    reg [3:0] state;
    reg [22:0] flash_read_address;

    always @(posedge sync_22KHz_pulse) begin
        case (state)
            KEYCHECK: begin 
                case (kbdinput)
                    `E : state <= FORWARD;
                    `B : state <= BACKSTOP;
                    `F : state <= FORSTOP;
                    default : state <= KEYCHECK;
                endcase 
            end 

            FORRESET: begin
                flash_mem_address <= 23'd0;
                state <= SET_FADDRESS; // Move to intermediate state
            end
            SET_FADDRESS: begin
                state <= FORWARD; // Move to forward state
            end

            FORWARD: begin
                if (kbdinput == `D) begin
                    state <= FORSTOP;
                end else if (kbdinput == `B) begin
                    state <= BACKWARD;
                end else if (kbdinput == `R) begin
                    state <= FORRESET;
                end else if (flash_mem_address < 23'h7FFFF) begin
                    flash_mem_read <= 1'b1;
                    flash_mem_address <= flash_read_address;
                    state <= READEVEN;
                end else begin
                    // Reset to loop the song
                    flash_mem_address <= 23'd0;
                    flash_read_address <= 23'b0;
                    flash_mem_read <= 1'b0;
                    state <= FORWARD;
                end
            end


            READEVEN: begin
                flash_mem_read <= 1'b0;
                audio_data <= flash_mem_readdata[15:8];
                vol_signal <= 1'b1;
                state <= READODD;
            end

            READODD: begin
                flash_mem_read <= 1'b0;
                audio_data <= flash_mem_readdata[31:24];
                vol_signal <= 1'b1;
                state <= UPDATE;
            end

            UPDATE: begin
                flash_read_address <= flash_read_address + 23'd4;
                state <= FORWARD;
            end

            BACKWARD: begin
    if (kbdinput == `F) begin
        state <= FORWARD;
    end else if (kbdinput == `D) begin
        state <= BACKSTOP;
    end else if (kbdinput == `R) begin
        state <= BACKRESET;
    end else if (flash_mem_address > 23'h0) begin
        flash_mem_read <= 1'b1;
        flash_mem_address <= flash_read_address;
        state <= BREADODD;
    end else begin
        // Reset to loop the song in reverse
        flash_mem_address <= 23'h7FFFF;
        flash_read_address <= 23'h7FFFF;
        flash_mem_read <= 1'b0;
        state <= BACKWARD;
    end
end


            BACKRESET: begin
                flash_mem_address <= 23'h7FFFF;
                state <= SET_BADDRESS;
            end
            SET_BADDRESS: begin
                state <= BACKWARD; // Move to Backward state
            end

            BREADODD: begin
                flash_mem_read <= 1'b0;
                audio_data <= flash_mem_readdata[31:24];
                vol_signal <= 1'b1;
                state <= BREADEVEN;
            end

            BREADEVEN: begin
                flash_mem_read <= 1'b0;
                audio_data <= flash_mem_readdata[15:8];
                vol_signal <= 1'b1;
                state <= BUPDATE;
            end

            BUPDATE: begin
                flash_read_address <= flash_read_address - 23'd4; // Move backwards
                state <= BACKWARD;
            end

            FORSTOP: begin
                case (kbdinput)
                    `E: state <= FORWARD;
                    `R: state <= FORRESET;
                    `B: state <= BACKSTOP;
                    default : state <= FORSTOP;
                endcase
            end

            BACKSTOP: begin
                case (kbdinput)
                    `R : state <= BACKRESET;
                    `E : state <= BACKWARD;
                    `F : state <= FORSTOP;
                    default: state <= BACKSTOP;
                endcase
            end

            default: state <= KEYCHECK;
        endcase
    end
endmodule
