
module riscv_core2(     
input  wire        clk,     
input  wire        reset,     
input  wire        fault_enable,     
input  wire [4:0]  fault_bit,     
output wire [31:0] pc_out,     
output wire [31:0] alu_result_raw,     
output wire [31:0] alu_result_observed );
    riscv_core1 core2_engine (         
    .clk            (clk),
        .reset          (reset),
        .pc        (pc_out),         
        .alu_result (alu_result_raw)     );
    fault_injection injector (         
    .data_in      (alu_result_raw),
        .fault_enable (fault_enable),
        .fault_bit    (fault_bit),         
        .data_out     (alu_result_observed)     ); 
        endmodule