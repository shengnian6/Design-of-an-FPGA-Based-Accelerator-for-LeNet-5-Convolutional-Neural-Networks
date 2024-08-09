//==============================================================================
    
    //  Filename      : Acc_Controller.v
    //  Create        : 2020-04-14 14:44:55
    //  Revise        : 2020-03-13 13:59:54
    //


    //  Description   : 

//==============================================================================

module Acc_Controller #(
    parameter convlayer_buffer_size = 16
)(	
	input wire clk,
	input wire rst_n,
	input wire din_st,
    input wire convPE_dout_st,
    input wire layer1_dout_st,
    input wire layer2_dout_st,
    input wire [4:0] featmap_size,

    output reg  convlayer_state,
    output wire convPE_din_st,
    output wire win_din_st,
    output reg [7:0] rom_win_raddr,
    output reg [4:0] rom_bias_raddr,
    output reg [7:0] layer1_buffer_waddr,
    output reg [7:0] layer1_buffer_raddr
);
    reg [4:0] layer1_buffer_outcnt;

    // convlayer_state layer1 -> 0; layer2 -> 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            convlayer_state <= 'd0;
        end
        else if (layer2_dout_st == 1'b0 && layer1_buffer_outcnt == convlayer_buffer_size) begin
            convlayer_state <= 'd0;
        end
        else if (|layer1_buffer_waddr == 1'b1 && ~layer1_dout_st) begin
            convlayer_state <= 'd1;
        end
        else begin
            convlayer_state <= convlayer_state;
        end
    end

	// generate ROM_weights_input1 read address

    assign win_din_st = (din_st || (convlayer_state == 'd1 && layer1_buffer_raddr < featmap_size*featmap_size))?
                        1'b1: 1'b0;

    reg [3:0] rom_win_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            rom_win_raddr <= 4'd0;
            rom_win_cnt <= 4'd0;
        end
        else if (layer1_buffer_outcnt == convlayer_buffer_size) begin
            rom_win_raddr <= 4'd0;
        end
        else if (win_din_st)begin
            if (rom_win_cnt < 'd9) begin
                rom_win_raddr <= rom_win_raddr + 1'b1;
                rom_win_cnt <= rom_win_cnt + 1;
            end
            else begin
                rom_win_raddr <= rom_win_raddr;
                rom_win_cnt <= rom_win_cnt;
            end
        end
        else begin
            rom_win_cnt <= 4'd0;
        end
    end


    // generate ROM_bias read address
    reg bias_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            rom_bias_raddr <= 4'd0;
            bias_state <= 'd0;
        end
        else if (layer1_buffer_outcnt == convlayer_buffer_size) begin
            rom_bias_raddr <= 4'd0;
            bias_state <= 'd0;
        end
        else if (win_din_st && convlayer_state == 'd1 && (bias_state == 'd0)) begin
            bias_state <= ~bias_state;
            rom_bias_raddr <= rom_bias_raddr + 1'b1;
        end
        else if (~win_din_st && convlayer_state == 'd1 && (bias_state == 'd1)) begin
            bias_state <= ~bias_state;
        end
        else begin
            rom_bias_raddr <= rom_bias_raddr;
        end
    end

    // generate layer1_buffer write address (layer1_dout -> bram)
    reg layer1_dout_st_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            layer1_dout_st_reg <= 'd0;
        end
        else begin
            layer1_dout_st_reg <= layer1_dout_st;
        end
    end
        
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            layer1_buffer_waddr <= 7'd0;
        end
        else if (layer1_dout_st_reg == 'd1) begin
            layer1_buffer_waddr <= layer1_buffer_waddr + 1'b1;
        end
        else begin
            layer1_buffer_waddr <= 7'd0;
        end
    end

    // generate layer1_buffer read address (bram -> layer2_din)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            layer1_buffer_raddr <= 7'd0;
            layer1_buffer_outcnt <= 'd0;
        end
        else if (convlayer_state == 'd1) begin
            if (layer1_buffer_outcnt == convlayer_buffer_size) begin
                layer1_buffer_raddr <= 7'd0;
                layer1_buffer_outcnt <= layer1_buffer_outcnt;
            end
            else if (layer1_buffer_raddr < featmap_size*featmap_size) begin
                layer1_buffer_raddr <= layer1_buffer_raddr + 1'b1;
            end
            else begin
                layer1_buffer_outcnt <= layer1_buffer_outcnt + 1'b1;
                layer1_buffer_raddr <= 7'd0;
            end
        end
        else begin
            layer1_buffer_raddr <= 7'd0;
            layer1_buffer_outcnt <= 'd0;
        end
    end
    
    // generate convPE_din_st
    assign convPE_din_st = din_st || (|layer1_buffer_raddr);

endmodule