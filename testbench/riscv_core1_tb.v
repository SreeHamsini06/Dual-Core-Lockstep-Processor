`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 15:11:56
// Design Name: 
// Module Name: riscv_core1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module riscv_core1_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;
    wire [31:0] alu_result;

    // Instantiate processor
    riscv_core1 DUT (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .alu_result(alu_result)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        #20;

        reset = 0;

        // Run processor
        #200;

        $finish;

    end

    // Monitor
    initial begin
        $monitor(
            "Time=%0t | PC=%h | ALU Result=%h",
            $time,
            pc,
            alu_result
        );
    end

endmodule

