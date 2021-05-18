module MCP01_datapath(IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, ALU_Control, tos, JZ, rst, clk, opcode);

    output [2:0] opcode;

	input IorD, MemRead, IR_Write, PC_Write, PCsel, d_in_sel, push, pop, MemWrite, ldop1, ldop2, ALU_Src_A, ALU_Src_B, tos, JZ, rst, clk;
    input [1:0] ALU_Control;

    wire PC_ld;
    wire [7:0] ALU_Out_Reg_In, ALU_Out_Reg_Out, IR_Out, MDR_Out, d_in, op1_Out, op2_Out, A, B;
    reg [7:0] d_out, Read_Data;
	wire [4:0] PC_in, PC_out, adr;
    reg [4:0] top;

    reg [7:0] Stack [0:31];
    reg [7:0] Memory [0:31];

    MCP01_mux_2_to_1_5b mux_1(ALU_Out_Reg_In[4:0], IR_Out[4:0], PCsel, PC_in);
	MCP01_reg_5b PC(PC_in, PC_ld, rst, clk, PC_out);
    MCP01_mux_2_to_1_5b mux_2(PC_out, IR_Out[4:0], IorD, adr);
    MCP01_reg_8b IR(Read_Data, IR_Write, rst, clk, IR_Out);
    MCP01_reg_8b MDR(Read_Data, 1'b1, rst, clk, MDR_Out);
    MCP01_mux_2_to_1_8b mux_3(MDR_Out, ALU_Out_Reg_Out, d_in_sel, d_in);
    MCP01_reg_8b op1(d_out, ldop1, rst, clk, op1_Out);
    MCP01_mux_2_to_1_8b mux_4({3'b0, PC_out}, op1_Out, ALU_Src_A, A);
    MCP01_reg_8b op2(d_out, ldop2, rst, clk, op2_Out);
    MCP01_mux_2_to_1_8b mux_5(8'b0000_0001, op2_Out, ALU_Src_B, B);
    MCP01_ALU_8b ALU(A, B, ALU_Control, ALU_Out_Reg_In);
    MCP01_reg_8b ALU_Out_Reg(ALU_Out_Reg_In, 1'b1, rst, clk, ALU_Out_Reg_Out);

    initial begin
        $readmemb("stack.mem", Stack);
        $readmemb("memory.mem", Memory);
        top = 5'b0_0000;
    end

    // Stack
	always @(posedge clk) begin
        if(push) begin
            Stack[top] <= d_in;
            top <= top + 5'b0_0001;
        end
        else if(pop) begin
            d_out <= Stack[top - 5'b0_0001];
            Stack[top - 5'b0_0001] <= 8'bxxxx_xxxx;
            top <= top - 5'b0_0001;
        end
        else if(tos) begin
            d_out <= Stack[top - 5'b0_0001];
        end
    end

    // Memory
	always @(posedge clk) begin
        if(MemWrite) begin
            Memory[adr] <= d_out;
        end
    end
    always @(*) begin
        if(MemRead) begin
            Read_Data <= Memory[adr];
        end
    end

    assign opcode = IR_Out[7:5];

    assign PC_ld = PC_Write | ((& (~ d_out)) & JZ);
	
endmodule
