

module ConvPE_list #(

    parameter dwidth       = 16,
    parameter qwidth       = 11,
    parameter kernel_size  = 3,
    parameter strides      = 1,
    parameter PE_latency   = 5,
    parameter PE_Num 	   = 8
)(
    input wire clk,
    input wire rst_n, 
    input wire convlayer_state,
    input wire din_st,	 // data in  start
    input wire win_st,
    output reg dout_st,  // data out start

    input wire [4:0] featmap_size,
	input wire signed  [PE_Num*dwidth-1:0] din,
    input wire signed  [PE_Num*dwidth-1:0] win,
    input wire signed  [PE_Num*dwidth-1:0] bias,
    output wire signed [PE_Num*dwidth-1:0] dout
);
	// Control Signal
	wire [PE_Num-1:0] dout_st_list;  

	// Datapath Signal
    wire signed [PE_Num*dwidth-1:0] conv_dout;


    // 1> Instantiate PE_Num convolution_PE
    generate
        genvar i;
        for (i = 0; i < PE_Num; i = i + 1)
        begin: conv_pe
            ConvPE #(
                .dwidth(dwidth),
                .qwidth(qwidth),
                .kernel_size(kernel_size),
                .strides(strides),
                .PE_latency(PE_latency)
            ) inst_ConvPE (
                .clk         (clk),
                .rst_n       (rst_n),
                .input_rd_en (din_st),
                .win_st      (win_st),
                .featmap_size(featmap_size),
                .convlayer_state(convlayer_state),

                .din         (din[i*dwidth +: dwidth]),
                .win         (win[i*dwidth +: dwidth]),
                .dout        (conv_dout[i*dwidth +: dwidth]),
                .dout_start  (dout_st_list[i])
            );
        end
    endgenerate 

    // according to the adders_list, dout_st need to delay a clock 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            dout_st <= 1'b0;
        end
        else begin
            dout_st <= &dout_st_list;
        end
    end
    

    // 2> Instantiate adders_list
    wire signed [PE_Num*dwidth-1:0] dout_adder_list;

    generate
        genvar j;
        for (j = 0; j < PE_Num; j = j + 1)
        begin: bias_adder
            Adder #(.dwidth(dwidth)) inst_Adder (
                .clk(clk), 
                .rst(~rst_n), 
                .din1(conv_dout[j*dwidth +: dwidth]), 
                .din2(bias[j*dwidth +: dwidth]), 
                .dout(dout_adder_list[j*dwidth +: dwidth])
            );
        end
    endgenerate

    assign dout = (convlayer_state == 'd0)? dout_adder_list: conv_dout;

endmodule
