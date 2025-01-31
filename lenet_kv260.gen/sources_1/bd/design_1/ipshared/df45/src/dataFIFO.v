`timescale 1ns / 1ps
module dataFIFO #
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
    input start,
    input [10:0]Featmap_Len,
    input [31:0]Matrix_Base_Addr,

    input RX_FIFO_rd_en,
    output RX_FIFO_empty,
    output [31:0]RX_FIFO_dout,
    output [9:0] din_count,

    input M00_AXI_ACLK,
    input M00_AXI_ARESETN,
    output [C_M_AXI_ID_WIDTH-1 : 0] M00_AXI_AWID,
    output [32-1 : 0] M00_AXI_AWADDR,
    output [7 : 0] M00_AXI_AWLEN,
    output [2 : 0] M00_AXI_AWSIZE,
    output [1 : 0] M00_AXI_AWBURST,
    output wire  M00_AXI_AWLOCK,
    output wire [3 : 0] M00_AXI_AWCACHE,
    output wire [2 : 0] M00_AXI_AWPROT,
    output wire [3 : 0] M00_AXI_AWQOS,
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M00_AXI_AWUSER,
    output wire  M00_AXI_AWVALID,
    input wire  M00_AXI_AWREADY,
    output wire [32-1 : 0] M00_AXI_WDATA,
    output wire [32/8-1 : 0] M00_AXI_WSTRB,
    output wire  M00_AXI_WLAST,
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M00_AXI_WUSER,
    output wire  M00_AXI_WVALID,
    input wire  M00_AXI_WREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M00_AXI_BID,
    input wire [1 : 0] M00_AXI_BRESP,
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M00_AXI_BUSER,
    input wire  M00_AXI_BVALID,
    output wire  M00_AXI_BREADY,
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M00_AXI_ARID,
    output wire [32-1 : 0] M00_AXI_ARADDR,
    output wire [7 : 0] M00_AXI_ARLEN,
    output wire [2 : 0] M00_AXI_ARSIZE,
    output wire [1 : 0] M00_AXI_ARBURST,
    output wire  M00_AXI_ARLOCK,
    output wire [3 : 0] M00_AXI_ARCACHE,
    output wire [2 : 0] M00_AXI_ARPROT,
    output wire [3 : 0] M00_AXI_ARQOS,
    output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M00_AXI_ARUSER,
    output wire  M00_AXI_ARVALID,
    input wire  M00_AXI_ARREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M00_AXI_RID,
    input wire [32-1 : 0] M00_AXI_RDATA,
    input wire [1 : 0] M00_AXI_RRESP,
    input wire  M00_AXI_RLAST,
    input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M00_AXI_RUSER,
    input wire  M00_AXI_RVALID,
    output wire  M00_AXI_RREADY
);

wire [Width_Len-1:0]read_len=Featmap_Len;
wire [31:0]RX_FIFO_din;
wire RX_FIFO_full;
wire RX_FIFO_wr_en;
//wire RX_FIFO_prog_empty;

reg read_start;
wire read_done;
reg [31:0]Read_BASE_ADDR;

reg [10:0]cnt;
reg state;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        cnt <= 'd0;
        read_start <= 1'b0;
        state <= 'd0;
        Read_BASE_ADDR <= Matrix_Base_Addr;
    end
    else begin
        case(state)
            'd0:
                if(start)
                begin
                    state <= 'd1;
                    Read_BASE_ADDR <= Matrix_Base_Addr;
                end
            'd1:
                if(cnt == 1) begin
                    cnt <= 'd0;
                    state <= 'd0;
                end
                else begin
                    if( (~read_start) ) begin
                        read_start <= 1'b1;
                    end
                    else if(read_done) begin
                        read_start <= 1'b0;
                        cnt <= cnt+'d1;
                    end
                    else begin
                        
                    end 
                end
        endcase
    end        
end

AXI_HP_Master_Transceiver i1
(
    .read_start(read_start),
    .read_len(read_len),
    .Read_BASE_ADDR(Read_BASE_ADDR),
    .read_done(read_done),
    
    .RX_FIFO_full(RX_FIFO_full),
    .RX_FIFO_wr_en(RX_FIFO_wr_en),
    .RX_FIFO_din(RX_FIFO_din),

    .write_start(1'b0),
    .write_len('b0),
    .Write_BASE_ADDR(32'd0),
    .write_done(),
    
    .TX_FIFO_empty(1'b0),
    .TX_FIFO_rd_en(),
    .TX_FIFO_dout(32'b0),
    
    .M_AXI_ACLK(M00_AXI_ACLK),
    .M_AXI_ARESETN(M00_AXI_ARESETN),
    .M_AXI_AWID(M00_AXI_AWID),
    .M_AXI_AWADDR(M00_AXI_AWADDR),
    .M_AXI_AWLEN(M00_AXI_AWLEN),
    .M_AXI_AWSIZE(M00_AXI_AWSIZE),
    .M_AXI_AWBURST(M00_AXI_AWBURST),
    .M_AXI_AWLOCK(M00_AXI_AWLOCK),
    .M_AXI_AWCACHE(M00_AXI_AWCACHE),
    .M_AXI_AWPROT(M00_AXI_AWPROT),
    .M_AXI_AWQOS(M00_AXI_AWQOS),
    .M_AXI_AWUSER(M00_AXI_AWUSER),
    .M_AXI_AWVALID(M00_AXI_AWVALID),
    .M_AXI_AWREADY(M00_AXI_AWREADY),
    .M_AXI_WDATA(M00_AXI_WDATA),
    .M_AXI_WSTRB(M00_AXI_WSTRB),
    .M_AXI_WLAST(M00_AXI_WLAST),
    .M_AXI_WUSER(M00_AXI_WUSER),
    .M_AXI_WVALID(M00_AXI_WVALID),
    .M_AXI_WREADY(M00_AXI_WREADY),
    .M_AXI_BID(M00_AXI_BID),
    .M_AXI_BRESP(M00_AXI_BRESP),
    .M_AXI_BUSER(M00_AXI_BUSER),
    .M_AXI_BVALID(M00_AXI_BVALID),
    .M_AXI_BREADY(M00_AXI_BREADY),
    .M_AXI_ARID(M00_AXI_ARID),
    .M_AXI_ARADDR(M00_AXI_ARADDR),
    .M_AXI_ARLEN(M00_AXI_ARLEN),
    .M_AXI_ARSIZE(M00_AXI_ARSIZE),
    .M_AXI_ARBURST(M00_AXI_ARBURST),
    .M_AXI_ARLOCK(M00_AXI_ARLOCK),
    .M_AXI_ARCACHE(M00_AXI_ARCACHE),
    .M_AXI_ARPROT(M00_AXI_ARPROT),
    .M_AXI_ARQOS(M00_AXI_ARQOS),
    .M_AXI_ARUSER(M00_AXI_ARUSER),
    .M_AXI_ARVALID(M00_AXI_ARVALID),
    .M_AXI_ARREADY(M00_AXI_ARREADY),
    .M_AXI_RID(M00_AXI_RID),
    .M_AXI_RDATA(M00_AXI_RDATA),
    .M_AXI_RRESP(M00_AXI_RRESP),
    .M_AXI_RLAST(M00_AXI_RLAST),
    .M_AXI_RUSER(M00_AXI_RUSER),
    .M_AXI_RVALID(M00_AXI_RVALID),
    .M_AXI_RREADY(M00_AXI_RREADY)
);


fifo_data din_fifo (
  .clk(clk),                // input wire clk
  .srst(~rst_n),    // input wire srst

  .din(RX_FIFO_din[15:0]),        // input wire [15 : 0] din
  .wr_en(RX_FIFO_wr_en),    // input wire wr_en
  .rd_en(RX_FIFO_rd_en),    // input wire rd_en
  .dout(RX_FIFO_dout[15:0]),      // output wire [15 : 0] dout
  .full(RX_FIFO_full),      // output wire full
  .empty(RX_FIFO_empty),    // output wire empty
  .data_count(din_count)
);


endmodule
