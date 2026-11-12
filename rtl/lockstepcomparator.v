
 module lockstep_comparator (    
  input  wire        compare_enable,     
  input  wire [31:0] pc1,     
  input  wire [31:0] pc2,     
  input  wire [31:0] alu1,     
  input  wire [31:0] alu2,     
  output wire        mismatch );
    assign mismatch = compare_enable && ((pc1 != pc2) || (alu1 != alu2)
 

    );
endmodule
