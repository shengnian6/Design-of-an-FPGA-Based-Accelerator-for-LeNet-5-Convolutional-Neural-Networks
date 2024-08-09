//==============================================================================
	//  Filename   	  : ConvPE_tb.v
	//  Create 		  : 2020-03-15 14:07:22
	//  Revise 		  : 2020-03-31 21:23:58
	//


	//  Description   : 

//==============================================================================



`timescale 1ns / 1ps

module ConvPE_tb();
	
	parameter dwidth = 16;

	reg [4:0] featmap_size;
	reg signed [dwidth-1:0] din;
   	reg signed [dwidth-1:0] win;
   	reg clk;
   	reg rst_n;
   	reg win_empty;
   	reg din_empty;
   	reg convlayer_state;

    wire [dwidth-1:0] dout;
    wire input_rd_en;
    wire dout_start;


    // debug signal 
    //wire shift_en;
    //wire dwr_en;
    // wire signed [dwidth-1:0] din00,din01,din02;
    // wire signed [dwidth-1:0] din10,din11,din12;
    // wire signed [dwidth-1:0] din20,din21,din22;
    // wire signed [dwidth-1:0] w00,w01,w02;
    // wire signed [dwidth-1:0] w10,w11,w12;
    // wire signed [dwidth-1:0] w20,w21,w22;
	// wire signed [dwidth-1:0] dout00,dout01,dout02;
	// wire signed [dwidth-1:0] dout10,dout11,dout12;
	// wire signed [dwidth-1:0] dout20,dout21,dout22;
    // wire signed [dwidth-1:0] dout_org;
    // wire select_en;
	ConvPE #(
			.dwidth(dwidth)
		) inst_ConvPE (
			.clk             (clk),
			.rst_n           (rst_n),
			.input_rd_en     (input_rd_en),
			.featmap_size    (featmap_size),
			.convlayer_state (convlayer_state),
			.din             (din),
			.win             (win),
			.dout            (dout),
			.dout_start      (dout_start)
		);

	/****** Control Signal ******/

	// reset signal & enable signal
	initial begin
		rst_n = 1'b0;
		featmap_size = 'd5;
		convlayer_state = 'd1;
		#(5) rst_n = 1'b1;
	end

	// data in enable signal
	initial begin
		din_empty = 1'b1;
		#(15) din_empty = 1'b0;
		#(250) din_empty = 1'b1;
		#(15) din_empty = 1'b0;
		#(250) din_empty = 1'b1;
		#(1000) $stop;
	end

	initial begin
		win_empty = 1'b1;
		#(15) win_empty = 1'b0;
		#(250) win_empty = 1'b1;
		#(15) win_empty = 1'b0;
		#(250) win_empty = 1'b1;
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
		#(10) din = 16'h0000;		    //00e1;
		#(10) din = 16'h0000;		    //063e;
		#(10) din = 16'h0000;		    //02ab;
		#(10) din = 16'h0000;		    //07e8;
		#(10) din = 16'h0000;		    //07d0;
		#(10) din = 16'h0000;		    //0495;
		#(10) din = 16'h0000;		    //0182;
		#(10) din = 16'h0000;			//00e9;
		#(10) din = 16'h0000;			//02ab;
		#(10) din = 16'h0000;			//0596;
		#(10) din = 16'h0000;			//074f;
		#(10) din = 16'h0000;			//048d;
		#(10) din = 16'h0000;			//02ab;
		#(10) din = 16'h0025;			//07e8;
		#(10) din = 16'h01f2;			//01c2;
		#(10) din = 16'h0000;			//072f;
		#(10) din = 16'h0000;			//06bf;
		#(10) din = 16'h0101;			//07e8;
		#(10) din = 16'h0228;			//07e8;
		#(10) din = 16'h04ca;			//07e8;
		#(10) din = 16'h0000;			//0626;
		#(10) din = 16'h011c;			//0414;
		#(10) din = 16'h03d4;			//072f;
		#(10) din = 16'h05ae;			//06bf;
		#(10) din = 16'h06fb;			//07e8;
		#(20)
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0025;
		#(10) din = 16'h01f2;
		#(10) din = 16'h0000;
		#(10) din = 16'h0000;
		#(10) din = 16'h0101;
		#(10) din = 16'h0228;
		#(10) din = 16'h04ca;
		#(10) din = 16'h0000;
		#(10) din = 16'h011c;
		#(10) din = 16'h03d4;
		#(10) din = 16'h05ae;
		#(10) din = 16'h06fb;
	end

	// weights input
	initial begin
		win = 16'h0;
		#(10) win = 16'h0243;
		#(10) win = 16'hfea7;
		#(10) win = 16'hfc84;
		#(10) win = 16'h023c;
		#(10) win = 16'hffdf;
		#(10) win = 16'h0131;
		#(10) win = 16'h034f;
		#(10) win = 16'hffcd;
		#(10) win = 16'h026a;
		#(180)
		#(10) win = 16'h0243;
		#(10) win = 16'hfea7;
		#(10) win = 16'hfc84;
		#(10) win = 16'h023c;
		#(10) win = 16'hffdf;
		#(10) win = 16'h0131;
		#(10) win = 16'h034f;
		#(10) win = 16'hffcd;
		#(10) win = 16'h026a;
	end


endmodule