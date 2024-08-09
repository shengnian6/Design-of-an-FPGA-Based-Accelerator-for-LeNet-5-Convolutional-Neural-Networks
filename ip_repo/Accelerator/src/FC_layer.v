//==============================================================================
    
    //  Filename      : FC_layer.v
    //  Create        : 2020-04-28 16:13:15
    //  Revise        : 2020-03-13 13:59:54
    //


    //  Description   : 

//==============================================================================


module FC_layer #(

    parameter dwidth       = 16,
    parameter qwidth       = 11,
    parameter featmap_size = 6,
    parameter FC_latency   = 7,
    parameter PE_Num       = 8

)(

    input wire clk,
    input wire rst_n,
    input wire din_st,
    input wire signed [dwidth-1:0] din,    

    output wire signed [dwidth-1:0] dout,
    output wire dout_st 

);
    // control signal
    reg [4:0] fc_outcnt;
    reg [3:0] dout_cnt;
    reg [5:0] fclayer_buffer_raddr_cnt;
    reg       dout_st_fifo_reg;
    reg       dout_st_reg;
    wire      dout_st_fifo;
    wire      fclayer_din_st;
    wire      fclayer_dout_st;
    reg [FC_latency-1:0] delay_shift;
    wire fclayer_din_st_delay;  
    
    // datapath signal
    reg [5:0] fclayer_buffer_raddr;
    reg [5:0] fclayer_buffer_waddr;
    reg [8:0] fcweight_raddr;
    wire signed [2*PE_Num*dwidth-1:0] fclayer_din;
    wire signed [2*PE_Num*dwidth-1:0] fclayer_win;
    wire signed [2*PE_Num*dwidth-1:0] mult_dout;
    wire signed [dwidth-1:0]          adderTree_dout1;
    wire signed [dwidth-1:0]          adderTree_dout2;
    wire signed [dwidth-1:0]          adderTree_dout;
    wire signed [dwidth-1:0]          FIFO_dout;
    wire signed [dwidth:0]            accum_dout_org;
    wire signed [dwidth-1:0]          accum_dout;

    // rst & rst_n compatible
    wire rst;
    assign rst = ~rst_n;

    /************ Control Part ************/
    // generate bram select signal
    reg  [2*PE_Num:0] bram_select_reg;
    wire [2*PE_Num-1:0] bram_select;
    reg  [5:0] buffer_waddr_cnt;
    reg din_st_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            din_st_reg <= 'd0;
        end
        else begin
            din_st_reg <= din_st;
        end
    end

    // fclayer select signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            buffer_waddr_cnt <= 'd0;
        end
        else if (din_st == 1'b1) begin
            buffer_waddr_cnt <= buffer_waddr_cnt + 'd1;
        end
        else begin
            buffer_waddr_cnt <= 'd0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            bram_select_reg <= 17'b1;
        end
        else if (din_st == 1'b1 && buffer_waddr_cnt == 'd0) begin
            bram_select_reg <= bram_select_reg << 1;
        end
        else if (fc_outcnt == 'd10) begin
            bram_select_reg <= 17'b1;
        end
        else begin
            bram_select_reg <= bram_select_reg; 
        end
    end
        
    assign bram_select = (bram_select_reg[2*PE_Num:1] < 16'h8000 && bram_select_reg[2*PE_Num:1] > 16'h8000)?
                        ((din_st_reg)? bram_select_reg[2*PE_Num:1]: 16'b0):
                        bram_select_reg[2*PE_Num:1];

    // generate fclayer_buffer write address (convlayer_dout -> bram)       
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            fclayer_buffer_waddr <= 5'd0;
        end
        else if (din_st_reg == 1'b1) begin
            fclayer_buffer_waddr <= fclayer_buffer_waddr + 1'b1;
        end
        else begin
            fclayer_buffer_waddr <= 5'd0;
        end
    end

    
    assign fclayer_din_st = (fc_outcnt == 'd10)?1'b0:
                            ((bram_select == 16'h8000 && ~din_st)? 1'b1: 1'b0);
    
    // generate fcayer_buffer read address (bram -> fclayer_din)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            fclayer_buffer_raddr <= 5'd0;
        end
        else if (fclayer_din_st && fclayer_buffer_raddr < featmap_size*featmap_size-1) begin
            fclayer_buffer_raddr <= fclayer_buffer_raddr + 1'b1;
        end
        else begin
            fclayer_buffer_raddr <= 5'd0;
        end
    end

    // generate fcweight_raddr
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            fcweight_raddr <= 'd0;
        end
        else if (fclayer_din_st && fcweight_raddr < featmap_size*featmap_size*10-1) begin
            fcweight_raddr <= fcweight_raddr + 'd1;
        end
        else if (fclayer_din_st && fcweight_raddr == featmap_size*featmap_size*10-1) begin
            fcweight_raddr <= 'd0;
        end
        else begin
            fcweight_raddr <= 'd0;
        end
    end

    /************ DataPath Part ************/
    // 0> convlayer dout -> bram buffer
    FClayer_buffer #(
            .dwidth(dwidth),
            .PE_Num(PE_Num)
        ) inst_FClayer_buffer (
            .clk          (clk),
            .wdata_st     (bram_select),
            .rdata_st     (fclayer_din_st),
            .buffer_raddr (fclayer_buffer_raddr),
            .buffer_waddr (fclayer_buffer_waddr),
            .din          (din),
            .dout         (fclayer_din)
        );

    // 0> fclayer weight
    bram_fcweight inst_bram_fcweight (
            .clka(clk),    
            .ena(1'b1),    
            .addra(fcweight_raddr),   
            .douta(fclayer_win)  
        );

    // 1> Instance Multiplier List 
    multiplier_list #(
            .dwidth(dwidth),
            .qwidth(qwidth),
            .PE_Num(PE_Num)
        ) inst_multiplier_list (
            .clk         (clk),
            .fclayer_din (fclayer_din),
            .fclayer_win (fclayer_win),
            .mult_dout   (mult_dout)
        );


    // 2> instantiate adderTree-1
    adderTree #(
            .dwidth(dwidth)
        ) inst_adderTree_1 (
            .clk   (clk),
            .rst   (rst),
            .din00 (mult_dout[0*dwidth +: dwidth]),
            .din01 (mult_dout[1*dwidth +: dwidth]),
            .din02 (mult_dout[2*dwidth +: dwidth]),
            .din10 (mult_dout[3*dwidth +: dwidth]),
            .din11 (mult_dout[4*dwidth +: dwidth]),
            .din12 (mult_dout[5*dwidth +: dwidth]),
            .din20 (mult_dout[6*dwidth +: dwidth]),
            .din21 (mult_dout[7*dwidth +: dwidth]),
            .dout  (adderTree_dout1)
        );

    // 2> instantiate adderTree-2
    adderTree #(
            .dwidth(dwidth)
        ) inst_adderTree_2 (
            .clk   (clk),
            .rst   (rst),
            .din00 (mult_dout[8*dwidth  +: dwidth]),
            .din01 (mult_dout[9*dwidth  +: dwidth]),
            .din02 (mult_dout[10*dwidth +: dwidth]),
            .din10 (mult_dout[11*dwidth +: dwidth]),
            .din11 (mult_dout[12*dwidth +: dwidth]),
            .din12 (mult_dout[13*dwidth +: dwidth]),
            .din20 (mult_dout[14*dwidth +: dwidth]),
            .din21 (mult_dout[15*dwidth +: dwidth]),
            .dout  (adderTree_dout2)
        );
    
    // 3> fclayer adder
    Adder #(.dwidth(dwidth)) inst_Adder_adderTree (      
        .clk(clk), 
        .rst(rst), 
        .din1(adderTree_dout1), 
        .din2(adderTree_dout2), 
        .dout(adderTree_dout)
    );  

    // 4> acc_adder
    accum accumer (
        .B(adderTree_dout),            
        .CLK(clk),        
        .BYPASS(~fclayer_din_st_delay), 
        .SCLR(fclayer_dout_st), 
        .Q(accum_dout_org)           
    );       

    // 小数位低位截位 -> 11位，无
    // 整数位高位截位 -> 溢出进行饱和操作
    assign accum_dout = (accum_dout_org[dwidth:dwidth-1] == {2{1'b0}} 
                || accum_dout_org[dwidth:dwidth-1] == {2{1'b1}})?
                accum_dout_org[dwidth-1:0]:{accum_dout_org[dwidth],{(dwidth-1){!accum_dout_org[dwidth]}}};
    

    // fclayer_din_st delay FC_latency clocks

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            delay_shift <= 'd0;
        end
        else if (fclayer_din_st) begin
            delay_shift <= {delay_shift[FC_latency-2:0], fclayer_din_st};
        end
        else begin
            delay_shift <= 'd0;
        end
    end
    
    assign fclayer_din_st_delay = delay_shift[FC_latency-1];

    assign fclayer_dout_st = (fclayer_din_st_delay && fclayer_buffer_raddr_cnt == featmap_size*featmap_size-1)? 1'b1: 1'b0;
            

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            fclayer_buffer_raddr_cnt <= 'd0;
        end
        else if ((fclayer_din_st_delay && fclayer_buffer_raddr_cnt < featmap_size*featmap_size-1)) begin
            fclayer_buffer_raddr_cnt <= fclayer_buffer_raddr_cnt + 'd1;
        end
        else begin
            fclayer_buffer_raddr_cnt <= 'd0;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            fc_outcnt      <= 'd0;    
            dout_st_fifo_reg <= 'd0;        
        end
        else if (fc_outcnt == 'd10) begin
            fc_outcnt      <= 'd0;
            dout_st_fifo_reg <= 'd1;
        end
        else if (fclayer_dout_st) begin
            fc_outcnt      <= fc_outcnt + 'd1;          
        end
        else if (dout_cnt == 'd10) begin
            dout_st_fifo_reg <= 'd0;
        end
        else begin
            dout_st_fifo_reg <= dout_st_fifo_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            dout_cnt <= 'd0;
        end
        else if (dout_st_fifo_reg && dout_cnt < 'd10) begin
            dout_cnt <= dout_cnt + 'd1;
        end
        else begin
            dout_cnt <= 'd0;
        end
    end
    
    assign dout_st_fifo = (dout_cnt < 'd10)? dout_st_fifo_reg: 1'b0;

    fifo_FClayer inst_fifo_FClayer (
        .clk(clk),     
        .din(accum_dout),      
        .wr_en(fclayer_dout_st),  
        .rd_en(dout_st_fifo),  
        .dout(FIFO_dout),    
        .full(),    
        .empty()   
    );
    
    // 5> convlayer2 bias adder-2
    reg [10*dwidth-1:0] bias_array;
    reg [dwidth-1:0] bias;

    // initial bias value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          // reset
            bias_array <= 159'h000f002cfffaffb7ff87004ffff5002000040010;
            bias       <= 'd0;
        end
        else if (dout_st_fifo && dout_cnt < 'd10) begin
            bias       <= bias_array[10*dwidth-1 -: dwidth];
            bias_array <= bias_array << dwidth;
        end
        else if (dout_cnt == 'd10) begin
            bias_array <= 159'h000f002cfffaffb7ff87004ffff5002000040010;
            bias       <= 'd0;
        end
        else begin
            bias_array <= bias_array;
            bias       <= 'd0;
        end
    end
                    

    Adder #(.dwidth(dwidth)) inst_Adder_bias (      
        .clk(clk), 
        .rst(rst), 
        .din1(FIFO_dout), 
        .din2(bias), 
        .dout(dout)
    ); 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            dout_st_reg <= 1'b0;
        end
        else begin
            dout_st_reg <= dout_st_fifo;
        end
    end
    
    assign dout_st = dout_st_reg;

endmodule








