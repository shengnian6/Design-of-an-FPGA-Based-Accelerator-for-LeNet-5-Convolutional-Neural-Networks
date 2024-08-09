


module Accelerator #(

    parameter dwidth             = 16,
    parameter qwidth             = 11,
    parameter featmap1_size      = 30,
    parameter featmap2_size      = 28,
    parameter featmap3_size      = 14,
    parameter featmap4_size      = 12,
    parameter featmap5_size      = 6,    
    parameter conv_size          = 3,
    parameter pooling_size       = 2,    
    parameter conv_strides       = 1,
    parameter pooling_strides    = 2,
    parameter ConvPE_latency     = 5,
    parameter Maxpooling_latency = 2,
    parameter PE_Num             = 8

)(
    input wire clk,
    input wire rst_n, 
    input wire din_st,
    input wire signed [dwidth-1:0] din,

    output wire signed [dwidth-1:0] dout,
    output wire dout_st
);

    wire convlayer_dout_st;
    wire signed [dwidth-1:0] convlayer_dout;

    
    Conv_layer #(
            .dwidth(dwidth),
            .qwidth(qwidth),
            .featmap1_size(featmap1_size),
            .featmap2_size(featmap2_size),
            .featmap3_size(featmap3_size),
            .featmap4_size(featmap4_size),
            .conv_size(conv_size),
            .pooling_size(pooling_size),
            .conv_strides(conv_strides),
            .pooling_strides(pooling_strides),
            .ConvPE_latency(ConvPE_latency),
            .Maxpooling_latency(Maxpooling_latency),
            .PE_Num(PE_Num)

        ) inst_Conv_layer (
            .clk     (clk),
            .rst_n   (rst_n),
            .din_st  (din_st),
            .din     (din),
            .dout    (convlayer_dout),
            .dout_st (convlayer_dout_st)
        );

    FC_layer #(
            .dwidth(dwidth),
            .qwidth(qwidth),
            .featmap_size(featmap5_size),
            .PE_Num(PE_Num)

        ) inst_FC_layer (
            .clk     (clk),
            .rst_n   (rst_n),
            .din_st  (convlayer_dout_st),
            .din     (convlayer_dout),
            .dout    (dout),
            .dout_st (dout_st)
        );


endmodule


