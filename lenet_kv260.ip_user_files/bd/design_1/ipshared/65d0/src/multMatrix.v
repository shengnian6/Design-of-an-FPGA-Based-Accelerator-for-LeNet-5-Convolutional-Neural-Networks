


module multMatrix #(
    parameter dwidth = 16,
    parameter qwidth = 11
)(
    input wire clk,
    input wire signed [dwidth-1:0] din00,din01,din02,
    input wire signed [dwidth-1:0] din10,din11,din12,
    input wire signed [dwidth-1:0] din20,din21,din22,
    input wire signed [dwidth-1:0] w00,w01,w02,
    input wire signed [dwidth-1:0] w10,w11,w12,
    input wire signed [dwidth-1:0] w20,w21,w22,

    output wire signed [dwidth-1:0] dout00,dout01,dout02,
    output wire signed [dwidth-1:0] dout10,dout11,dout12,
    output wire signed [dwidth-1:0] dout20,dout21,dout22
);



    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult0 
                (   .clk(clk), 
                    .din(din00), 
                    .win(w00), 

                    .dout(dout00)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult1
                    (.clk(clk), 
                     .din(din01), 
                     .win(w01),

                     .dout(dout01)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult2 
                    (.clk(clk), 
                     .din(din02), 
                     .win(w02), 

                     .dout(dout02)
                );


    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult3 
                    (.clk(clk), 
                     .din(din10), 
                     .win(w10),

                     .dout(dout10)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult4 
                    (.clk(clk), 
                     .din(din11), 
                     .win(w11), 

                     .dout(dout11)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult5 
                    (.clk(clk), 
                     .din(din12), 
                     .win(w12),
 

                     .dout(dout12)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult6 
                    (.clk(clk), 
                     .din(din20), 
                     .win(w20),

                     .dout(dout20)
                );  
    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult7 
                    (.clk(clk), 
                     .din(din21), 
                     .win(w21), 

                     .dout(dout21)
                );

    Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult8 
                    (.clk(clk), 
                     .din(din22), 
                     .win(w22), 

                     .dout(dout22)
                );

               
endmodule
