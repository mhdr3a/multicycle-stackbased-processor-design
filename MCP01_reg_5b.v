module MCP01_reg_5b(d, ld, rst, clk, q);
	input [4:0] d;
	input ld, rst, clk;
	output [4:0] q;
	reg [4:0] q;
	
	always @(posedge clk)
		if(rst)
			q <= 5'b0_0000;
		else if(ld)
			q <= d;

endmodule