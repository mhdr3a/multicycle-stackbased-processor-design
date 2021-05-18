module MCP01_ALU_8b(A, B, ALU_Control, ALU_out);
	input [7:0] A, B;
    input [1:0] ALU_Control;
	output [7:0] ALU_out;
	
	assign ALU_out = (ALU_Control == 2'b00) ? A + B :
                     (ALU_Control == 2'b01) ? A - B :
                     (ALU_Control == 2'b10) ? A & B : ~ A;

endmodule
