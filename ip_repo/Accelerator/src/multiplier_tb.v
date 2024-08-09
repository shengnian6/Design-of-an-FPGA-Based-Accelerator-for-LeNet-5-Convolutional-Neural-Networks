`timescale 1ns / 1ps

module multiplier_tb();
	
	parameter dwidth = 16;

	reg clk;
	reg [dwidth-1:0] din;
	reg [dwidth-1:0] win;

	wire [2*dwidth-1:0] calc_out;
	wire [dwidth-1:0] dout;


	multiplier mult (
        .CLK(clk),      // input wire CLK
        .CE(1'b1),
        .A(din),      // input wire [15 : 0] A
        .B(win),        // input wire [15 : 0] B
        .P(calc_out)      // output wire [31 : 0] P
    );

	assign dout = calc_out[2*dwidth-2-:dwidth];


	// clock signal
	initial begin
		clk = 0;
		repeat(2)
			#(5) clk = ~clk;
	end

	initial begin
		din = 16'h0;
		#(10)
		#(10) din = 16'h00e1;
	end

	initial begin
		win = 16'h0;
		#(10)
		#(10) win = 16'hff7d;
	end

endmodule