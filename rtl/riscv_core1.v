`timescale 1ns / 1ps


module riscv_core1(
    input clk,
    input reset,

    output [31:0] pc,
    output [31:0] alu_result
);

    // ------------------------------------------------
    // Program Counter
    // ------------------------------------------------

    reg [31:0] pc_reg;

    assign pc = pc_reg;

    // ------------------------------------------------
    // Instruction
    // ------------------------------------------------

    wire [31:0] instruction;

    instructionmemory IMEM (
        .address(pc_reg),
        .instruction(instruction)
    );

    // ------------------------------------------------
    // Instruction fields
    // ------------------------------------------------

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // ------------------------------------------------
    // Control signals
    // ------------------------------------------------

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_src;
    wire branch;
    wire mem_to_reg;

    wire [3:0] alu_control;

    controlunit1 CU (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .alu_control(alu_control),
        .mem_to_reg(mem_to_reg)
    );

    // ------------------------------------------------
    // Register File
    // ------------------------------------------------

    wire [31:0] register_data1;
    wire [31:0] register_data2;

    wire [31:0] write_back_data;

    regfile1 RF (
        .clk(clk),
        .reset(reset),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(write_back_data),
        .reg_write(reg_write),

        .read_data1(register_data1),
        .read_data2(register_data2)
    );

    // ------------------------------------------------
    // Immediate
    // ------------------------------------------------

    wire [31:0] immediate;

    immediategenerator1 IG (
        .instruction(instruction),
        .opcode(opcode),
        .immediate(immediate)
    );

    // ------------------------------------------------
    // ALU input selection
    // ------------------------------------------------

    wire [31:0] alu_input2;

    assign alu_input2 =
        alu_src ? immediate : register_data2;

    // ------------------------------------------------
    // ALU
    // ------------------------------------------------

    wire zero;

    alu ALU (
        .a(register_data1),
        .b(alu_input2),
        .alu_control(alu_control),

        .result(alu_result),
        .zero(zero)
    );

    // ------------------------------------------------
    // Data Memory
    // ------------------------------------------------

    wire [31:0] memory_data;

    datamemory1 DMEM (
        .clk(clk),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(alu_result),
        .write_data(register_data2),

        .read_data(memory_data)
    );

    // ------------------------------------------------
    // Write Back
    // ------------------------------------------------

    assign write_back_data =
        mem_to_reg ? memory_data : alu_result;

    // ------------------------------------------------
    // Next PC
    // ------------------------------------------------

    wire branch_taken;

    assign branch_taken = branch && zero;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            pc_reg <= 32'b0;
        end

        else begin

            if (branch_taken)
                pc_reg <= pc_reg + immediate;
            else
                pc_reg <= pc_reg + 32'd4;

        end

    end

endmodule

   