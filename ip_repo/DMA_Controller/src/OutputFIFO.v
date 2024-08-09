`timescale 1ns / 1ps
module OutputFIFO #
(
    parameter Width_Len=11,
    parameter C_M_AXI_ID_WIDTH    = 1,
    parameter C_M_AXI_AWUSER_WIDTH    = 0,
    parameter C_M_AXI_ARUSER_WIDTH    = 0,
    parameter C_M_AXI_WUSER_WIDTH    = 0,
    parameter C_M_AXI_RUSER_WIDTH    = 0,
    parameter C_M_AXI_BUSER_WIDTH    = 0

)
(
    input clk,
    input rst_n,
    input [10:0]Output_Len,
    input [31:0]Matrix_Base_Addr,
    output done,
    
    input Output_FIFO_wr_en,
    input [31:0]Output_FIFO_din,

    input M02_AXI_ACLK,
    input M02_AXI_ARESETN,
    output [C_M_AXI_ID_WIDTH-1 : 0] M02_AXI_AWID,
    output [32-1 : 0] M02_AXI_AWADDR,
    output [7 : 0] M02_AXI_AWLEN,
    output [2 : 0] M02_AXI_AWSIZE,
    output [1 : 0] M02_AXI_AWBURST,
    output wire  M02_AXI_AWLOCK,
    output wire [3 : 0] M02_AXI_AWCACHE,
    output wire [2 : 0] M02_AXI_AWPROT,
    output wire [3 : 0] M02_AXI_AWQOS,
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M02_AXI_AWUSER,
    output wire  M02_AXI_AWVALID,
    input wire  M02_AXI_AWREADY,
    output wire [32-1 : 0] M02_AXI_WDATA,
    output wire [32/8-1 : 0] M02_AXI_WSTRB,
    output wire  M02_AXI_WLAST,
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M02_AXI_WUSER,
    output wire  M02_AXI_WVALID,
    input wire  M02_AXI_WREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M02_AXI_BID,
    input wire [1 : 0] M02_AXI_BRESP,
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M02_AXI_BUSER,
    input wire  M02_AXI_BVALID,
    output wire  M02_AXI_BREADY,
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M02_AXI_ARID,
    output wire [32-1 : 0] M02_AXI_ARADDR,
    output wire [7 : 0] M02_AXI_ARLEN,
    output wire [2 : 0] M02_AXI_ARSIZE,
    output wire [1 : 0] M02_AXI_ARBURST,
    output wire  M02_AXI_ARLOCK,
    output wire [3 : 0] M02_AXI_ARCACHE,
    output wire [2 : 0] M02_AXI_ARPROT,
    output wire [3 : 0] M02_AXI_ARQOS,
    output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M02_AXI_ARUSER,
    output wire  M02_AXI_ARVALID,
    input wire  M02_AXI_ARREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M02_AXI_RID,
    input wire [32-1 : 0] M02_AXI_RDATA,
    input wire [1 : 0] M02_AXI_RRESP,
    input wire  M02_AXI_RLAST,
    input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M02_AXI_RUSER,
    input wire  M02_AXI_RVALID,
    output wire  M02_AXI_RREADY
);

wire [Width_Len-1:0]write_len=Output_Len;
wire TX_FIFO_empty;
wire TX_FIFO_rd_en;
wire [31:0]TX_FIFO_dout;

wire write_done;
reg write_start;
reg [10:0]cnt;
always @(posedge clk or negedge rst_n)
    if(~rst_n)
        cnt<='d0;
    else
        if(Output_FIFO_wr_en)
            begin
                if(cnt==Output_Len)
                    cnt<='d0;
                else
                    cnt<=cnt+'d1;
            end
        

always @(posedge clk or negedge rst_n)
    if(~rst_n)
        write_start<=1'b0;
    else
        if((cnt==Output_Len) & (~write_start) )
            write_start<=1'b1;
        else
            if(write_done)
                write_start<=1'b0;
            

AXI_HP_Master_Transceiver i1
(
    .read_start(1'b0),
    .read_len('d0),
    .Read_BASE_ADDR(23'd0),
    .read_done(),
    
    .RX_FIFO_full(1'b0),
    .RX_FIFO_wr_en(),
    .RX_FIFO_din(),

    .write_start(write_start),
    .write_len(write_len),
    .Write_BASE_ADDR(Matrix_Base_Addr),
    .write_done(write_done),
    
    .TX_FIFO_empty(TX_FIFO_empty),
    .TX_FIFO_rd_en(TX_FIFO_rd_en),
    .TX_FIFO_dout(TX_FIFO_dout),
    
    .M_AXI_ACLK(M02_AXI_ACLK),
    .M_AXI_ARESETN(M02_AXI_ARESETN),
    .M_AXI_AWID(M02_AXI_AWID),
    .M_AXI_AWADDR(M02_AXI_AWADDR),
    .M_AXI_AWLEN(M02_AXI_AWLEN),
    .M_AXI_AWSIZE(M02_AXI_AWSIZE),
    .M_AXI_AWBURST(M02_AXI_AWBURST),
    .M_AXI_AWLOCK(M02_AXI_AWLOCK),
    .M_AXI_AWCACHE(M02_AXI_AWCACHE),
    .M_AXI_AWPROT(M02_AXI_AWPROT),
    .M_AXI_AWQOS(M02_AXI_AWQOS),
    .M_AXI_AWUSER(M02_AXI_AWUSER),
    .M_AXI_AWVALID(M02_AXI_AWVALID),
    .M_AXI_AWREADY(M02_AXI_AWREADY),
    .M_AXI_WDATA(M02_AXI_WDATA),
    .M_AXI_WSTRB(M02_AXI_WSTRB),
    .M_AXI_WLAST(M02_AXI_WLAST),
    .M_AXI_WUSER(M02_AXI_WUSER),
    .M_AXI_WVALID(M02_AXI_WVALID),
    .M_AXI_WREADY(M02_AXI_WREADY),
    .M_AXI_BID(M02_AXI_BID),
    .M_AXI_BRESP(M02_AXI_BRESP),
    .M_AXI_BUSER(M02_AXI_BUSER),
    .M_AXI_BVALID(M02_AXI_BVALID),
    .M_AXI_BREADY(M02_AXI_BREADY),
    .M_AXI_ARID(M02_AXI_ARID),
    .M_AXI_ARADDR(M02_AXI_ARADDR),
    .M_AXI_ARLEN(M02_AXI_ARLEN),
    .M_AXI_ARSIZE(M02_AXI_ARSIZE),
    .M_AXI_ARBURST(M02_AXI_ARBURST),
    .M_AXI_ARLOCK(M02_AXI_ARLOCK),
    .M_AXI_ARCACHE(M02_AXI_ARCACHE),
    .M_AXI_ARPROT(M02_AXI_ARPROT),
    .M_AXI_ARQOS(M02_AXI_ARQOS),
    .M_AXI_ARUSER(M02_AXI_ARUSER),
    .M_AXI_ARVALID(M02_AXI_ARVALID),
    .M_AXI_ARREADY(M02_AXI_ARREADY),
    .M_AXI_RID(M02_AXI_RID),
    .M_AXI_RDATA(M02_AXI_RDATA),
    .M_AXI_RRESP(M02_AXI_RRESP),
    .M_AXI_RLAST(M02_AXI_RLAST),
    .M_AXI_RUSER(M02_AXI_RUSER),
    .M_AXI_RVALID(M02_AXI_RVALID),
    .M_AXI_RREADY(M02_AXI_RREADY)
);

// FIFO write was delayed a clock 
reg output_reg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // reset
            output_reg <= 1'b0;
        end
        else begin
            output_reg <= Output_FIFO_wr_en;
        end
    end
    
fifo_dataout dout_fifo (
  .clk(clk),      // input wire clk
  .srst(~rst_n),    // input wire srst

  .din(Output_FIFO_din[15:0]),      // input wire [15 : 0] din
  .wr_en(output_reg),  // input wire wr_en
  .rd_en(TX_FIFO_rd_en),  // input wire rd_en
  .dout(TX_FIFO_dout[15:0]),    // output wire [15 : 0] dout
  .full(),    // output wire full
  .empty(TX_FIFO_empty)  // output wire empty
);

  
assign done = write_done;
    
endmodule
