//==============================================================================
    
    //  Filename      : Layer_buffer.v
    //  Create        : 2020-04-18 11:12:17
    //  Revise        : 2020-03-13 13:59:54
    //


    //  Description   : 

//==============================================================================

module Layer_buffer #(

    parameter dwidth = 16,
    parameter PE_Num = 8

)(
    input wire clk,
    input wire din_st,
    input wire [7:0] layer_buffer_raddr,
    input wire [7:0] layer_buffer_waddr,
    input wire signed  [PE_Num*dwidth-1:0] din,

    output wire signed [PE_Num*dwidth-1:0] dout
);
    
    RAM_ip bram_layer1(
        .clka(clk),    
        .wea(din_st),     
        .addra(layer_buffer_waddr),  
        .dina(din),    
        .clkb(clk),  
        .enb(1'b1),  
        .addrb(layer_buffer_raddr),  
        .doutb(dout)  
    );
    
endmodule