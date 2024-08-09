//==============================================================================
	//  Filename   	  : Relu_MaxPooling_tb.v
	//  Create 		  : 2020-04-07 15:55:56
	//  Revise 		  : 2020-04-08 13:17:54
	//

	//  Description   : 

//==============================================================================

module Relu_MaxPooling_tb(); 

	parameter dwidth = 16;
    parameter kernel_size = 2;
    parameter strides = 2;
    parameter PE_latency = 2; 

    reg [4:0] featmap_size;
	reg signed [dwidth-1:0] din;
   	reg clk;
   	reg rst_n;
   	reg win_empty;
   	reg din_empty;
   	reg convlayer_state;

    wire [dwidth-1:0] dout;
    wire input_rd_en;
    wire dout_start;

    // debug
    // wire dwr_en;
    // wire select_en;
    // wire signed [dwidth-1:0] dout00,dout01;
    // wire signed [dwidth-1:0] dout10,dout11;
    // wire signed [dwidth-1:0] maxout_reg;
    // wire signed [dwidth-1:0] compare_reg1;
	// wire signed [dwidth-1:0] compare_reg2;

	Relu_MaxPooling #(
			.dwidth(dwidth),
			.kernel_size(kernel_size),
			.strides(strides),
			.PE_latency(PE_latency)
		) inst_Relu_MaxPooling (
			.clk         (clk),
			.rst_n       (rst_n),
			.input_rd_en (input_rd_en),
			.din         (din),
			.featmap_size (featmap_size),
			.convlayer_state (convlayer_state),

			.dout        (dout),
			.dout_start  (dout_start)

			// debug
			// .dwr_en		 (dwr_en),
			// .select_en   (select_en),
			// .dout00(dout00),.dout01(dout01),
			// .dout10(dout10),.dout11(dout11),
			// .maxout_reg(maxout_reg),
			// .compare_reg1(compare_reg1),
			// .compare_reg2(compare_reg2)
		);

	/****** Control Signal ******/

	// reset signal & enable signal
	initial begin
		rst_n = 1'b0;
		featmap_size = 'd28;
		convlayer_state = 'd0;
		#(5) rst_n = 1'b1;
	end
	
	// data in enable signal
	initial begin
		din_empty = 1'b1;
		#(15) din_empty = 1'b0;
		#(7840) din_empty = 1'b1;
	end

	initial begin
		win_empty = 1'b1;
		#(15) win_empty = 1'b0;
		#(7840) win_empty = 1'b1;
	end

	assign input_rd_en = (~din_empty) & (~win_empty);
	
	// clock signal
	initial begin
		clk = 0;
		forever
			#(5) clk = ~clk;
	end

	/****** Data & Parameters ******/

	// data input
	initial begin
		din = 16'h0;
		repeat(784)
			#(10) din = din + 1;
	end

endmodule
