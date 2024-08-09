//==============================================================================
	
	//  Filename      : Accelerator_tb.v
	//  Create        : 2020-04-15 16:05:55
	//  Revise        : 2020-03-13 13:59:54
	//


	//  Description   : 

//==============================================================================

`timescale 1ns / 1ps

module Accelerator_tb();

	parameter dwidth             = 16;
    parameter qwidth             = 11;
    parameter featmap1_size      = 30;
    parameter featmap2_size      = 28;
    parameter featmap3_size      = 14;
    parameter featmap4_size      = 12;
    parameter featmap5_size      = 6;
    parameter conv_size          = 3;
    parameter pooling_size       = 2;
    parameter conv_strides       = 1;
    parameter pooling_strides    = 2;
    parameter ConvPE_latency     = 5;
    parameter Maxpooling_latency = 2;
    parameter PE_Num             = 8;

    reg clk;
    reg rst_n;
   	reg din_empty;
    wire signed [dwidth-1:0] din;
    
    wire signed [dwidth-1:0] dout;
    // wire signed [2*dwidth-1:0] convlayer_dout;
    wire din_st;
    wire dout_st;

    reg [9:0] data_raddr;
	ROM_data data_input (
		.a(data_raddr),      // input wire [9 : 0] a
		.clk(clk),
  		.spo(din)   		 // output wire [15 : 0] spo
	);

	// Conv_layer #(
	// 		.dwidth(dwidth),
	// 		.qwidth(qwidth),
	// 		.featmap1_size(featmap1_size),
	// 		.featmap2_size(featmap2_size),
	// 		.featmap3_size(featmap3_size),
	// 		.featmap4_size(featmap4_size),
	// 		.conv_size(conv_size),
	// 		.pooling_size(pooling_size),
	// 		.conv_strides(conv_strides),
	// 		.pooling_strides(pooling_strides),
	// 		.ConvPE_latency(ConvPE_latency),
	// 		.Maxpooling_latency(Maxpooling_latency),
	// 		.PE_Num(PE_Num)
	// 	) inst_Conv_layer (
	// 		.clk     (clk),
	// 		.rst_n   (rst_n),
	// 		.din_st  (din_st),
	// 		.din     (din),
	// 		.dout    (dout),
	// 		.dout_st (dout_st)
	// 	);

	Accelerator #(
			.dwidth(dwidth),
			.qwidth(qwidth),
			.featmap1_size(featmap1_size),
			.featmap2_size(featmap2_size),
			.featmap3_size(featmap3_size),
			.featmap4_size(featmap4_size),
			.featmap5_size(featmap5_size),
			.conv_size(conv_size),
			.pooling_size(pooling_size),
			.conv_strides(conv_strides),
			.pooling_strides(pooling_strides),
			.ConvPE_latency(ConvPE_latency),
			.Maxpooling_latency(Maxpooling_latency),
			.PE_Num(PE_Num)

		) inst_Accelerator (
			.clk     (clk),
			.rst_n   (rst_n),
			.din_st  (din_st),
			.din     (din),
			.dout    (dout),
			// .convlayer_dout(convlayer_dout),
			.dout_st (dout_st)
		);


	/****** Control Signal ******/
	// reset signal & enable signal
	initial begin
		rst_n = 1'b0;
		#(5) rst_n = 1'b1;
	end
	
	// data in enable signal
	initial begin
		din_empty = 1'b1;
		#(15) din_empty = 1'b0;
		#(9000) din_empty = 1'b1; 
		#(40000) din_empty = 1'b0;
		#(9000) din_empty = 1'b1; 
		#(40000) $stop;
	end

	// initial begin
	// 	$display("channel:1-16");
	// 	repeat(16) begin
	// 		repeat(6) begin
	// 			repeat (6) begin
	// 				$monitor("%8h,",convlayer_dout);
	// 			end
	// 			$write("\n");	
	// 		end
	// 	end
	// end
	

	assign din_st = (~din_empty);
	
	// clock signal
	initial begin
		clk = 0;
		forever
			#(5) clk = ~clk;
	end

	/****** Data & Parameters ******/
	// data input
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			data_raddr <= 'd0;
		end
		else if(din_st)begin
			data_raddr <= data_raddr + 1;
		end
		else begin
			data_raddr <= 'd0;
		end
	end
		

endmodule
