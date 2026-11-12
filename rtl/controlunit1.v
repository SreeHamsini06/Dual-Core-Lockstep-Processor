

module controlunit1(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       alu_src,
    output reg       branch,
    output reg [3:0] alu_control,
    output reg       mem_to_reg
);

    // Opcodes
    localparam R_TYPE = 7'b0110011;
    localparam I_TYPE = 7'b0010011;
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam BRANCH = 7'b1100011;

    always @(*) begin

        // Default values
        reg_write  = 0;
        mem_read   = 0;
        mem_write  = 0;
        alu_src    = 0;
        branch     = 0;
        alu_control = 4'b0000;
        mem_to_reg = 0;

        case (opcode)

            // R-type
            R_TYPE: begin
                reg_write = 1;
                alu_src = 0;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD
                    end

                    3'b111:
                        alu_control = 4'b0010; // AND

                    3'b110:
                        alu_control = 4'b0011; // OR

                    3'b100:
                        alu_control = 4'b0100; // XOR

                    default:
                        alu_control = 4'b0000;

                endcase
            end

            // ADDI
            I_TYPE: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = 4'b0000;
            end

            // LW
            LOAD: begin
                reg_write = 1;
                mem_read = 1;
                mem_to_reg = 1;
                alu_src = 1;
                alu_control = 4'b0000;
            end

            // SW
            STORE: begin
                mem_write = 1;
                alu_src = 1;
                alu_control = 4'b0000;
            end

            // BEQ
            BRANCH: begin
                branch = 1;
                alu_src = 0;
                alu_control = 4'b0001; // SUB
            end

            default: begin
                reg_write = 0;
            end

        endcase
    end

endmodule

   
