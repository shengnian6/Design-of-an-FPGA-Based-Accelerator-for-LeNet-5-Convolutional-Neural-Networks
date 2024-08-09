`timescale 1ns / 1ps
module AXI_HP_Master_Burst_Transceiver #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	= 1,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH	= 32,
    // Width of User Write Address Bus
    parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
    // Width of User Read Address Bus
    parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Read Data Bus
    parameter integer C_M_AXI_RUSER_WIDTH	= 0,
    // Width of User Response Bus
    parameter integer C_M_AXI_BUSER_WIDTH	= 0
)
(
    // Users to add ports here
    input read_start,
    input [8:0]_read_burst_len,
    input [C_M_AXI_ADDR_WIDTH-1:0]Read_BASE_ADDR,
    output reg read_done,
    
    input RX_FIFO_full,
    output RX_FIFO_wr_en,
    output [C_M_AXI_DATA_WIDTH-1:0]RX_FIFO_din,
    
    input write_start,
    input [8:0]_write_burst_len,
    input [C_M_AXI_ADDR_WIDTH-1:0]Write_BASE_ADDR,
    output reg write_done,
        
    input TX_FIFO_empty,
    output TX_FIFO_rd_en,
    input [C_M_AXI_DATA_WIDTH-1:0]TX_FIFO_dout,

    
    // User ports ends
    // Do not modify the ports beyond this line
    // Global Clock Signal.
    input wire  M_AXI_ACLK,
    // Global Reset Singal. This Signal is Active Low
    input wire  M_AXI_ARESETN,
    // Master Interface Write Address ID
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
    // Master Interface Write Address
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output wire [7 : 0] M_AXI_AWLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output wire [2 : 0] M_AXI_AWSIZE,
    // Burst type. The burst type and the size information, 
// determine how the address for each transfer within the burst is calculated.
    output wire [1 : 0] M_AXI_AWBURST,
    // Lock type. Provides additional information about the
// atomic characteristics of the transfer.
    output wire  M_AXI_AWLOCK,
    // Memory type. This signal indicates how transactions
// are required to progress through a system.
    output wire [3 : 0] M_AXI_AWCACHE,
    // Protection type. This signal indicates the privilege
// and security level of the transaction, and whether
// the transaction is a data access or an instruction access.
    output wire [2 : 0] M_AXI_AWPROT,
    // Quality of Service, QoS identifier sent for each write transaction.
    output wire [3 : 0] M_AXI_AWQOS,
    // Optional User-defined signal in the write address channel.
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
    // Write address valid. This signal indicates that
// the channel is signaling valid write address and control information.
    output wire  M_AXI_AWVALID,
    // Write address ready. This signal indicates that
// the slave is ready to accept an address and associated control signals
    input wire  M_AXI_AWREADY,
    // Master Interface Write Data.
    output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
    // Write strobes. This signal indicates which byte
// lanes hold valid data. There is one write strobe
// bit for each eight bits of the write data bus.
    output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
    // Write last. This signal indicates the last transfer in a write burst.
    output wire  M_AXI_WLAST,
    // Optional User-defined signal in the write data channel.
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
    // Write valid. This signal indicates that valid write
// data and strobes are available
    output wire  M_AXI_WVALID,
    // Write ready. This signal indicates that the slave
// can accept the write data.
    input wire  M_AXI_WREADY,
    // Master Interface Write Response.
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
    // Write response. This signal indicates the status of the write transaction.
    input wire [1 : 0] M_AXI_BRESP,
    // Optional User-defined signal in the write response channel
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
    // Write response valid. This signal indicates that the
// channel is signaling a valid write response.
    input wire  M_AXI_BVALID,
    // Response ready. This signal indicates that the master
// can accept a write response.
    output wire  M_AXI_BREADY,
    // Master Interface Read Address.
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
    // Read address. This signal indicates the initial
// address of a read burst transaction.
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output wire [7 : 0] M_AXI_ARLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output wire [2 : 0] M_AXI_ARSIZE,
    // Burst type. The burst type and the size information, 
// determine how the address for each transfer within the burst is calculated.
    output wire [1 : 0] M_AXI_ARBURST,
    // Lock type. Provides additional information about the
// atomic characteristics of the transfer.
    output wire  M_AXI_ARLOCK,
    // Memory type. This signal indicates how transactions
// are required to progress through a system.
    output wire [3 : 0] M_AXI_ARCACHE,
    // Protection type. This signal indicates the privilege
// and security level of the transaction, and whether
// the transaction is a data access or an instruction access.
    output wire [2 : 0] M_AXI_ARPROT,
    // Quality of Service, QoS identifier sent for each read transaction
    output wire [3 : 0] M_AXI_ARQOS,
    // Optional User-defined signal in the read address channel.
    output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
    // Write address valid. This signal indicates that
// the channel is signaling valid read address and control information
    output wire  M_AXI_ARVALID,
    // Read address ready. This signal indicates that
// the slave is ready to accept an address and associated control signals
    input wire  M_AXI_ARREADY,
    // Read ID tag. This signal is the identification tag
// for the read data group of signals generated by the slave.
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
    // Master Read Data
    input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
    // Read response. This signal indicates the status of the read transfer
    input wire [1 : 0] M_AXI_RRESP,
    // Read last. This signal indicates the last transfer in a read burst
    input wire  M_AXI_RLAST,
    // Optional User-defined signal in the read address channel.
    input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
    // Read valid. This signal indicates that the channel
// is signaling the required read data.
    input wire  M_AXI_RVALID,
    // Read ready. This signal indicates that the master can
// accept the read data and response information.
    output wire  M_AXI_RREADY
);
          
function integer clogb2 (input integer bit_depth);              
begin                                                           
for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
  bit_depth = bit_depth >> 1;                                 
end                                                           
endfunction                                                     

localparam integer C_TRANSACTIONS_NUM_Read = clogb2(1024-1);
localparam integer C_TRANSACTIONS_NUM_Write = clogb2(1024-1);
reg [9:0]write_burst_len;
reg [9:0]read_burst_len;

reg [1:0] read_state=3'd0;
reg [1:0] write_state=3'd0;
reg  	axi_awvalid;
reg  	axi_wlast;
reg  	axi_wvalid;
reg  	axi_bready;
reg  	axi_arvalid;
reg  	axi_rready;
reg [C_TRANSACTIONS_NUM_Write : 0] 	write_index;
reg  	start_single_burst_write;
reg  	start_single_burst_read;
reg  	burst_write_active;
reg  	burst_read_active;
wire  	wnext;
wire  	rnext;

reg FIFO_cnt;
wire generated_FIFO_empty=~FIFO_cnt;

assign M_AXI_AWID	= 'b0;
assign M_AXI_AWADDR	= Write_BASE_ADDR;
assign M_AXI_AWLEN	= write_burst_len-1;
assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
assign M_AXI_AWBURST	= 2'b01;
assign M_AXI_AWLOCK	= 1'b0;
assign M_AXI_AWCACHE	= 4'b0010;
assign M_AXI_AWPROT	= 3'h0;
assign M_AXI_AWQOS	= 4'h0;
assign M_AXI_AWUSER	= 'b1;
assign M_AXI_AWVALID	= axi_awvalid;
assign M_AXI_WDATA= TX_FIFO_dout;
assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
assign M_AXI_WLAST	= axi_wlast;
assign M_AXI_WUSER	= 'b0;
assign M_AXI_WVALID	= axi_wvalid & (~generated_FIFO_empty) ;
assign M_AXI_BREADY	= axi_bready;
assign M_AXI_ARID	= 'b0;
assign M_AXI_ARADDR	= Read_BASE_ADDR;
assign M_AXI_ARLEN	= read_burst_len-1;
assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
assign M_AXI_ARBURST	= 2'b01;
assign M_AXI_ARLOCK	= 1'b0;
assign M_AXI_ARCACHE	= 4'b0010;
assign M_AXI_ARPROT	= 3'h0;
assign M_AXI_ARQOS	= 4'h0;
assign M_AXI_ARUSER	= 'b1;
assign M_AXI_ARVALID	= axi_arvalid;
assign M_AXI_RREADY	= axi_rready & (~RX_FIFO_full) ;

always @(posedge M_AXI_ACLK)                                   
begin                                                                                                                                  
if ( (M_AXI_ARESETN == 0))                                   
  begin                                                            
    axi_awvalid <= 1'b0;                                           
  end                                                                          
else if (~axi_awvalid && start_single_burst_write)                 
  begin                                                            
    axi_awvalid <= 1'b1;                                           
  end                                                                                
else if (M_AXI_AWREADY && axi_awvalid)                             
  begin                                                            
    axi_awvalid <= 1'b0;                                           
  end                                                              
else                                                               
  axi_awvalid <= axi_awvalid;                                      
end                                                                                                                               

assign wnext = M_AXI_WREADY & axi_wvalid & (~generated_FIFO_empty) ;                                   
                   
always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
if ((M_AXI_ARESETN == 0))                                        
  begin                                                                         
    axi_wvalid <= 1'b0;                                                         
  end                                                                                                  
else if (~axi_wvalid && start_single_burst_write)                               
  begin                                                                         
    axi_wvalid <= 1'b1;                                                         
  end                                                                                                        
else if (wnext && axi_wlast)                                                    
  axi_wvalid <= 1'b0;                                                           
else                                                                            
  axi_wvalid <= axi_wvalid;                                                     
end         
                                                                      
wire [8:0]C_M_AXI_BURST_LEN=write_burst_len;       

always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
if( (M_AXI_ARESETN == 0) )                                                      
  begin                                                                         
    axi_wlast <= 1'b0;                                                          
  end                                                                           
//else if( (((write_index == C_M_AXI_BURST_LEN-2 && C_M_AXI_BURST_LEN >= 2) && wnext) || (C_M_AXI_BURST_LEN == 1 )) )
else if (((write_index == C_M_AXI_BURST_LEN-2 && C_M_AXI_BURST_LEN >= 2) && wnext) || ( (C_M_AXI_BURST_LEN == 1 ) && start_single_burst_write ))
  begin                                                                         
    axi_wlast <= 1'b1;                                                          
  end                                                                                                           
else if (wnext)                                                                 
  axi_wlast <= 1'b0;                                                            
//else if (axi_wlast && C_M_AXI_BURST_LEN == 1)                                   
//  axi_wlast <= 1'b0;                                                            
else                                                                            
  axi_wlast <= axi_wlast;                                                       
end                                                                           
                                                 
always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
if( (M_AXI_ARESETN == 0 || start_single_burst_write == 1'b1) )   
  begin                                                                         
    write_index <= 0;                                                           
  end                                                                           
else if (wnext && (write_index != C_M_AXI_BURST_LEN-1))                         
  begin                                                                         
    write_index <= write_index + 1;                                             
  end                                                                           
else                                                                            
  write_index <= write_index;                                                   
end                                                                                                                               

always @(posedge M_AXI_ACLK)                                     
begin                                                                 
if (M_AXI_ARESETN == 0)
  begin                                                             
    axi_bready <= 1'b0;                                             
  end                                                                                  
else if (M_AXI_BVALID && ~axi_bready)                               
  begin                                                             
    axi_bready <= 1'b1;                                             
  end                                                                                              
else if (axi_bready)                                                
  begin                                                             
    axi_bready <= 1'b0;                                             
  end                                                                                                    
else                                                                
  axi_bready <= axi_bready;                                         
end                                                                                                                                          

always @(posedge M_AXI_ACLK)                                                                                         
if( (M_AXI_ARESETN == 0) )
begin                                                          
    axi_arvalid <= 1'b0;                                         
end                                                                       
else 
    if (~axi_arvalid && start_single_burst_read)                                                                         
        axi_arvalid <= 1'b1;                                                                                                   
    else 
        if (M_AXI_ARREADY && axi_arvalid)                                                                                   
            axi_arvalid <= 1'b0;                                                                                                 
        else                                                             
            axi_arvalid <= axi_arvalid;                                    

assign rnext = M_AXI_RVALID && axi_rready  && (~RX_FIFO_full);                            
                                                                   
always @(posedge M_AXI_ACLK)                                                                                                       
if( (M_AXI_ARESETN == 0) )
begin                                                             
    axi_rready <= 1'b0;                                             
end                                                                               
else 
    if (M_AXI_RVALID)                       
    begin                                      
        if (M_AXI_RLAST && axi_rready)                                        
            axi_rready <= 1'b0;                                                   
        else                                                                
            axi_rready <= 1'b1;                                             
    end                                                                                       

reg [1:0]read_start_pre;
always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )  
    read_start_pre<=2'b11;
else
    read_start_pre<={read_start_pre[0],read_start};

wire read_start_pos=read_start_pre[0]&(~read_start_pre[1]);                                                                                                         

always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )                                                                             
    begin                                                                                                                           
        read_state      <= 2'b0; 
        read_done<=1'd0;                                                                                                                                 
        start_single_burst_read  <= 1'b0;    
        read_burst_len<='d0;                                                                                                                                      
    end                                                                                                   
else                                                                                                    
begin                                                                                                                                                                               
    case (read_state)
        2'd0:
            begin
                read_done<=1'd0;
                if(read_start_pos)
                begin
                    read_state<=2'd1;     
                    read_burst_len<=_read_burst_len; 
                end
        	end                                                                                                                                                                                                                                                                                                                                                                                                                                 
        2'd1:                                                                                                                                                                                                                                                        
            if (~axi_arvalid && ~burst_read_active && ~start_single_burst_read)                         
              begin                                                                                     
                start_single_burst_read <= 1'b1;                                                        
              end                                                                                       
           else                                                                                         
             begin                                                                                      
                   start_single_burst_read <= 1'b0;
                   read_state <= 2'd2;                       
             end                                                                                                            
       2'd2:
            if (~axi_arvalid && ~burst_read_active && ~start_single_burst_read)
                read_state <= 2'd3;
		2'd3:
			begin
				read_done<=1'd1;
				read_state <= 2'd0;  	
			end                                                                                             
    endcase                                                                                             
end  

reg [1:0]write_start_pre;
always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )    
	write_start_pre<=2'b11;
else
	write_start_pre<={write_start_pre[0],write_start};

wire write_start_pos=write_start_pre[0]&(~write_start_pre[1]);

always @ ( posedge M_AXI_ACLK)                                                                                                                                                                              
if (M_AXI_ARESETN == 1'b0 )                                                                             
    begin             
    	write_done<=1'd0;                                                                                                              
        write_state      <= 2'b0;                                                                                                                               
        start_single_burst_write  <= 1'b0;   
        write_burst_len<='d0;                                                                                                                                  
    end                                                                                                   
else                                                                                                    
begin                                                                                                                                                                               
    case (write_state)
        2'd0:
            begin
                write_done<=1'd0;
                if(write_start_pos)
                begin
                    write_state  <= 2'd1;
                    write_burst_len<=_write_burst_len;  
                end    
            end                                                                                                                                                                                                                                                                                                                                                                                                                                        
        2'd1:                                                                                                                                                                                                                                                        
			if (~axi_awvalid && ~start_single_burst_write && ~burst_write_active)                  
              begin                                                                                     
                start_single_burst_write <= 1'b1;                                                        
              end                                                                                       
           else                                                                                         
             begin                                                                                      
                   start_single_burst_write <= 1'b0;
                   write_state <= 2'd2;                       
             end                                                                                                            
        2'd2:
            if (~axi_awvalid && ~start_single_burst_write && ~burst_write_active) 
                write_state <= 2'd3;
        2'd3:
        	begin
        		write_done<=1'd1;
        		write_state <= 2'd0;  	
        	end    	                                                                                            
    endcase                                                                                             
end  

always @(posedge M_AXI_ACLK)                                                                              
begin                                                                                                     
    if( (M_AXI_ARESETN == 0))                                                                  
        burst_write_active <= 1'b0;                                                                                           
    else 
        if (start_single_burst_write)                                                                      
            burst_write_active <= 1'b1;                                                                           
        else 
            if (M_AXI_BVALID && axi_bready)                                                                    
                burst_write_active <= 0;                                                                              
end                                                                                                       
                   
always @(posedge M_AXI_ACLK)                                                                              
begin                                                                                                     
    if( (M_AXI_ARESETN == 0)  )                                                               
        burst_read_active <= 1'b0;                                                                                                 
    else 
        if (start_single_burst_read)                                                                       
            burst_read_active <= 1'b1;                                                                            
        else 
            if (rnext && M_AXI_RLAST)                                                     
                burst_read_active <= 0;                                                                               
end            

always @(posedge M_AXI_ACLK)                                                                                         
if( (M_AXI_ARESETN == 0) )
    FIFO_cnt<=1'b0;
else
    case({TX_FIFO_rd_en,wnext})
        2'b00:FIFO_cnt<=FIFO_cnt;
        2'b01:FIFO_cnt<=1'b0;
        2'b10:FIFO_cnt<=1'b1;
        2'b11:FIFO_cnt<=FIFO_cnt;
    endcase

assign RX_FIFO_din=M_AXI_RDATA;
assign RX_FIFO_wr_en=rnext;

assign TX_FIFO_rd_en= (wnext|(~FIFO_cnt)) &(~TX_FIFO_empty);// (M_AXI_AWREADY & axi_awvalid) | (wnext &(~axi_wlast));

endmodule
