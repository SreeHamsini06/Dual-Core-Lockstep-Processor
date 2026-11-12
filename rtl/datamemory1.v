`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 15:08:06
// Design Name: 
// Module Name: datamemory1
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


module datamemory1(
    input         clk,
    input         mem_read,
    input         mem_write,

    input  [31:0] address,
    input  [31:0] write_data,

    output [31:0] read_data
);

    reg [31:0] memory [0:255];

    always @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

    assign read_data =
        mem_read ? memory[address[9:2]] : 32'b0;

endmodule

   
