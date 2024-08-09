`timescale 1ns / 1ps
module AXI_HP_Master_Transceiver #
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
    //****** self-definition IO *******
    
    // control IO (start-done)
    // read:  reg0 (start-done) reg1 (length) reg2 (address)
    // write: reg3 (start-done) reg4 (length) reg5 (address)
    
    input read_start,               // read start
    input [Width_Len-1:0]read_len,  // data length
    input [32-1:0]Read_BASE_ADDR,   // data address
    output reg read_done,           // read done
    
    input write_start,
    input [Width_Len-1:0]write_len,
    input [32-1:0]Write_BASE_ADDR,
    output reg write_done,
    
    // FIFO IO
    input RX_FIFO_full,                 
    output RX_FIFO_wr_en,           
    output [32-1:0]RX_FIFO_din,     // data in
    
    input TX_FIFO_empty,
    output TX_FIFO_rd_en,
    input [32-1:0]TX_FIFO_dout,     // data out
    
    //********* end *********
    
    input M_AXI_ACLK,
    input M_AXI_ARESETN,
    output [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
    output [32-1 : 0] M_AXI_AWADDR,
    output [7 : 0] M_AXI_AWLEN,
    output [2 : 0] M_AXI_AWSIZE,
    output [1 : 0] M_AXI_AWBURST,
    output wire  M_AXI_AWLOCK,
    output wire [3 : 0] M_AXI_AWCACHE,
    output wire [2 : 0] M_AXI_AWPROT,
    output wire [3 : 0] M_AXI_AWQOS,
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
    output wire  M_AXI_AWVALID,
    input wire  M_AXI_AWREADY,
    output wire [32-1 : 0] M_AXI_WDATA,
    output wire [32/8-1 : 0] M_AXI_WSTRB,
    output wire  M_AXI_WLAST,
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
    output wire  M_AXI_WVALID,
    input wire  M_AXI_WREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
    input wire [1 : 0] M_AXI_BRESP,
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
    input wire  M_AXI_BVALID,
    output wire  M_AXI_BREADY,
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
    output wire [32-1 : 0] M_AXI_ARADDR,
    output wire [7 : 0] M_AXI_ARLEN,
    output wire [2 : 0] M_AXI_ARSIZE,
    output wire [1 : 0] M_AXI_ARBURST,
    output wire  M_AXI_ARLOCK,
    output wire [3 : 0] M_AXI_ARCACHE,
    output wire [2 : 0] M_AXI_ARPROT,
    output wire [3 : 0] M_AXI_ARQOS,
    output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
    output wire  M_AXI_ARVALID,
    input wire  M_AXI_ARREADY,
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
    input wire [32-1 : 0] M_AXI_RDATA,
    input wire [1 : 0] M_AXI_RRESP,
    input wire  M_AXI_RLAST,
    input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
    input wire  M_AXI_RVALID,
    output wire  M_AXI_RREADY
);

reg [1:0]read_start_pre;
always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )  
    read_start_pre<=2'b11;
else
    read_start_pre<={read_start_pre[0],read_start};
wire read_start_pos=read_start_pre[0]&(~read_start_pre[1]);   

reg [1:0]write_start_pre;
always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )    
    write_start_pre<=2'b11;
else
    write_start_pre<={write_start_pre[0],write_start};
wire write_start_pos=write_start_pre[0]&(~write_start_pre[1]);

reg [2:0]read_state;
reg [Width_Len-1:0]read_len_r;
reg [8:0]read_burst_len;
reg [31:0]Read_addr;
reg burst_read_start;
wire burst_read_done;
always @(posedge M_AXI_ACLK)
if (M_AXI_ARESETN == 1'b0 )  
    begin
        read_done<=1'b0;
        read_state<='d0;
        Read_addr<='d0;
        read_burst_len<='d0;
        read_len_r<='d0;
        burst_read_start<=1'b0;
    end
else
    case(read_state)
        'd0:
            begin
                read_done<=1'b0;
                if(read_start_pos)
                begin
                    read_state<='d1;
                    read_len_r<=read_len;
                    Read_addr<=Read_BASE_ADDR;
                end
            end
        'd1:
            if(read_len_r==0)
                begin
                    read_state<='d4;
                end
            else          
                if(read_len_r[Width_Len-1:8]!=0)
                    read_state<='d2;
                else
                    read_state<='d3;
        'd2:
            if(~burst_read_done)
                begin
                    burst_read_start<=1'b1;
                    read_burst_len<=9'd256;
                end
            else
                begin
                    burst_read_start<=1'b0;
                    read_state<='d1;
                    read_len_r[Width_Len-1:8]<=read_len_r[Width_Len-1:8]-'d1;
                    Read_addr<=Read_addr+32'd1024;
                end
        'd3:
            if(~burst_read_done)
                begin
                    burst_read_start<=1'b1;
                    read_burst_len<={1'b0,read_len_r[7:0]};
                end
            else
                begin
                    burst_read_start<=1'b0;
                    read_len_r<='d0;
                    read_state<='d1;
                end
        'd4:
            begin
                read_done<=1'b1;
                read_state<='d0;
            end
    endcase
    
reg [2:0]write_state;
reg [Width_Len-1:0]write_len_r;
reg [8:0]write_burst_len;
reg [31:0]Write_addr;
reg burst_write_start;
wire burst_write_done;
always @(posedge M_AXI_ACLK)
if (M_AXI_ARESETN == 1'b0 )  
    begin
        write_done<=1'b0;
        write_state<='d0;
        Write_addr<='d0;
        write_burst_len<='d0;
        write_len_r<='d0;
        burst_write_start<=1'b0;
    end
else
    case(write_state)
        'd0:
            begin
                write_done<=1'b0;
                if(write_start_pos)
                begin
                    write_state<='d1;
                    write_len_r<=write_len;
                    Write_addr<=Write_BASE_ADDR;
                end
            end
        'd1:
            if(write_len_r==0)
                begin
                    write_state<='d4;
                end
            else          
                if(write_len_r[Width_Len-1:8]!=0)
                    write_state<='d2;
                else
                    write_state<='d3;
        'd2:
            if(~burst_write_done)
                begin
                    burst_write_start<=1'b1;
                    write_burst_len<=9'd256;
                end
            else
                begin
                    burst_write_start<=1'b0;
                    write_state<='d1;
                    write_len_r[Width_Len-1:8]<=write_len_r[Width_Len-1:8]-'d1;
                    Write_addr<=Write_addr+32'd1024;
                end
        'd3:
            if(~burst_write_done)
                begin
                    burst_write_start<=1'b1;
                    write_burst_len<={1'b0,write_len_r[7:0]};
                end
            else
                begin
                    burst_write_start<=1'b0;
                    write_len_r<='d0;
                    write_state<='d1;
                end
        'd4:
            begin
                write_done<=1'b1;
                write_state<='d0;
            end
    endcase

// Burst Transfer Mode
AXI_HP_Master_Burst_Transceiver i1
(
    .read_start(burst_read_start),
    ._read_burst_len(read_burst_len),
    .Read_BASE_ADDR(Read_addr),
    .read_done(burst_read_done),

    .RX_FIFO_full(RX_FIFO_full),
    .RX_FIFO_wr_en(RX_FIFO_wr_en),
    .RX_FIFO_din(RX_FIFO_din),

    .write_start(burst_write_start),
    ._write_burst_len(write_burst_len),
    .Write_BASE_ADDR(Write_addr),
    .write_done(burst_write_done),
    
    .TX_FIFO_empty(TX_FIFO_empty),
    .TX_FIFO_rd_en(TX_FIFO_rd_en),
    .TX_FIFO_dout(TX_FIFO_dout),

    .M_AXI_ACLK(M_AXI_ACLK),
    .M_AXI_ARESETN(M_AXI_ARESETN),
    .M_AXI_AWID(M_AXI_AWID),
    .M_AXI_AWADDR(M_AXI_AWADDR),
    .M_AXI_AWLEN(M_AXI_AWLEN),
    .M_AXI_AWSIZE(M_AXI_AWSIZE),
    .M_AXI_AWBURST(M_AXI_AWBURST),
    .M_AXI_AWLOCK(M_AXI_AWLOCK),
    .M_AXI_AWCACHE(M_AXI_AWCACHE),
    .M_AXI_AWPROT(M_AXI_AWPROT),
    .M_AXI_AWQOS(M_AXI_AWQOS),
    .M_AXI_AWUSER(M_AXI_AWUSER),
    .M_AXI_AWVALID(M_AXI_AWVALID),
    .M_AXI_AWREADY(M_AXI_AWREADY),
    .M_AXI_WDATA(M_AXI_WDATA),
    .M_AXI_WSTRB(M_AXI_WSTRB),
    .M_AXI_WLAST(M_AXI_WLAST),
    .M_AXI_WUSER(M_AXI_WUSER),
    .M_AXI_WVALID(M_AXI_WVALID),
    .M_AXI_WREADY(M_AXI_WREADY),
    .M_AXI_BID(M_AXI_BID),
    .M_AXI_BRESP(M_AXI_BRESP),
    .M_AXI_BUSER(M_AXI_BUSER),
    .M_AXI_BVALID(M_AXI_BVALID),
    .M_AXI_BREADY(M_AXI_BREADY),
    .M_AXI_ARID(M_AXI_ARID),
    .M_AXI_ARADDR(M_AXI_ARADDR),
    .M_AXI_ARLEN(M_AXI_ARLEN),
    .M_AXI_ARSIZE(M_AXI_ARSIZE),
    .M_AXI_ARBURST(M_AXI_ARBURST),
    .M_AXI_ARLOCK(M_AXI_ARLOCK),
    .M_AXI_ARCACHE(M_AXI_ARCACHE),
    .M_AXI_ARPROT(M_AXI_ARPROT),
    .M_AXI_ARQOS(M_AXI_ARQOS),
    .M_AXI_ARUSER(M_AXI_ARUSER),
    .M_AXI_ARVALID(M_AXI_ARVALID),
    .M_AXI_ARREADY(M_AXI_ARREADY),
    .M_AXI_RID(M_AXI_RID),
    .M_AXI_RDATA(M_AXI_RDATA),
    .M_AXI_RRESP(M_AXI_RRESP),
    .M_AXI_RLAST(M_AXI_RLAST),
    .M_AXI_RUSER(M_AXI_RUSER),
    .M_AXI_RVALID(M_AXI_RVALID),
    .M_AXI_RREADY(M_AXI_RREADY)
);

endmodule

