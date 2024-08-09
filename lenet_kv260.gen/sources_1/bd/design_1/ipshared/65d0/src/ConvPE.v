

module ConvPE #(

    parameter dwidth       = 16,
    parameter qwidth       = 11,
    parameter kernel_size  = 3,
    parameter strides      = 1,
    parameter PE_latency   = 5

)(
    // Input: control signal
    input wire clk,
    input wire rst_n,
    input wire input_rd_en,
    input wire win_st,
    input wire [4:0] featmap_size,
    input wire convlayer_state,

    // Input: data signal
    input wire signed [dwidth-1:0] din,
    input wire signed [dwidth-1:0] win,

    // Output: 
    output wire signed [dwidth-1:0] dout,   
    output wire dout_start

    // debug signal output
    // output wire signed [dwidth-1:0] din00,din01,din02,
    // output wire signed [dwidth-1:0] din10,din11,din12,
    // output wire signed [dwidth-1:0] din20,din21,din22,
    // w00,w01,w02,
    // w10,w11,w12,
    // w20,w21,w22,
    // output wire signed [dwidth-1:0] dout00,dout01,dout02,
    // output wire signed [dwidth-1:0] dout10,dout11,dout12,
    // output wire signed [dwidth-1:0] dout20,dout21,dout22
    // dout_org,
    // select_en
    // shift_en,
    // dout_org,
    // select_en,
    // dwr_en
);
  
    // debug data signal
    wire signed [dwidth-1:0] din00,din01,din02;
    wire signed [dwidth-1:0] din10,din11,din12;
    wire signed [dwidth-1:0] din20,din21,din22;
    wire signed [dwidth-1:0] w00,w01,w02;
    wire signed [dwidth-1:0] w10,w11,w12;
    wire signed [dwidth-1:0] w20,w21,w22;
    wire signed [dwidth-1:0] dout00,dout01,dout02;
    wire signed [dwidth-1:0] dout10,dout11,dout12;
    wire signed [dwidth-1:0] dout20,dout21,dout22;
    wire signed [dwidth-1:0] dout_org;  // orginal data 


    /****** Module Statement *******/
    wire rst;
    // rst
    assign rst = ~rst_n;
    
    reg input_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset
            input_reg <= 1'b0;
        end
        else begin
            input_reg <= input_rd_en;
        end
    end

    // data shift 
    dataShift #(.dwidth(dwidth)) Data_Shift0 (
        .clk(clk),
        .rst(rst),
        .din(din),
        .convlayer_state(convlayer_state),

        .dout00(din00),.dout01(din01),.dout02(din02),
        .dout10(din10),.dout11(din11),.dout12(din12),
        .dout20(din20),.dout21(din21),.dout22(din22) 
    );

    // weight shift
    weightShift #(
            .dwidth(dwidth),
            .kernel_size(kernel_size)
        ) Weight_Shift0 (
            .clk(clk),
            .rst(rst),
            .win_en(win_st),
            .din(win),
            .featmap_size (featmap_size),

            .dout00(w00),.dout01(w01),.dout02(w02),
            .dout10(w10),.dout11(w11),.dout12(w12),
            .dout20(w20),.dout21(w21),.dout22(w22),

            //debug
            .shift_en()  
        );


    // multiplier matrix 
    multMatrix #(.dwidth(dwidth),.qwidth(qwidth)) multMatrix0(
        .clk(clk),
        .din00(din00),.din01(din01),.din02(din02),
        .din10(din10),.din11(din11),.din12(din12),
        .din20(din20),.din21(din21),.din22(din22),
        .w00(w00),.w01(w01),.w02(w02),
        .w10(w10),.w11(w11),.w12(w12),
        .w20(w20),.w21(w21),.w22(w22),

        .dout00(dout00),.dout01(dout01),.dout02(dout02),
        .dout10(dout10),.dout11(dout11),.dout12(dout12),
        .dout20(dout20),.dout21(dout21),.dout22(dout22)       

    ); 

    wire signed [dwidth-1:0] adderTree_out;
    // adder tree
    adderTree #(.dwidth(dwidth)) adderTree0(
        .clk(clk),
        .rst(rst),
        .din00(dout00),.din01(dout01),.din02(dout02),
        .din10(dout10),.din11(dout11),.din12(dout12),
        .din20(dout20),.din21(dout21),

        .dout(adderTree_out)
    );

	reg signed [dwidth-1:0] stage1_out;
    reg signed [dwidth-1:0] stage2_out;
    reg signed [dwidth-1:0] stage3_out;

    // din22 寄存器移位
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset
            stage1_out <= 0;
            stage2_out <= 0;
            stage3_out <= 0;
        end
        else begin
            stage1_out <= dout22;
            stage2_out <= stage1_out;
            stage3_out <= stage2_out;
        end
    end

    // stage 4 -> 1adder
    Adder #(.dwidth(dwidth)) inst_Adder7 (		
    	.clk(clk), 
    	.rst(rst), 
    	.din1(adderTree_out), 
    	.din2(stage3_out), 
    	.dout(dout_org)
    );
    

  	// data correct
    dataCorrect #(
        .dwidth(dwidth),
        .kernel_size(kernel_size),
        .strides(strides),
        .PE_latency(PE_latency)

    ) Data_Correct0 (
        .din       (dout_org),
        .clk       (clk),
        .rst       (rst),
        .din_en    (input_rd_en),
        .featmap_size (featmap_size),

        .dout      (dout),
        .dout_start(dout_start),
        .full      (),
        .empty     (),
        //debug
        .dwr_en(),
        .select_en ()

    );

endmodule
