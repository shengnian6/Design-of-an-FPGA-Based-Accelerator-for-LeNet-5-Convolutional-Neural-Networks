//==============================================================================
	//  Filename   	  : weightShift.v
	//  Create 		  : 2020-03-15 14:07:34
	//  Revise 		  : 2020-03-31 20:43:23
	//

	//  Description   : 

//==============================================================================

module weightShift #(
	parameter dwidth       = 16,
	parameter kernel_size  = 3
)(
	input wire clk,
	input wire rst,
	input wire win_en,
	input wire [4:0] featmap_size,
	input signed [dwidth-1:0] din,

    output reg signed [dwidth-1:0] dout00,dout01,dout02,
    output reg signed [dwidth-1:0] dout10,dout11,dout12,
    output reg signed [dwidth-1:0] dout20,dout21,dout22,	

    // debug
    output shift_en
);

    // shift_en signal 
	reg shift_en_reg;
	reg [9:0] weight_cnt;    // log2(Featmap_Size*Featmap_Size)

	always @(posedge clk or posedge rst) begin
	    if (rst) begin
	        // reset
	        shift_en_reg <= 1'b1;
	    end
	   	else if (weight_cnt == featmap_size*featmap_size) begin
            shift_en_reg <= 1'b1;
	    end 
	    else if (weight_cnt >= kernel_size*kernel_size) begin
		    shift_en_reg <= 1'b0;
		end
		else begin
			shift_en_reg <= 1'b1;
		end
	end
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			weight_cnt <= 'd0;
		end
		else if (win_en && weight_cnt < featmap_size*featmap_size - 1) begin
			weight_cnt <= weight_cnt + 'd1;
		end
		else begin
			weight_cnt <= 'd0;
		end
	end
	
	assign shift_en = shift_en_reg;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
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
		else if (shift_en) begin
			dout00 <= dout01;
			dout01 <= dout02;
			dout02 <= dout10;

			dout10 <= dout11;
			dout11 <= dout12;
			dout12 <= dout20;

			dout20 <= dout21;
			dout21 <= dout22;
			dout22 <= din;
		end
		else begin
			dout00 <= dout00;
			dout01 <= dout01;
			dout02 <= dout02;

			dout10 <= dout10;
			dout11 <= dout11;
			dout12 <= dout12;
			
			dout20 <= dout20;
			dout21 <= dout21;
			dout22 <= dout22;
		end
	end

endmodule
