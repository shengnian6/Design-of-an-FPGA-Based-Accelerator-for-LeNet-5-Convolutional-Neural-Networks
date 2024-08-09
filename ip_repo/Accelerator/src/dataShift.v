//==============================================================================
	//  Filename   	  : dataShift.v
	//  Create 		  : 2020-03-15 14:07:40
	//  Revise 		  : 2020-04-04 13:43:56
	//


	//  Description   : 

//==============================================================================


module dataShift #(
	parameter dwidth = 16
)(	
	input wire signed [dwidth-1:0] din,
	input wire convlayer_state,
	input wire clk,
	input wire rst,

    output reg signed [dwidth-1:0] dout00,dout01,dout02,
    output reg signed [dwidth-1:0] dout10,dout11,dout12,
    output reg signed [dwidth-1:0] dout20,dout21,dout22
);

	wire signed [dwidth-1:0] shift_dout0_layer1;
	wire signed [dwidth-1:0] shift_dout1_layer1;
	wire signed [dwidth-1:0] shift_dout0_layer2;
	wire signed [dwidth-1:0] shift_dout1_layer2;

	wire signed [dwidth-1:0] shift_dout0_temp;
	wire signed [dwidth-1:0] shift_dout1_temp;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			dout00 <= 0; 
			dout01 <= 0;
			dout02 <= 0;

			dout10 <= 0;
			dout11 <= 0;
			dout12 <= 0;

			dout20 <= 0;
			dout21 <= 0;
			dout22 <= 0;
		end
		else begin
			dout00 <= dout01;
			dout01 <= dout02;
			dout02 <= shift_dout0_temp;

			dout10 <= dout11;
			dout11 <= dout12;
			dout12 <= shift_dout1_temp;

			dout20 <= dout21;
			dout21 <= dout22;
			dout22 <= din;
		end
	end
		
	assign shift_dout0_temp = (convlayer_state == 'd0)? shift_dout0_layer1: shift_dout0_layer2;
	assign shift_dout1_temp = (convlayer_state == 'd0)? shift_dout1_layer1: shift_dout1_layer2;

	//例化 2 组 shift_ram 模块
	shift_ram sf_ram1_layer2(
		.D(dout20), 
		.CLK(clk), 
		.Q(shift_dout1_layer2)
	);

	shift_ram sf_ram0_layer2(
		.D(dout10), 
		.CLK(clk), 
		.Q(shift_dout0_layer2)
	);

	shift_ram_1 sf_ram1_layer1 (
	 	.D(shift_dout1_layer2),      
	 	.CLK(clk),  
	 	.Q(shift_dout1_layer1)      
	);

	shift_ram_1 sf_ram0_layer1 (
	 	.D(shift_dout0_layer2),      
	 	.CLK(clk),  
	 	.Q(shift_dout0_layer1)   
	);

endmodule
