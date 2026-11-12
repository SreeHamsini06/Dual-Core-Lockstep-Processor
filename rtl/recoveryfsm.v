

module recovery_fsm (     
input  wire       clk,     
input  wire       reset,     
input  wire       mismatch,     
output wire       recovery_reset,    
 output wire       compare_enable,     
 output wire       recovery_active,     
 output reg        error_flag,     
 output reg [7:0]  recovery_count,     
 output wire [1:0] state_debug );
    localparam [1:0] RUN = 2'd0,                     
     DETECTED = 2'd1,
     RESET_CORES = 2'd2,                      
     RESUME = 2'd3;     
     reg [1:0] state;
    assign recovery_reset = (state == RESET_CORES);     
    assign compare_enable = (state == RUN) && !reset;    
     assign recovery_active = (state != RUN);     
     assign state_debug = state;
    always @(posedge clk or posedge reset) begin        
     if (reset) begin            
      state          <= RUN;            
       error_flag     <= 1'b0;             
       recovery_count <= 8'd0;         
       end else begin             
       case (state)                
        RUN: begin                    
         if (mismatch) begin
                        error_flag <= 1'b1;   // sticky; clear by external reset                         
                        state      <= DETECTED;                     
                        end                
                   end                 
                   DETECTED: begin                    
                    state <= RESET_CORES;                 
                    end                
                     RESET_CORES: begin
                    recovery_count <= recovery_count + 8'd1;                     
                    state          <= RESUME;                 
                    end                 
                    RESUME: begin                     
                    state <= RUN;                
                     end
                default: state <= RUN;             
                endcase         
                end     
                end endmodule


    


