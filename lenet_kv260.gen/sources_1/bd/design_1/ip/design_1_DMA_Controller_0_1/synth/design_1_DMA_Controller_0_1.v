// (c) Copyright 1995-2024 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:DMA_Controller:1.0
// IP Revision: 3

(* X_CORE_INFO = "DMA_Controller,Vivado 2022.2" *)
(* CHECK_LICENSE_TYPE = "design_1_DMA_Controller_0_1,DMA_Controller,{}" *)
(* CORE_GENERATION_INFO = "design_1_DMA_Controller_0_1,DMA_Controller,{x_ipProduct=Vivado 2022.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=DMA_Controller,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,dwidth=16}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_DMA_Controller_0_1 (
  dout,
  dout_start,
  din_st,
  din,
  s00_axi_aclk,
  s00_axi_aresetn,
  s00_axi_awaddr,
  s00_axi_awprot,
  s00_axi_awvalid,
  s00_axi_awready,
  s00_axi_wdata,
  s00_axi_wstrb,
  s00_axi_wvalid,
  s00_axi_wready,
  s00_axi_bresp,
  s00_axi_bvalid,
  s00_axi_bready,
  s00_axi_araddr,
  s00_axi_arprot,
  s00_axi_arvalid,
  s00_axi_arready,
  s00_axi_rdata,
  s00_axi_rresp,
  s00_axi_rvalid,
  s00_axi_rready,
  M00_AXI_ACLK,
  M00_AXI_ARESETN,
  M00_AXI_AWID,
  M00_AXI_AWADDR,
  M00_AXI_AWLEN,
  M00_AXI_AWSIZE,
  M00_AXI_AWBURST,
  M00_AXI_AWLOCK,
  M00_AXI_AWCACHE,
  M00_AXI_AWPROT,
  M00_AXI_AWQOS,
  M00_AXI_AWUSER,
  M00_AXI_AWVALID,
  M00_AXI_AWREADY,
  M00_AXI_WDATA,
  M00_AXI_WSTRB,
  M00_AXI_WLAST,
  M00_AXI_WUSER,
  M00_AXI_WVALID,
  M00_AXI_WREADY,
  M00_AXI_BID,
  M00_AXI_BRESP,
  M00_AXI_BUSER,
  M00_AXI_BVALID,
  M00_AXI_BREADY,
  M00_AXI_ARID,
  M00_AXI_ARADDR,
  M00_AXI_ARLEN,
  M00_AXI_ARSIZE,
  M00_AXI_ARBURST,
  M00_AXI_ARLOCK,
  M00_AXI_ARCACHE,
  M00_AXI_ARPROT,
  M00_AXI_ARQOS,
  M00_AXI_ARUSER,
  M00_AXI_ARVALID,
  M00_AXI_ARREADY,
  M00_AXI_RID,
  M00_AXI_RDATA,
  M00_AXI_RRESP,
  M00_AXI_RLAST,
  M00_AXI_RUSER,
  M00_AXI_RVALID,
  M00_AXI_RREADY,
  M02_AXI_ACLK,
  M02_AXI_ARESETN,
  M02_AXI_AWID,
  M02_AXI_AWADDR,
  M02_AXI_AWLEN,
  M02_AXI_AWSIZE,
  M02_AXI_AWBURST,
  M02_AXI_AWLOCK,
  M02_AXI_AWCACHE,
  M02_AXI_AWPROT,
  M02_AXI_AWQOS,
  M02_AXI_AWUSER,
  M02_AXI_AWVALID,
  M02_AXI_AWREADY,
  M02_AXI_WDATA,
  M02_AXI_WSTRB,
  M02_AXI_WLAST,
  M02_AXI_WUSER,
  M02_AXI_WVALID,
  M02_AXI_WREADY,
  M02_AXI_BID,
  M02_AXI_BRESP,
  M02_AXI_BUSER,
  M02_AXI_BVALID,
  M02_AXI_BREADY,
  M02_AXI_ARID,
  M02_AXI_ARADDR,
  M02_AXI_ARLEN,
  M02_AXI_ARSIZE,
  M02_AXI_ARBURST,
  M02_AXI_ARLOCK,
  M02_AXI_ARCACHE,
  M02_AXI_ARPROT,
  M02_AXI_ARQOS,
  M02_AXI_ARUSER,
  M02_AXI_ARVALID,
  M02_AXI_ARREADY,
  M02_AXI_RID,
  M02_AXI_RDATA,
  M02_AXI_RRESP,
  M02_AXI_RLAST,
  M02_AXI_RUSER,
  M02_AXI_RVALID,
  M02_AXI_RREADY
);

