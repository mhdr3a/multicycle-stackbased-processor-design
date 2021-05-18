module MCP01_reg_8b(d, ld, rst, clk, q);
	input [7:0] d;
	input ld, rst, clk;
	output [7:0] q;
	reg [7:0] q;
	
	always @(posedge clk)
		if(rst)
			q <= 8'b0000_0000;
		else if(ld)
			q <= d;

endmodule