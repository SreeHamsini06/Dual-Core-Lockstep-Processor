`timescale 1ns / 1ps 
module dual_core_lockstep_tb;     
reg clk = 1'b0;     
reg reset = 1'b1;     
reg fault_enable = 1'b0;    
 reg [4:0] fault_bit = 5'd3;
    wire mismatch, error_flag, recovery_active;     
    wire [7:0] recovery_count;     
    wire [1:0] state_debug;
    wire [31:0] pc1, pc2, alu1, alu2_observed;
    always #5 clk = ~clk;
    dual_core_lockstep_top dut (         .clk(clk), .reset(reset),
        .fault_enable(fault_enable), .fault_bit(fault_bit),
        .mismatch(mismatch), .error_flag(error_flag),
        .recovery_active(recovery_active),         
        .recovery_count(recovery_count), .state_debug(state_debug),
        .pc1(pc1), .pc2(pc2), .alu1(alu1),         
        .alu2_observed(alu2_observed)     
        );
    initial begin        
     #20 reset = 1'b0;        
      // Run matching instructions before introducing one fault.
        #60;         
        @(negedge clk);        
         fault_enable = 1'b1;         
         @(negedge clk);        
          fault_enable = 1'b0;        
           #140;        
            $finish;    
             end
    always @(posedge clk) begin         
    #1;        
     $display("t=%0t PC1=%h PC2=%h ALU1=%h ALU2=%h mismatch=%b FSM=%d recovery=%b error=%b count=%0d",            
      $time, pc1, pc2, alu1, alu2_observed, mismatch,             state_debug, recovery_active, error_flag, recovery_count);     
      end 
      endmodule

