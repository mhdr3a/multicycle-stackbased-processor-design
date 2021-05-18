`define IF 4'b0000
`define ID 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1011
`define S12 4'b1100
`define S13 4'b1101
`define S14 4'b1110

module MCP01_controller(IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, ALU_Control, tos, JZ, rst, clk, opcode);

	input rst, clk;
    input [2:0] opcode;
	output IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, tos, JZ;
    output [1:0] ALU_Control;
	reg IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, tos, JZ;
    reg [1:0] ALU_Control;

	reg [3:0] ps, ns;
	
	always @(posedge clk)
		if (rst)
			ps <= `IF;
		else
			ps <= ns;
	
	always @(ps or opcode)
	begin
		case(ps)
			`IF: ns = `ID;
			`ID: ns = opcode[2] == 1'b0    ? `S6  : // ADD, SUB, AND, NOT
                      opcode    == 3'b100  ? `S2  : // PUSH
                      opcode    == 3'b101  ? `S4  : // POP
                      opcode    == 3'b110  ? `S14 : `S12; // JMP | JZ
			`S2: ns = `S3;
			`S3: ns = `IF;
			`S4: ns = `S5;
			`S5: ns = `IF;
            `S6: ns = `S7;
			`S7: ns = opcode == 3'b011 ? `S10 : `S8;
			`S8: ns = `S9;
			`S9: ns = `S10;
			`S10: ns = `S11;
			`S11: ns = `IF;
			`S12: ns = `S13;
			`S13: ns = `IF;
            `S14: ns = `IF;
		endcase
	end

	always @(ps)
	begin
		{IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, ALU_Control, tos, JZ} = 17'b0_0000_0000_0000_0000;
		case(ps)
			`IF: {IorD, MemRead, IR_Write, PC_Write, PCsel} = 5'b0_1110;
			`S2: {IorD, MemRead} = 2'b11; // PUSH
			`S3: {d_in_sel, push} = 2'b01; // PUSH
			`S4: pop = 1'b1; // POP
			`S5: {IorD, MemWrite} = 2'b11; // POP
            `S6: pop = 1'b1; // ADD, SUB, AND, NOT
			`S7: ldop1 = 1'b1; // ADD, SUB, AND, NOT
            `S8: pop = 1'b1; // ADD, SUB, AND
            `S9: ldop2 = 1'b1; // ADD, SUB, AND
			`S10: {ALU_Src_A, ALU_Src_B, ALU_Control} = {2'b11, opcode[1:0]}; // ADD, SUB, AND, NOT
			`S11: {push, d_in_sel} = 2'b11; // ADD, SUB, AND, NOT
            `S12: tos = 1'b1; // JZ
			`S13: {JZ, PCsel} = 2'b11; // JZ
			`S14: {PC_Write, PCsel} = 2'b11; // JMP
		endcase
	end

endmodule
