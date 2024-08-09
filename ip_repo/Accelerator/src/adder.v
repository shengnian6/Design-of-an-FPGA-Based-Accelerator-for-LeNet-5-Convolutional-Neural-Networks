//==============================================================================
	//  Filename   	  : adder.v
	//  Create 		  : 2020-03-31 16:42:07
	//  Revise 		  : 2020-03-31 16:42:07
	//

//==============================================================================


module Adder #(
	parameter dwidth = 16
)(
	input wire clk,
	input wire rst,
	input wire signed [dwidth-1:0] din1,	
	input wire signed [dwidth-1:0] din2,	

	output wire signed [dwidth-1:0] dout    // 16Q11
);

	
	wire signed [dwidth:0] calc_out;

    adder adder0(
    	.A(din1),
    	.B(din2),
    	.S(calc_out),
        .SINIT(rst),
        .CLK(clk)
    );

	// 小数位低位截位 -> 11位，无
	// 整数位高位截位 -> 溢出进行饱和操作
	assign dout = (calc_out[dwidth:dwidth-1] == {2{1'b0}} 
				|| calc_out[dwidth:dwidth-1] == {2{1'b1}})?
				calc_out[dwidth-1:0]:{calc_out[dwidth],{(dwidth-1){!calc_out[dwidth]}}};

endmodule