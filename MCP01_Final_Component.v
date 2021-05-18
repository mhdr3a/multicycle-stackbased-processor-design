module MCP01_Final_Component(rst, clk);

	input rst, clk;
	
	wire IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, tos, JZ;
    wire [1:0] ALU_Control;
    wire [2:0] opcode;
	
	MCP01_datapath dp(IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, ALU_Control, tos, JZ, rst, clk, opcode);
	
	MCP01_controller cu(IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, ALU_Control, tos, JZ, rst, clk, opcode);
	
endmodule