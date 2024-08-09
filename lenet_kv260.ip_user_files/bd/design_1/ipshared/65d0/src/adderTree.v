


module adderTree #(
    parameter dwidth = 16
)(
    input wire clk,
    input wire rst,
    input wire signed [dwidth-1:0] din00,din01,din02,
    input wire signed [dwidth-1:0] din10,din11,din12,
    input wire signed [dwidth-1:0] din20,din21,

    output wire signed [dwidth-1:0] dout   // 16Q11
);

    wire signed [dwidth-1:0] stage1_out0;
    wire signed [dwidth-1:0] stage1_out1;
    wire signed [dwidth-1:0] stage1_out2;
    wire signed [dwidth-1:0] stage1_out3;
    
    wire signed [dwidth-1:0] stage2_out0;
    wire signed [dwidth-1:0] stage2_out1;
    
    
    // 加法树 3 级流水线
    // stage 1 -> 4adders
    Adder #(.dwidth(dwidth)) inst_Adder0 (.clk(clk), .rst(rst), .din1(din00), .din2(din01), .dout(stage1_out0));

    Adder #(.dwidth(dwidth)) inst_Adder1 (.clk(clk), .rst(rst), .din1(din02), .din2(din12), .dout(stage1_out1));

    Adder #(.dwidth(dwidth)) inst_Adder2 (.clk(clk), .rst(rst), .din1(din10), .din2(din11), .dout(stage1_out2));

    Adder #(.dwidth(dwidth)) inst_Adder3 (.clk(clk), .rst(rst), .din1(din20), .din2(din21), .dout(stage1_out3));


    // stage 2 -> 2adders
    Adder #(.dwidth(dwidth)) inst_Adder4 (.clk(clk), .rst(rst), .din1(stage1_out0), .din2(stage1_out1), .dout(stage2_out0));

    Adder #(.dwidth(dwidth)) inst_Adder5 (.clk(clk), .rst(rst), .din1(stage1_out2), .din2(stage1_out3), .dout(stage2_out1));


    // stage 3 -> 1adder
    Adder #(.dwidth(dwidth)) inst_Adder6 (.clk(clk), .rst(rst), .din1(stage2_out0), .din2(stage2_out1), .dout(dout));


endmodule
