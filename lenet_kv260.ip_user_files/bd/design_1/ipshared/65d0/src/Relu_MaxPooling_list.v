


module Relu_MaxPooling_list #(

    parameter dwidth       = 16,
    parameter pooling_size = 2,
    parameter strides      = 2,
    parameter PE_latency   = 2, 
    parameter PE_Num       = 8

)(
    input wire clk,
    input wire rst_n, 
    input wire  din_st,   // data in  start
    input wire [4:0] featmap_size,
    input wire convlayer_state,
    input wire signed  [PE_Num*dwidth-1:0] din,


    output wire signed [PE_Num*dwidth-1:0] dout,
    output wire dout_st  // data out start
);
	// Control Signal
    wire [PE_Num-1:0] dout_st_list; 
    wire list_din_st;

    assign list_din_st = din_st  && (convlayer_state == 'd0);

	/************ Control Part ************/
    generate
        genvar i;
        for (i = 0; i < PE_Num; i = i + 1)
        begin: relu_pooling
            Relu_MaxPooling #(
                .dwidth(dwidth),
                .pooling_size(pooling_size),
                .strides(strides),
                .PE_latency(PE_latency)
            ) inst_Relu_MaxPooling (
                .clk         (clk),
                .rst_n       (rst_n),
                .input_rd_en (list_din_st),
                .featmap_size(featmap_size),
                .convlayer_state(convlayer_state),
                
                .din         (din[i*dwidth +: dwidth]),
                .dout        (dout[i*dwidth +: dwidth]),
                .dout_start  (dout_st_list[i])
            );
        end
    endgenerate

    assign dout_st = &dout_st_list;

endmodule