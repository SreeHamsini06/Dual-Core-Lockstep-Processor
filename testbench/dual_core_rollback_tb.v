`timescale 1ns / 1ps
module dual_core_rollback_tb;
    reg clk = 1'b0;
    always #5 clk = ~clk;                 // 10 ns clock period
    reg reset = 1'b1;
    reg fault_enable = 1'b0;
    reg [4:0] fault_bit = 5'd3;          // Flip x4 bit 3: 20 -> 28
    wire [31:0] pc1, pc2, alu1, alu2;
    wire mismatch, error_flag, recovery_active;
    wire [7:0] recovery_count;
    wire [2:0] state_debug;
    wire checkpoint_valid, take_checkpoint, cores_restore, fatal_error;
    wire [31:0] checkpoint_pc, x4_core1, x4_core2, x7_core1, x7_core2;
    dual_core_rollback_top DUT (
        .clk(clk), .reset(reset),
        .fault_enable(fault_enable), .fault_bit(fault_bit),
        .pc1(pc1), .pc2(pc2), .alu1(alu1), .alu2(alu2),
        .mismatch(mismatch), .error_flag(error_flag),
        .recovery_active(recovery_active), .recovery_count(recovery_count),
        .state_debug(state_debug), .checkpoint_valid(checkpoint_valid),
        .checkpoint_pc(checkpoint_pc), .take_checkpoint(take_checkpoint),
        .cores_restore(cores_restore), .fatal_error(fatal_error),
        .x4_core1(x4_core1), .x4_core2(x4_core2),
        .x7_core1(x7_core1), .x7_core2(x7_core2)
    );
    integer failures = 0;
    initial begin
        $display("Time   PC1      PC2      x4_1   x4_2   mismatch  FSM  restore");
        $monitor("%4t   %h %h %h %h    %b        %d      %b",
                 $time, pc1, pc2, x4_core1, x4_core2,
                 mismatch, state_debug, cores_restore);
        #12 reset = 1'b0;
        // Wait for checkpoint PC 0x08 to have been saved (around 35 ns).
        wait (checkpoint_valid == 1'b1);
        if (checkpoint_pc !== 32'h00000008) begin
            $display("FAIL: checkpoint PC is not 0x08");
            failures = failures + 1;
        end
        // Core 2 reaches SUB (PC 0x0C). Inject during its commit edge.
        wait (pc2 == 32'h0000000C);
        @(negedge clk) fault_enable = 1'b1;
        @(negedge clk) fault_enable = 1'b0;
        wait (mismatch == 1'b1);
        $display("FAULT DETECTED at t=%0t: x4_core1=%h x4_core2=%h",
                 $time, x4_core1, x4_core2);
        wait (cores_restore == 1'b1);
        $display("ROLLBACK REQUEST at t=%0t to saved PC=%h", $time, checkpoint_pc);
        wait (recovery_count == 8'd1);
        #1;
        if (pc1 !== 32'h00000008 || pc2 !== 32'h00000008 ||
            x4_core1 !== 32'b0 || x4_core2 !== 32'b0 || mismatch !== 1'b0) begin
            $display("FAIL: checkpoint state was not restored correctly");
 failures = failures + 1;
        end
        // Allow re-execution of ADD, SUB, AND, OR, XOR.
        repeat (18) @(negedge clk);
        if (x4_core1 !== 32'd20 || x4_core2 !== 32'd20 ||
            x7_core1 !== 32'd10 || x7_core2 !== 32'd10 ||
            mismatch !== 1'b0 || fatal_error !== 1'b0 ||
            recovery_count !== 8'd1) begin
            $display("FAIL: cores did not re-execute correctly");
            failures = failures + 1;
        end
        if (failures == 0)
            $display("PASS: internal fault -> mismatch -> rollback to PC 0x08 -> correct re-execution");
        else
            $display("FAIL: %0d test(s) failed", failures);
        $finish;
    end
    initial begin
        #1000;
        $display("FAIL: simulation timed out");
        $finish;
    end
endmodule