input wire [15 : 0] dout;
input wire dout_start;
output wire din_st;
output wire [15 : 0] din;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s00_axi_aclk, ASSOCIATED_BUSIF s00_axi, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s00_axi_aclk CLK" *)
input wire s00_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s00_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s00_axi_aresetn RST" *)
input wire s00_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi AWADDR" *)
input wire [4 : 0] s00_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi AWPROT" *)
input wire [2 : 0] s00_axi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi AWVALID" *)
input wire s00_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi AWREADY" *)
output wire s00_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi WDATA" *)
input wire [31 : 0] s00_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi WSTRB" *)
input wire [3 : 0] s00_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi WVALID" *)
input wire s00_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi WREADY" *)
output wire s00_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi BRESP" *)
output wire [1 : 0] s00_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi BVALID" *)
output wire s00_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi BREADY" *)
input wire s00_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi ARADDR" *)
input wire [4 : 0] s00_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi ARPROT" *)
input wire [2 : 0] s00_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi ARVALID" *)
input wire s00_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi ARREADY" *)
output wire s00_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi RDATA" *)
output wire [31 : 0] s00_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi RRESP" *)
output wire [1 : 0] s00_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi RVALID" *)
output wire s00_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s00_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999001, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 4, NU\
M_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s00_axi RREADY" *)
input wire s00_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ACLK, ASSOCIATED_BUSIF M00_AXI, ASSOCIATED_RESET M00_AXI_ARESETN, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M00_AXI_ACLK CLK" *)
input wire M00_AXI_ACLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M00_AXI_ARESETN RST" *)
input wire M00_AXI_ARESETN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWID" *)
output wire [0 : 0] M00_AXI_AWID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWADDR" *)
output wire [31 : 0] M00_AXI_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWLEN" *)
output wire [7 : 0] M00_AXI_AWLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWSIZE" *)
output wire [2 : 0] M00_AXI_AWSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWBURST" *)
output wire [1 : 0] M00_AXI_AWBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWLOCK" *)
output wire M00_AXI_AWLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWCACHE" *)
output wire [3 : 0] M00_AXI_AWCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWPROT" *)
output wire [2 : 0] M00_AXI_AWPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWQOS" *)
output wire [3 : 0] M00_AXI_AWQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWUSER" *)
output wire [0 : 0] M00_AXI_AWUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWVALID" *)
output wire M00_AXI_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWREADY" *)
input wire M00_AXI_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WDATA" *)
output wire [31 : 0] M00_AXI_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WSTRB" *)
output wire [3 : 0] M00_AXI_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WLAST" *)
output wire M00_AXI_WLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WUSER" *)
output wire [0 : 0] M00_AXI_WUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WVALID" *)
output wire M00_AXI_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WREADY" *)
input wire M00_AXI_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BID" *)
input wire [0 : 0] M00_AXI_BID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BRESP" *)
input wire [1 : 0] M00_AXI_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BUSER" *)
input wire [0 : 0] M00_AXI_BUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BVALID" *)
input wire M00_AXI_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BREADY" *)
output wire M00_AXI_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARID" *)
output wire [0 : 0] M00_AXI_ARID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARADDR" *)
output wire [31 : 0] M00_AXI_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARLEN" *)
output wire [7 : 0] M00_AXI_ARLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARSIZE" *)
output wire [2 : 0] M00_AXI_ARSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARBURST" *)
output wire [1 : 0] M00_AXI_ARBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARLOCK" *)
output wire M00_AXI_ARLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARCACHE" *)
output wire [3 : 0] M00_AXI_ARCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARPROT" *)
output wire [2 : 0] M00_AXI_ARPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARQOS" *)
output wire [3 : 0] M00_AXI_ARQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARUSER" *)
output wire [0 : 0] M00_AXI_ARUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARVALID" *)
output wire M00_AXI_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARREADY" *)
input wire M00_AXI_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RID" *)
input wire [0 : 0] M00_AXI_RID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RDATA" *)
input wire [31 : 0] M00_AXI_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RRESP" *)
input wire [1 : 0] M00_AXI_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RLAST" *)
input wire M00_AXI_RLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RUSER" *)
input wire [0 : 0] M00_AXI_RUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RVALID" *)
input wire M00_AXI_RVALID;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 99999001, ID_WIDTH 1, ADDR_WIDTH 32, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 1, RUSER_WIDTH 1, BUSER_WIDTH 1, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM\
_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RREADY" *)
output wire M00_AXI_RREADY;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M02_AXI_ACLK, ASSOCIATED_BUSIF M02_AXI, ASSOCIATED_RESET M02_AXI_ARESETN, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M02_AXI_ACLK CLK" *)
input wire M02_AXI_ACLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M02_AXI_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M02_AXI_ARESETN RST" *)
input wire M02_AXI_ARESETN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWID" *)
output wire [0 : 0] M02_AXI_AWID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWADDR" *)
output wire [31 : 0] M02_AXI_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWLEN" *)
output wire [7 : 0] M02_AXI_AWLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWSIZE" *)
output wire [2 : 0] M02_AXI_AWSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWBURST" *)
output wire [1 : 0] M02_AXI_AWBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWLOCK" *)
output wire M02_AXI_AWLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWCACHE" *)
output wire [3 : 0] M02_AXI_AWCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWPROT" *)
output wire [2 : 0] M02_AXI_AWPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWQOS" *)
output wire [3 : 0] M02_AXI_AWQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWUSER" *)
output wire [0 : 0] M02_AXI_AWUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWVALID" *)
output wire M02_AXI_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI AWREADY" *)
input wire M02_AXI_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WDATA" *)
output wire [31 : 0] M02_AXI_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WSTRB" *)
output wire [3 : 0] M02_AXI_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WLAST" *)
output wire M02_AXI_WLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WUSER" *)
output wire [0 : 0] M02_AXI_WUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WVALID" *)
output wire M02_AXI_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI WREADY" *)
input wire M02_AXI_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI BID" *)
input wire [0 : 0] M02_AXI_BID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI BRESP" *)
input wire [1 : 0] M02_AXI_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI BUSER" *)
input wire [0 : 0] M02_AXI_BUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI BVALID" *)
input wire M02_AXI_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI BREADY" *)
output wire M02_AXI_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARID" *)
output wire [0 : 0] M02_AXI_ARID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARADDR" *)
output wire [31 : 0] M02_AXI_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARLEN" *)
output wire [7 : 0] M02_AXI_ARLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARSIZE" *)
output wire [2 : 0] M02_AXI_ARSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARBURST" *)
output wire [1 : 0] M02_AXI_ARBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARLOCK" *)
output wire M02_AXI_ARLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARCACHE" *)
output wire [3 : 0] M02_AXI_ARCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARPROT" *)
output wire [2 : 0] M02_AXI_ARPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARQOS" *)
output wire [3 : 0] M02_AXI_ARQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARUSER" *)
output wire [0 : 0] M02_AXI_ARUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARVALID" *)
output wire M02_AXI_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI ARREADY" *)
input wire M02_AXI_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RID" *)
input wire [0 : 0] M02_AXI_RID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RDATA" *)
input wire [31 : 0] M02_AXI_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RRESP" *)
input wire [1 : 0] M02_AXI_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RLAST" *)
input wire M02_AXI_RLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RUSER" *)
input wire [0 : 0] M02_AXI_RUSER;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RVALID" *)
input wire M02_AXI_RVALID;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M02_AXI, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 99999001, ID_WIDTH 1, ADDR_WIDTH 32, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 1, RUSER_WIDTH 1, BUSER_WIDTH 1, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM\
_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M02_AXI RREADY" *)
output wire M02_AXI_RREADY;

  DMA_Controller #(
    .dwidth(16)
  ) inst (
    .dout(dout),
    .dout_start(dout_start),
    .din_st(din_st),
    .din(din),
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),
    .M00_AXI_ACLK(M00_AXI_ACLK),
    .M00_AXI_ARESETN(M00_AXI_ARESETN),
    .M00_AXI_AWID(M00_AXI_AWID),
    .M00_AXI_AWADDR(M00_AXI_AWADDR),
    .M00_AXI_AWLEN(M00_AXI_AWLEN),
    .M00_AXI_AWSIZE(M00_AXI_AWSIZE),
    .M00_AXI_AWBURST(M00_AXI_AWBURST),
    .M00_AXI_AWLOCK(M00_AXI_AWLOCK),
    .M00_AXI_AWCACHE(M00_AXI_AWCACHE),
    .M00_AXI_AWPROT(M00_AXI_AWPROT),
    .M00_AXI_AWQOS(M00_AXI_AWQOS),
    .M00_AXI_AWUSER(M00_AXI_AWUSER),
    .M00_AXI_AWVALID(M00_AXI_AWVALID),
    .M00_AXI_AWREADY(M00_AXI_AWREADY),
    .M00_AXI_WDATA(M00_AXI_WDATA),
    .M00_AXI_WSTRB(M00_AXI_WSTRB),
    .M00_AXI_WLAST(M00_AXI_WLAST),
    .M00_AXI_WUSER(M00_AXI_WUSER),
    .M00_AXI_WVALID(M00_AXI_WVALID),
    .M00_AXI_WREADY(M00_AXI_WREADY),
    .M00_AXI_BID(M00_AXI_BID),
    .M00_AXI_BRESP(M00_AXI_BRESP),
    .M00_AXI_BUSER(M00_AXI_BUSER),
    .M00_AXI_BVALID(M00_AXI_BVALID),
    .M00_AXI_BREADY(M00_AXI_BREADY),
    .M00_AXI_ARID(M00_AXI_ARID),
    .M00_AXI_ARADDR(M00_AXI_ARADDR),
    .M00_AXI_ARLEN(M00_AXI_ARLEN),
    .M00_AXI_ARSIZE(M00_AXI_ARSIZE),
    .M00_AXI_ARBURST(M00_AXI_ARBURST),
    .M00_AXI_ARLOCK(M00_AXI_ARLOCK),
    .M00_AXI_ARCACHE(M00_AXI_ARCACHE),
    .M00_AXI_ARPROT(M00_AXI_ARPROT),
    .M00_AXI_ARQOS(M00_AXI_ARQOS),
    .M00_AXI_ARUSER(M00_AXI_ARUSER),
    .M00_AXI_ARVALID(M00_AXI_ARVALID),
    .M00_AXI_ARREADY(M00_AXI_ARREADY),
    .M00_AXI_RID(M00_AXI_RID),
    .M00_AXI_RDATA(M00_AXI_RDATA),
    .M00_AXI_RRESP(M00_AXI_RRESP),
    .M00_AXI_RLAST(M00_AXI_RLAST),
    .M00_AXI_RUSER(M00_AXI_RUSER),
    .M00_AXI_RVALID(M00_AXI_RVALID),
    .M00_AXI_RREADY(M00_AXI_RREADY),
    .M02_AXI_ACLK(M02_AXI_ACLK),
    .M02_AXI_ARESETN(M02_AXI_ARESETN),
    .M02_AXI_AWID(M02_AXI_AWID),
    .M02_AXI_AWADDR(M02_AXI_AWADDR),
    .M02_AXI_AWLEN(M02_AXI_AWLEN),
    .M02_AXI_AWSIZE(M02_AXI_AWSIZE),
    .M02_AXI_AWBURST(M02_AXI_AWBURST),
    .M02_AXI_AWLOCK(M02_AXI_AWLOCK),
    .M02_AXI_AWCACHE(M02_AXI_AWCACHE),
    .M02_AXI_AWPROT(M02_AXI_AWPROT),
    .M02_AXI_AWQOS(M02_AXI_AWQOS),
    .M02_AXI_AWUSER(M02_AXI_AWUSER),
    .M02_AXI_AWVALID(M02_AXI_AWVALID),
    .M02_AXI_AWREADY(M02_AXI_AWREADY),
    .M02_AXI_WDATA(M02_AXI_WDATA),
    .M02_AXI_WSTRB(M02_AXI_WSTRB),
    .M02_AXI_WLAST(M02_AXI_WLAST),
    .M02_AXI_WUSER(M02_AXI_WUSER),
    .M02_AXI_WVALID(M02_AXI_WVALID),
    .M02_AXI_WREADY(M02_AXI_WREADY),
    .M02_AXI_BID(M02_AXI_BID),
    .M02_AXI_BRESP(M02_AXI_BRESP),
    .M02_AXI_BUSER(M02_AXI_BUSER),
    .M02_AXI_BVALID(M02_AXI_BVALID),
    .M02_AXI_BREADY(M02_AXI_BREADY),
    .M02_AXI_ARID(M02_AXI_ARID),
    .M02_AXI_ARADDR(M02_AXI_ARADDR),
    .M02_AXI_ARLEN(M02_AXI_ARLEN),
    .M02_AXI_ARSIZE(M02_AXI_ARSIZE),
    .M02_AXI_ARBURST(M02_AXI_ARBURST),
    .M02_AXI_ARLOCK(M02_AXI_ARLOCK),
    .M02_AXI_ARCACHE(M02_AXI_ARCACHE),
    .M02_AXI_ARPROT(M02_AXI_ARPROT),
    .M02_AXI_ARQOS(M02_AXI_ARQOS),
    .M02_AXI_ARUSER(M02_AXI_ARUSER),
    .M02_AXI_ARVALID(M02_AXI_ARVALID),
    .M02_AXI_ARREADY(M02_AXI_ARREADY),
    .M02_AXI_RID(M02_AXI_RID),
    .M02_AXI_RDATA(M02_AXI_RDATA),
    .M02_AXI_RRESP(M02_AXI_RRESP),
    .M02_AXI_RLAST(M02_AXI_RLAST),
    .M02_AXI_RUSER(M02_AXI_RUSER),
    .M02_AXI_RVALID(M02_AXI_RVALID),
    .M02_AXI_RREADY(M02_AXI_RREADY)
  );
endmodule
