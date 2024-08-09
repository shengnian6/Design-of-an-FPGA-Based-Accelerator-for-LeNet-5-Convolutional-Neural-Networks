//==============================================================================
	//  Filename   	  : Relu_MaxPooling.v
	//  Create 		  : 2020-04-07 13:20:43
	//  Revise 		  : 2020-04-07 13:20:43
	//


//==============================================================================

module Relu_MaxPooling #(

	parameter dwidth       = 16,
    parameter pooling_size = 2,
    parameter strides      = 2,
    parameter PE_latency   = 2 

)(
	input wire clk,
	input wire rst_n,
	input wire input_rd_en,
	input wire signed [dwidth-1:0] din,
	input wire [4:0] featmap_size,
	input wire convlayer_state,

	output wire signed [dwidth-1:0] dout,
	output wire dout_start

	// debug
	// output wire dwr_en,
	// output wire select_en,
	// output reg signed [dwidth-1:0] dout00,dout01,
	// output reg signed [dwidth-1:0] dout10,dout11,
	// output reg signed [dwidth-1:0] maxout_reg,
	// output reg signed [dwidth-1:0] compare_reg1,
	// output reg signed [dwidth-1:0] compare_reg2
);
	
	// rst signal
	wire rst;
	assign rst = ~rst_n;

	// Module Statement
	// 1> Relu module
	wire signed [dwidth-1:0] dout_relu;
	assign dout_relu = (din[dwidth-1] == 1'b0)? din: 16'h00;

	// 2> pooling shift
	reg signed [dwidth-1:0] dout00,dout01;
	reg signed [dwidth-1:0] dout10,dout11;
	wire signed [dwidth-1:0] shift_dout1;
	wire signed [dwidth-1:0] shift_dout2;
	wire signed [dwidth-1:0] shift_dout_temp;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			dout00 <= 0;
			dout01 <= 0;
			dout10 <= 0;
			dout11 <= 0;

		end
		else if (input_rd_en) begin
			dout00 <= dout01;
			dout01 <= shift_dout_temp;
			dout10 <= dout11;
			dout11 <= dout_relu;
		end
	end

	assign shift_dout_temp = (convlayer_state == 'd0)? shift_dout2: shift_dout1;

	pooling_shift inst_pooling_shift1(	
		.D(dout10), 
		.CLK(clk), 
		.Q(shift_dout1)
	);

	pooling_shift_1 inst_pooling_shift2(	
		.D(shift_dout1), 
		.CLK(clk), 
		.Q(shift_dout2)
	);

	// 3> 2x2 max pooling
	wire signed [dwidth-1:0] compare1;
	wire signed [dwidth-1:0] compare2;
	wire signed [dwidth-1:0] maxout;

	reg signed [dwidth-1:0] maxout_reg;
	reg signed [dwidth-1:0] compare_reg1;
	reg signed [dwidth-1:0] compare_reg2;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			compare_reg1 <= 0;
			compare_reg2 <= 0;
			maxout_reg <= 0;
		end
		else begin
			compare_reg1 <= compare1;
			compare_reg2 <= compare2;
			maxout_reg <= maxout;
		end
	end

	assign compare1 = (dout00 >= dout01)? dout00: dout01;
	assign compare2 = (dout10 >= dout11)? dout10: dout11;
	assign maxout = (compare_reg1 >= compare_reg2)? compare_reg1: compare_reg2;

	// 4> data correct
	dataCorrect #(
		.dwidth(dwidth),
		.kernel_size(pooling_size),
		.strides(strides),
		.PE_latency(PE_latency)
	) inst_dataCorrect (
		.din        (maxout_reg),
		.clk        (clk),
		.rst        (rst),
		.din_en     (input_rd_en),
		.featmap_size (featmap_size),
		
		.dout       (dout),
		.dout_start (dout_start),
		.dwr_en		(),
		.select_en  ()
	);

endmodule

