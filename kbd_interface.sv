`define CHARACTER_B 8'h42  
`define CHARACTER_D 8'h44 
`define CHARACTER_E 8'h45 
`define CHARACTER_F 8'h46 
`define CHARACTER_R 8'h52 

module kbd_interface(
    input logic clk, 
    input logic [7:0] key, 
    input readFinish,
    input dataReady, 
    output logic start_read,
    output logic dir,
    output logic restart
);

    typedef enum logic [5:0] {
        CHECK_KEY =      6'b000000, 
        FORWARD =        6'b001001,
        FORWARD_RESET =  6'b010101,
        FORWARD_PAUSE =  6'b011000,
        BACKWARD =       6'b100011,
        BACKWARD_RESET = 6'b101111,
        BACKWARD_PAUSE = 6'b110000
    } state_t;
    
    state_t state;

    assign restart = state[2]; 
    assign dir = state[1]; 
    assign start_read = state[0]; 

    always_ff @(posedge clk) begin
        case(state)
            CHECK_KEY: begin 
                if (key == `CHARACTER_E) 
                    state <= FORWARD; 
                else if (key == `CHARACTER_B) 
                    state <= BACKWARD_PAUSE; 
                else if (key == `CHARACTER_F) 
                    state <= FORWARD_PAUSE;
                else 
                    state <= CHECK_KEY; 
            end 
            
            FORWARD_RESET: begin 
                if (readFinish) 
                    state <= FORWARD; 
            end 
            
            FORWARD: begin 
                if (key == `CHARACTER_R) begin 
                    if (dataReady) 
                        state <= FORWARD_RESET; 
                end 
                else if (key == `CHARACTER_D)
                    state <= FORWARD_PAUSE;
                else if (key == `CHARACTER_B)
                    state <= BACKWARD;
            end 
                    
            FORWARD_PAUSE: begin 
                if (key == `CHARACTER_R) 
                    state <= FORWARD_RESET; 
                else if (key == `CHARACTER_E)
                    state <= FORWARD;
                else if (key == `CHARACTER_B) 
                    state <= BACKWARD_PAUSE; 
            end 
                
            BACKWARD_RESET: begin
                if (readFinish) 
                    state <= BACKWARD; 
            end 
            
            BACKWARD: begin 
                if (key == `CHARACTER_R) begin 
                    if (dataReady) 
                        state <= BACKWARD_RESET; 
                end 
                else if (key == `CHARACTER_D)
                    state <= BACKWARD_PAUSE;
                else if (key == `CHARACTER_F)
                    state <= FORWARD;
            end 
                
            BACKWARD_PAUSE: begin 
                if (key == `CHARACTER_R) 
                    state <= BACKWARD_RESET; 
                else if (key == `CHARACTER_E)
                    state <= BACKWARD;
                else if (key == `CHARACTER_F) 
                    state <= FORWARD_PAUSE; 
            end 
                
            default: state <= CHECK_KEY; 
        endcase
    end
endmodule
