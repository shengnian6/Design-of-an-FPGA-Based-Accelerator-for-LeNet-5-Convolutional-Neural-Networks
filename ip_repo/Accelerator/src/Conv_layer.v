//==============================================================================
    
    //  Filename      : Conv_layer.v
    //  Create        : 2020-04-11 10:15:47
    //  Revise        : 2020-03-13 13:59:54
    //


    //  Description   : 

//==============================================================================

module Conv_layer #(

    parameter dwidth             = 16,
    parameter qwidth             = 11,
    parameter featmap1_size      = 30,
    parameter featmap2_size      = 28,
    parameter featmap3_size      = 14,
    parameter featmap4_size      = 12,    
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

    // Control Signal
    wire [4:0] featmap_size;
    wire convlayer_state;             //表示当前运行第几层卷积层
    wire convPE_din_st;
    wire win_din_st;
    wire [7:0] rom_win_raddr;
    wire [4:0] rom_bias_raddr;
    wire [7:0] layer1_buffer_waddr;
    wire [7:0] layer1_buffer_raddr;   
    wire convPE_dout_st;
    wire layer1_dout_st;
    wire layer2_dout_st;

    // Datapath Signal
    wire signed [PE_Num*dwidth-1:0]    rom_win;
    wire signed [PE_Num*dwidth-1:0]    rom_bias;
    wire signed [PE_Num*dwidth-1:0]    conv_din;
    wire signed [PE_Num*dwidth-1:0]    conv_win;
    wire signed [PE_Num*dwidth-1:0]    conv_dout;
    wire signed [PE_Num*dwidth-1:0]    layer1_dout;
    wire signed [PE_Num*dwidth-1:0]    bram_din;
    wire signed [dwidth-1:0]           adderTree_dout;
    wire signed [dwidth-1:0]           layer2_dout;

    /************ Control Part ************/
    // rst & rst_n compatible
    wire rst;
    assign rst = ~rst_n;

    Acc_Controller inst_Acc_Controller(
            .clk                 (clk),
            .rst_n               (rst_n),
            .din_st              (din_st),
            .convPE_dout_st      (convPE_dout_st),
            .layer1_dout_st      (layer1_dout_st),
            .layer2_dout_st      (layer2_dout_st),
            .featmap_size        (featmap3_size),

            .convlayer_state     (convlayer_state),
            .convPE_din_st       (convPE_din_st),
            .win_din_st          (win_din_st),
            .rom_win_raddr       (rom_win_raddr),
            .rom_bias_raddr      (rom_bias_raddr),
            .layer1_buffer_waddr (layer1_buffer_waddr),
            .layer1_buffer_raddr (layer1_buffer_raddr)
        );

    
    /************ Datapath Part ************/

    // 1> data input and select
    // instantiate rom_weight
    WinList_input #(
            .dwidth(dwidth),
            .PE_Num(PE_Num)
        ) inst_WinList_input (
            .clk           (clk),
            .rom_win_raddr (rom_win_raddr),
            .rom_win       (rom_win)
        );

    // instantiate rom_bias
    BiasList_input #(
            .dwidth(dwidth),
            .PE_Num(PE_Num)
        ) inst_BiasList_input (
            .clk            (clk),
            .rom_bias_raddr (rom_bias_raddr),
            .rom_bias       (rom_bias)
        );

    // convPE_list data_in select
    generate
        genvar i;
        for (i = 0; i < PE_Num; i = i + 1)
        begin: conv_input
            assign conv_din[i*dwidth +: dwidth] =  
                (convlayer_state == 'd0)? din: bram_din[i*dwidth +: dwidth];
            assign conv_win[i*dwidth +: dwidth] = rom_win[i*dwidth +: dwidth];
        end
    endgenerate

    assign featmap_size = (convlayer_state == 'd0)? featmap1_size: featmap3_size;

    // 2> instantiate ConvPE_list
    ConvPE_list #(
            .dwidth(dwidth),
            .qwidth(qwidth),
            .kernel_size(conv_size),
            .strides(conv_strides),
            .PE_latency(ConvPE_latency),
            .PE_Num(PE_Num)
        ) inst_ConvPE_list (
            .clk     (clk),
            .rst_n   (rst_n),
            .din_st  (convPE_din_st),
            .win_st  (win_din_st),
            .featmap_size(featmap_size),
            .convlayer_state(convlayer_state),

            .din     (conv_din),
            .win     (conv_win),
            .bias    (rom_bias),
            .dout    (conv_dout),
            .dout_st (convPE_dout_st)
        );

    // 3-1> layer1: Relu & Pooling list
    Relu_MaxPooling_list #(
            .dwidth(dwidth),
            .pooling_size(pooling_size),
            .strides(pooling_strides),
            .PE_latency(Maxpooling_latency),
            .PE_Num(PE_Num)
        ) inst_Relu_MaxPooling_list (
            .clk     (clk),
            .rst_n   (rst_n),
            .din_st  (convPE_dout_st),
            .featmap_size(featmap2_size),
            .convlayer_state(convlayer_state),

            .din     (conv_dout),
            .dout    (layer1_dout),
            .dout_st (layer1_dout_st)
        );

    // layer1_buffer BRAM
    Layer_buffer #(
            .dwidth(dwidth),
            .PE_Num(PE_Num)
        ) inst_Layer_buffer (
            .clk                (clk),
            .din_st             (layer1_dout_st),
            .layer_buffer_raddr (layer1_buffer_raddr),
            .layer_buffer_waddr (layer1_buffer_waddr),
            .din                (layer1_dout),
            .dout               (bram_din)
        );


    // 3-2> layer2: adderTree + Relu & Pooling
    adderTree #(
            .dwidth(dwidth)
        ) inst_adderTree (
            .clk   (clk),
            .rst   (rst),
            .din00 (conv_dout[0*dwidth +: dwidth]),
            .din01 (conv_dout[1*dwidth +: dwidth]),
            .din02 (conv_dout[2*dwidth +: dwidth]),
            .din10 (conv_dout[3*dwidth +: dwidth]),
            .din11 (conv_dout[4*dwidth +: dwidth]),
            .din12 (conv_dout[5*dwidth +: dwidth]),
            .din20 (conv_dout[6*dwidth +: dwidth]),
            .din21 (conv_dout[7*dwidth +: dwidth]),
            .dout  (adderTree_dout)
        );

    wire signed[dwidth-1:0] convPE2_dout;

    // convlayer2 bias adder
    Adder #(.dwidth(dwidth)) inst_Adder7 (      
        .clk(clk), 
        .rst(rst), 
        .din1(adderTree_dout), 
        .din2(rom_bias[7*dwidth +: dwidth]), 
        .dout(convPE2_dout)
    );

    // generate adderTree dout_st，delay 5 clocks
    wire adderTree_dout_st;
    reg [4:0] shift_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            shift_reg <= 'd0;
        end
        else if (convlayer_state == 'd1)begin
            shift_reg <= {shift_reg[3:0], convPE_dout_st};
        end
        else begin
            shift_reg <= 'd0;
        end
    end

    assign adderTree_dout_st = shift_reg[4];
    
    Relu_MaxPooling #(
            .dwidth(dwidth),
            .pooling_size(pooling_size),
            .strides(pooling_strides),
            .PE_latency(Maxpooling_latency)
        ) inst_Relu_MaxPooling (
            .clk         (clk),
            .rst_n       (rst_n),
            .input_rd_en (adderTree_dout_st),
            .featmap_size(featmap4_size),
            .convlayer_state(convlayer_state),

            .din         (convPE2_dout),
            .dout        (layer2_dout),
            .dout_start  (layer2_dout_st)
        );

    assign dout = layer2_dout;
    assign dout_st = layer2_dout_st;

endmodule


