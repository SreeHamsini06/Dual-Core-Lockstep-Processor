

module dual_core_lockstep_top (     
input  wire        clk,     
input  wire        reset,     
input  wire        fault_enable,     
input  wire [4:0]  fault_bit,     
output wire        mismatch,     
output wire        error_flag,     
output wire        recovery_active,     
output wire [7:0]  recovery_count,     
output wire [1:0]  state_debug,     
output wire [31:0] pc1,     
output wire [31:0] pc2,     
output wire [31:0] alu1,     
output wire [31:0] alu2_observed );
    wire        recovery_reset;    
     wire        compare_enable;     
     wire        cores_reset;     
     wire [31:0] alu2_raw;
    assign cores_reset = reset | recovery_reset;
    riscv_core1 core1 (         .clk            (clk),
        .reset          (cores_reset),
        .pc         (pc1),         
        .alu_result (alu1)     );
    riscv_core2 core2 (         .clk                 (clk),
        .reset               (cores_reset),
        .fault_enable        (fault_enable),
        .fault_bit           (fault_bit),
        .pc_out             (pc2),
        .alu_result_raw     (alu2_raw),         
        .alu_result_observed (alu2_observed)     );
    lockstep_comparator cmp (        
     .compare_enable (compare_enable),
        .pc1            (pc1),
        .pc2            (pc2),
        .alu1           (alu1),
        .alu2           (alu2_observed),         
        .mismatch       (mismatch)     );
    recovery_fsm controller (         .clk             (clk),
        .reset           (reset),
        .mismatch        (mismatch),
        .recovery_reset  (recovery_reset),
        .compare_enable  (compare_enable),
        .recovery_active (recovery_active),
        .error_flag      (error_flag),
        .recovery_count  (recovery_count),         
        .state_debug     (state_debug)     ); endmodule


   
