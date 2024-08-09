//==============================================================================
	//  Filename   	  : multiplier.v
	//  Create 		  : 2020-03-31 15:58:57
	//  Revise 		  : 2020-03-31 15:58:57
	//


//==============================================================================

module Multiplier #(
	parameter dwidth = 16,
	parameter qwidth = 11
)(
	input wire clk,
	input wire signed [dwidth-1:0] din,	// 32Q11
	input wire signed [dwidth-1:0] win,	

	output wire signed [dwidth-1:0] dout   // 16Q11
);

	
	wire signed [2*dwidth-1:0] calc_out;

	multiplier mult (
        .CLK(clk),      // input wire CLK
        .CE(1'b1),
        .A(din),        // input wire [15 : 0] A
        .B(win),        // input wire [15 : 0] B
        .P(calc_out)    // output wire [31 : 0] P
    );

	wire carry_bit;				
	wire [2*dwidth-qwidth:0] dout_round;	// 22Q11 -> (32-11+1)Q11
	
	// 小数位低位截位 -> 四舍五入进位判断
	assign carry_bit = calc_out[2*dwidth-1]?(calc_out[qwidth-1] & (|calc_out[qwidth-2:0])):calc_out[qwidth-1];
	
	assign dout_round = {calc_out[2*dwidth-1], calc_out[2*dwidth-1:qwidth]} + carry_bit; 
	
	// 整数位高位截位 -> 溢出进行饱和操作
	assign dout = (dout_round[2*dwidth-qwidth:dwidth-1] == {(dwidth-qwidth+2){1'b0}} 
				|| dout_round[2*dwidth-qwidth:dwidth-1] == {(dwidth-qwidth+2){1'b1}})?
				dout_round[dwidth-1:0]:{dout_round[2*dwidth-qwidth],{(dwidth-1){!dout_round[2*dwidth-qwidth]}}};

endmodule