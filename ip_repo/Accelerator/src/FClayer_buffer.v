//==============================================================================
    
    //  Filename      : FClayer_buffer.v
    //  Create        : 2020-04-28 19:59:57
    //  Revise        : 2020-03-13 13:59:54
    //


    //  Description   : 

//==============================================================================

module FClayer_buffer #(

    parameter dwidth = 16,
    parameter PE_Num = 8

)(
    input wire clk,
    input wire [2*PE_Num-1:0] wdata_st,
    input wire rdata_st,
    input wire [5:0] buffer_raddr,
    input wire [5:0] buffer_waddr,
    input wire signed  [dwidth-1:0] din,

    output wire signed [2*PE_Num*dwidth-1:0] dout
);


    generate
        genvar i;
        for (i = 0; i < 2*PE_Num; i = i + 1)
        begin: fclayer_buffer_1
            bram_layer2 inst_bram_layer2_1 (
                .clka(clk),            
                .wea(wdata_st[i]),          
                .addra(buffer_waddr),  
                .dina(din),
                .clkb(clk),
                .enb(rdata_st),                
                .addrb(buffer_raddr),  
                .doutb(dout[(2*PE_Num-i)*dwidth-1 -: dwidth])           
            );
        end
    endgenerate  

endmodule