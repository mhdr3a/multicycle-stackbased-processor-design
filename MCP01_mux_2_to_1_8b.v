module MCP01_mux_2_to_1_8b(i0, i1, sel, y);
	input [7:0] i0, i1;
	input sel;
	output [7:0] y;
	
	assign y = sel ? i1 : i0;

endmodule