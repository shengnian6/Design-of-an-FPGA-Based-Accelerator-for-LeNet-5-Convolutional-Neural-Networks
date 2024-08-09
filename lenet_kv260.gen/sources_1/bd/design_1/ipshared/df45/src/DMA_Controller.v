`timescale 1ns / 1ps
module DMA_Controller #
(
    localparam C_S00_AXI_DATA_WIDTH = 32,
    localparam C_S00_AXI_ADDR_WIDTH = 5,
    localparam Width_Len            =11,
    localparam C_M_AXI_ID_WIDTH     = 1,
    localparam C_M_AXI_AWUSER_WIDTH = 0,
    localparam C_M_AXI_ARUSER_WIDTH = 0,
    localparam C_M_AXI_WUSER_WIDTH  = 0,
    localparam C_M_AXI_RUSER_WIDTH  = 0,
    localparam C_M_AXI_BUSER_WIDTH  = 0,

    parameter dwidth = 16
)
(
    // ConvPE ports
    input wire [dwidth-1:0] dout,
    input wire dout_start,

    output wire din_st,
    output wire signed [dwidth-1:0] din,
    // output wire signed [dwidth-1:0] weight,
    // output wire signed [dwidth-1:0] bias,
 
    // debug

    // Ports of Axi Slave Bus Interface S00_AXI
    input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire [2 : 0] s00_axi_awprot,
    input wire  s00_axi_awvalid,
    output wire  s00_axi_awready,
    input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire  s00_axi_wvalid,
    output wire  s00_axi_wready,
    output wire [1 : 0] s00_axi_bresp,
    output wire  s00_axi_bvalid,
    input wire  s00_axi_bready,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire [2 : 0] s00_axi_arprot,
    input wire  s00_axi_arvalid,
    output wire  s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire  s00_axi_rvalid,
    input wire  s00_axi_rready,
    
    // Ports of Axi Master Bus Interface M00_AXI
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
    output wire  M00_AXI_RREADY,
    
    
    // Ports of Axi Master Bus Interface M02_AXI
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

wire data_FIFO_empty;
wire [9:0] din_count;
reg Input_FIFO_rd_en_reg;
wire Input_FIFO_rd_en;

always @(posedge M00_AXI_ACLK or negedge M00_AXI_ARESETN) begin
    if (!M00_AXI_ARESETN) begin
        // reset
        Input_FIFO_rd_en_reg <= 1'b0;
    end
    else if (din_count > 'd120 && Input_FIFO_rd_en == 1'b0) begin
        Input_FIFO_rd_en_reg <= 1'b1;
    end
    else if (din_count == 'd0 && Input_FIFO_rd_en == 1'b1) begin
        Input_FIFO_rd_en_reg <= 1'b0;
    end
    else begin
        Input_FIFO_rd_en_reg <= Input_FIFO_rd_en_reg;
    end
end

assign Input_FIFO_rd_en = Input_FIFO_rd_en_reg;

// din_st delay 1 clock
// reg din_st_reg;
// always @(posedge M00_AXI_ACLK or negedge M00_AXI_ARESETN) begin
//     if (!M00_AXI_ARESETN) begin
//         // reset
//         din_st_reg <= 'd0;
//     end
//     else begin
//        din_st_reg  <= Input_FIFO_rd_en; 
//     end
// end

assign din_st = Input_FIFO_rd_en;

/****** Module Statement *******/ 
wire done;
wire start;
wire [10:0]Featmap_Len;
wire [10:0]Output_Len;
wire [31:0]Data_Base_Addr;
// wire [31:0]Weight_Base_Addr;
wire [31:0]Out_Base_Addr;

wire [2*dwidth-1:0] din_org;
// wire [2*dwidth-1:0] weight_org;
wire [2*dwidth-1:0] dout_org;

// Controller
Controller inst_Controller(

    // User ports
    .start(start),         // output
    .done(done),           // input

    .Featmap_Len(Featmap_Len),
    .Output_Len(Output_Len),
    .Data_Base_Addr(Data_Base_Addr),
    // .Weight_Base_Addr(Weight_Base_Addr),
    .Out_Base_Addr(Out_Base_Addr),
    // End

    .S_AXI_ACLK(s00_axi_aclk),
    .S_AXI_ARESETN(s00_axi_aresetn),
    .S_AXI_AWADDR(s00_axi_awaddr),
    .S_AXI_AWPROT(s00_axi_awprot),
    .S_AXI_AWVALID(s00_axi_awvalid),
    .S_AXI_AWREADY(s00_axi_awready),
    .S_AXI_WDATA(s00_axi_wdata),
    .S_AXI_WSTRB(s00_axi_wstrb),
    .S_AXI_WVALID(s00_axi_wvalid),
    .S_AXI_WREADY(s00_axi_wready),
    .S_AXI_BRESP(s00_axi_bresp),
    .S_AXI_BVALID(s00_axi_bvalid),
    .S_AXI_BREADY(s00_axi_bready),
    .S_AXI_ARADDR(s00_axi_araddr),
    .S_AXI_ARPROT(s00_axi_arprot),
    .S_AXI_ARVALID(s00_axi_arvalid),
    .S_AXI_ARREADY(s00_axi_arready),
    .S_AXI_RDATA(s00_axi_rdata),
    .S_AXI_RRESP(s00_axi_rresp),
    .S_AXI_RVALID(s00_axi_rvalid),
    .S_AXI_RREADY(s00_axi_rready)
);

// data FIFO
dataFIFO inst_dataFIFO (

    // User ports
    .clk(M00_AXI_ACLK),
    .rst_n(M00_AXI_ARESETN),
    .start            (start),
    .Featmap_Len      (Featmap_Len),
    .Matrix_Base_Addr (Data_Base_Addr),
    .RX_FIFO_rd_en    (Input_FIFO_rd_en),

    .din_count        (din_count),
    .RX_FIFO_empty    (data_FIFO_empty),
    .RX_FIFO_dout     (din_org),
    // End

    .M00_AXI_ACLK     (M00_AXI_ACLK),
    .M00_AXI_ARESETN  (M00_AXI_ARESETN),
    .M00_AXI_AWID     (M00_AXI_AWID),
    .M00_AXI_AWADDR   (M00_AXI_AWADDR),
    .M00_AXI_AWLEN    (M00_AXI_AWLEN),
    .M00_AXI_AWSIZE   (M00_AXI_AWSIZE),
    .M00_AXI_AWBURST  (M00_AXI_AWBURST),
    .M00_AXI_AWLOCK   (M00_AXI_AWLOCK),
    .M00_AXI_AWCACHE  (M00_AXI_AWCACHE),
    .M00_AXI_AWPROT   (M00_AXI_AWPROT),
    .M00_AXI_AWQOS    (M00_AXI_AWQOS),
    .M00_AXI_AWUSER   (M00_AXI_AWUSER),
    .M00_AXI_AWVALID  (M00_AXI_AWVALID),
    .M00_AXI_AWREADY  (M00_AXI_AWREADY),
    .M00_AXI_WDATA    (M00_AXI_WDATA),
    .M00_AXI_WSTRB    (M00_AXI_WSTRB),
    .M00_AXI_WLAST    (M00_AXI_WLAST),
    .M00_AXI_WUSER    (M00_AXI_WUSER),
    .M00_AXI_WVALID   (M00_AXI_WVALID),
    .M00_AXI_WREADY   (M00_AXI_WREADY),
    .M00_AXI_BID      (M00_AXI_BID),
    .M00_AXI_BRESP    (M00_AXI_BRESP),
    .M00_AXI_BUSER    (M00_AXI_BUSER),
    .M00_AXI_BVALID   (M00_AXI_BVALID),
    .M00_AXI_BREADY   (M00_AXI_BREADY),
    .M00_AXI_ARID     (M00_AXI_ARID),
    .M00_AXI_ARADDR   (M00_AXI_ARADDR),
    .M00_AXI_ARLEN    (M00_AXI_ARLEN),
    .M00_AXI_ARSIZE   (M00_AXI_ARSIZE),
    .M00_AXI_ARBURST  (M00_AXI_ARBURST),
    .M00_AXI_ARLOCK   (M00_AXI_ARLOCK),
    .M00_AXI_ARCACHE  (M00_AXI_ARCACHE),
    .M00_AXI_ARPROT   (M00_AXI_ARPROT),
    .M00_AXI_ARQOS    (M00_AXI_ARQOS),
    .M00_AXI_ARUSER   (M00_AXI_ARUSER),
    .M00_AXI_ARVALID  (M00_AXI_ARVALID),
    .M00_AXI_ARREADY  (M00_AXI_ARREADY),
    .M00_AXI_RID      (M00_AXI_RID),
    .M00_AXI_RDATA    (M00_AXI_RDATA),
    .M00_AXI_RRESP    (M00_AXI_RRESP),
    .M00_AXI_RLAST    (M00_AXI_RLAST),
    .M00_AXI_RUSER    (M00_AXI_RUSER),
    .M00_AXI_RVALID   (M00_AXI_RVALID),
    .M00_AXI_RREADY   (M00_AXI_RREADY)
);


// Output FIFO
OutputFIFO inst_OutputFIFO (
    
    // User ports
    .clk(M00_AXI_ACLK),
    .rst_n(M00_AXI_ARESETN),
    .Output_Len        (Output_Len),
    .Matrix_Base_Addr  (Out_Base_Addr),
    .Output_FIFO_wr_en (dout_start),
    .Output_FIFO_din   (dout_org),

    .done              (done),
    // End

    .M02_AXI_ACLK      (M02_AXI_ACLK),
    .M02_AXI_ARESETN   (M02_AXI_ARESETN),
    .M02_AXI_AWID      (M02_AXI_AWID),
    .M02_AXI_AWADDR    (M02_AXI_AWADDR),
    .M02_AXI_AWLEN     (M02_AXI_AWLEN),
    .M02_AXI_AWSIZE    (M02_AXI_AWSIZE),
    .M02_AXI_AWBURST   (M02_AXI_AWBURST),
    .M02_AXI_AWLOCK    (M02_AXI_AWLOCK),
    .M02_AXI_AWCACHE   (M02_AXI_AWCACHE),
    .M02_AXI_AWPROT    (M02_AXI_AWPROT),
    .M02_AXI_AWQOS     (M02_AXI_AWQOS),
    .M02_AXI_AWUSER    (M02_AXI_AWUSER),
    .M02_AXI_AWVALID   (M02_AXI_AWVALID),
    .M02_AXI_AWREADY   (M02_AXI_AWREADY),
    .M02_AXI_WDATA     (M02_AXI_WDATA),
    .M02_AXI_WSTRB     (M02_AXI_WSTRB),
    .M02_AXI_WLAST     (M02_AXI_WLAST),
    .M02_AXI_WUSER     (M02_AXI_WUSER),
    .M02_AXI_WVALID    (M02_AXI_WVALID),
    .M02_AXI_WREADY    (M02_AXI_WREADY),
    .M02_AXI_BID       (M02_AXI_BID),
    .M02_AXI_BRESP     (M02_AXI_BRESP),
    .M02_AXI_BUSER     (M02_AXI_BUSER),
    .M02_AXI_BVALID    (M02_AXI_BVALID),
    .M02_AXI_BREADY    (M02_AXI_BREADY),
    .M02_AXI_ARID      (M02_AXI_ARID),
    .M02_AXI_ARADDR    (M02_AXI_ARADDR),
    .M02_AXI_ARLEN     (M02_AXI_ARLEN),
    .M02_AXI_ARSIZE    (M02_AXI_ARSIZE),
    .M02_AXI_ARBURST   (M02_AXI_ARBURST),
    .M02_AXI_ARLOCK    (M02_AXI_ARLOCK),
    .M02_AXI_ARCACHE   (M02_AXI_ARCACHE),
    .M02_AXI_ARPROT    (M02_AXI_ARPROT),
    .M02_AXI_ARQOS     (M02_AXI_ARQOS),
    .M02_AXI_ARUSER    (M02_AXI_ARUSER),
    .M02_AXI_ARVALID   (M02_AXI_ARVALID),
    .M02_AXI_ARREADY   (M02_AXI_ARREADY),
    .M02_AXI_RID       (M02_AXI_RID),
    .M02_AXI_RDATA     (M02_AXI_RDATA),
    .M02_AXI_RRESP     (M02_AXI_RRESP),
    .M02_AXI_RLAST     (M02_AXI_RLAST),
    .M02_AXI_RUSER     (M02_AXI_RUSER),
    .M02_AXI_RVALID    (M02_AXI_RVALID),
    .M02_AXI_RREADY    (M02_AXI_RREADY)
);



assign din = $signed(din_org[15:0]);
assign dout_org[15:0] = $unsigned(dout);

endmodule
