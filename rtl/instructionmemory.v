module instructionmemory (
    input  [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    initial begin
        // Default every memory location to NOP
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013;

        // ADDI x1, x0, 10
        memory[0] = 32'h00A00093;

        // ADDI x2, x0, 20
        memory[1] = 32'h01400113;

        // ADD x3, x1, x2
        memory[2] = 32'h002081B3;

        // SUB x4, x3, x1
        memory[3] = 32'h40118233;

        // AND x5, x3, x4
        memory[4] = 32'h0041F2B3;

        // OR x6, x3, x4
        memory[5] = 32'h0041E333;

        // XOR x7, x3, x4
        memory[6] = 32'h0041C3B3;

        // memory[7] and all remaining locations
        // are already initialized as NOP
    end

   assign instruction =
    (address[9:2] < 8) ? memory[address[9:2]] :
                         32'h00000013;

endmodule