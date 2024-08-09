//==============================================================================
	//  Filename   	  : dataCorrect.v
	//  Create 		  : 2020-03-13 17:04:14
	//  Revise 		  : 2020-03-13 18:16:10


//==============================================================================


module dataCorrect #(

	parameter integer dwidth = 16,
    parameter integer kernel_size = 3,
    parameter integer strides = 1,
    parameter integer PE_latency = 5
    
)(
	input wire signed [dwidth-1:0] din,
	input wire clk,
	input wire rst,
	input wire din_en,
	input wire [4:0] featmap_size,

	output wire signed [dwidth-1:0] dout,
	output wire full,
	output wire empty,
	output wire dout_start,

	// debug
	output wire select_en,
	output wire dwr_en
);

	// 计算 log2
	function integer clogb2 (input integer depth);
	begin
		if (depth == 1)
			clogb2 = 0;
		else
			for (clogb2=0; depth>1; clogb2=clogb2+1) 
		        depth = depth >>1;                          
	end
	endfunction

	// parameter integer clkN = (strides == 1)? featmap_size : 2,
    // parameter integer rid_clkN = (strides == 1)? (featmap_size - kernel_size) : 1,
    // parameter integer outputsize = ((featmap_size - kernel_size)/strides + 1)**2,	
    // parameter integer dout_rdN = 1 + outputsize*((strides*featmap_size)-((featmap_size - kernel_size)/strides + 1))/(strides*featmap_size)
	reg [clogb2(32)-1:0] clkN;
	reg [clogb2(4)-1:0] rid_clkN;
	reg [clogb2(1024)-1:0] outputsize;
	reg [clogb2(256)-1:0] dout_rdN;
	reg [clogb2(1024)-1:0] dout_cntN;
	reg [clogb2(1024)-1:0] dout_latency_cntN;

	always @(*) begin
		if (rst) begin
			clkN                      = 'd30;
			rid_clkN                  = 'd2;
			outputsize                = 'd784;
			dout_rdN                  = 'd53;
			dout_cntN                 = 'd840;
			dout_latency_cntN         = 'd66;
		end
		else begin
			case(featmap_size)
				// convPE
				5'd30: begin
					clkN              = 'd30;
					rid_clkN          = 'd2;
					outputsize        = 'd784;
					dout_rdN          = 'd53;
					dout_cntN         = 'd840;
					dout_latency_cntN = 'd66;
				end
				5'd28: begin
					clkN              = 'd2;
					rid_clkN          = 'd1;
					outputsize        = 'd196;
					dout_rdN          = 'd148;
					dout_cntN         = 'd756;
					dout_latency_cntN = 'd31;
				end
				5'd14: begin
					clkN              = 'd14;
					rid_clkN          = 'd2;
					outputsize        = 'd144;
					dout_rdN          = 'd22;
					dout_cntN         = 'd168;
					dout_latency_cntN = 'd34;
				end
				5'd12: begin
					clkN              = 'd2;
					rid_clkN          = 'd1;
					outputsize        = 'd36;
					dout_rdN          = 'd28;
					dout_cntN         = 'd132;
					dout_latency_cntN = 'd15;
				end
				default: begin
					clkN              = 'd5;
					rid_clkN          = 'd2;
					outputsize        = 'd9;
					dout_rdN          = 'd5;
					dout_cntN         = 'd15;
					dout_latency_cntN = 'd16;
				end
			endcase
		end
	end

	// 1> 产生 dw_en 信号
	reg [1:0] state;
	reg [clogb2(1024)-1:0] data_cnt;     // log2(featmap_size*featmap_size+1+PE_latency)
	reg [clogb2(1024)-1:0] dout_cnt;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			state <= 'd0;
			data_cnt <= 'd0;
		end
		else begin
			case (state)
				'd0:
					if(din_en) begin
	    				state <= 'd1;
	    				data_cnt <= 'd1;
	    			end
	    			else begin
	    				state <= 'd0;
	    				data_cnt <= 'd0;
	    			end
	    		'd1:	
					if (~din_en) begin
			    		state <= 'd0;
			    		data_cnt <= 'd0;
			    	end
			    	else begin
			    		data_cnt <= data_cnt + 'd1;
			    	end
	        endcase	
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			dout_cnt <= 'd0;
		end
		// n*(n-m+1) -> done
		else if (dout_cnt == dout_cntN) begin
    		dout_cnt <= 'd0;
		end
		else if (dout_cnt > 'd0) begin
			dout_cnt <= dout_cnt + 'd1;
		end
		// n*(m-1)+1 + PE_latnecy -> start
		else if (data_cnt == dout_latency_cntN)begin
			dout_cnt <= 'd1;
		end
		else begin
			dout_cnt <= dout_cnt;
		end
	end
	
	assign dwr_en = (state == 'd0 && dout_cnt == 'd0)?1'b0:
					((dout_cnt == dout_cntN)?1'b0:
					((dout_cnt >= 'd1 || data_cnt == dout_latency_cntN)?1'b1:1'b0));	


    // 2> 产生数据剔除信号  xx111 xx111 -> 111 111
	reg [4:0] rid_cnt;
	always @(posedge clk or posedge rst) begin
		if (rst | (!dwr_en)) begin
			// reset
			rid_cnt <= 0;
		end
		else if (rid_cnt == clkN-1) begin
			rid_cnt <= 0;
		end
		else begin
			rid_cnt <= rid_cnt + 1;
		end
	end

	reg [4:0] stride_cnt;
	reg stride_state;
	always @(posedge clk or posedge rst) begin
		if (rst | (!dwr_en)) begin
			// reset
			stride_cnt <= 0;
			stride_state <= 0;
		end
		else if (stride_cnt == featmap_size-1) begin
			stride_cnt <= 0;
			stride_state <= ~stride_state;
		end
		else begin
			stride_cnt <= stride_cnt + 1;
		end
	end

	assign select_en = (strides > 1)?
					((stride_state == 1'b0)?((rid_cnt >= rid_clkN)? 1'b1: 1'b0):1'b0):
					((rid_cnt >= rid_clkN)? 1'b1: 1'b0);

	// 3> 根据 prog_full 信号, 读入 k 个数据后自动读出 (既保证数据的不丢失，又尽可能减少计算的等待时间)
    wire [clogb2(1024)-1:0] data_count;
    reg rd_state;
	reg [clogb2(1024)-1:0] rd_cnt; 

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			rd_state <= 'd0;
			rd_cnt <= 'd0;
		end
		else begin
			case (rd_state)
				'd0:
					if (dwr_en & data_count == dout_rdN) begin
	    				rd_state <= 'd1;
	    			end
	    			else begin
	    				rd_state <= 'd0;
	    			end
	    		'd1: 
	    			if (rd_cnt == outputsize) begin
	    				rd_cnt <= 'd0;
	    				rd_state <= 'd0;
	    			end
	    			else begin	    				
	    				rd_cnt <= rd_cnt + 'd1;
	    			end
	    	endcase
	    end
	end

	assign dout_start = (rd_state == 'd0)?((dwr_en & data_count == dout_rdN)?1'b1:1'b0):
						((rd_cnt == outputsize)?1'b0:1'b1);
	

	// 例化 fifo 模块
	fifo_generator_0 fifo0(
		.clk(clk), 
		.srst(rst), 
		.din(din), 
		.wr_en(select_en), 
		.rd_en(dout_start), 
		.dout(dout), 
		.full(full), 
		.data_count(data_count),
		.empty(empty)
	);

endmodule
