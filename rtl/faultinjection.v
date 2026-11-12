

module fault_injection(     
input  wire [31:0] data_in,    
 input  wire        fault_enable,    
  input  wire [4:0]  fault_bit,     
  output wire [31:0] data_out );
    assign data_out = data_in ^ (fault_enable ? (32'h00000001 << fault_bit) : 32'h00000000); 
 

    
endmodule
