module MCP01_tb;
	reg rst, clk;
	
	MCP01_Final_Component DUT(rst, clk);
	
	initial
	begin
		rst = 1'b0;
		clk = 1'b0;
		#13 rst = 1'b1;
		#20 rst = 1'b0;
		#2000 $stop;
	end
	
	always
	begin
		#10 clk = ~clk;
	end
endmodule