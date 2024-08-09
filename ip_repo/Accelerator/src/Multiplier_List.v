module multiplier_list #(

	parameter dwidth = 16,
	parameter qwidth = 11,
	parameter PE_Num = 8

)(
	input wire clk,
	input wire signed [2*PE_Num*dwidth-1:0] fclayer_din,	  
	input wire signed [2*PE_Num*dwidth-1:0] fclayer_win,	

	output wire signed [2*PE_Num*dwidth-1:0] mult_dout   
);

    generate
        genvar i;
        for (i = 0; i < PE_Num; i = i + 1)
        begin: multiplier_list_1 
            
            Multiplier #(.dwidth(dwidth), .qwidth(qwidth)) mult 
                (   .clk(clk), 
                    .din(fclayer_din[i*dwidth +: dwidth]), 
                    .win(fclayer_win[i*dwidth +: dwidth]), 

                    .dout(mult_dout[i*dwidth +: dwidth])
                );
        end
    endgenerate

    generate
        genvar j;
        for (j = PE_Num; j < 2*PE_Num; j = j + 1)
        begin: multiplier_list_2 
            
            Multiplier_fc #(.dwidth(dwidth), .qwidth(qwidth)) mult 
                (   .clk(clk), 
                    .din(fclayer_din[j*dwidth +: dwidth]), 
                    .win(fclayer_win[j*dwidth +: dwidth]), 

                    .dout(mult_dout[j*dwidth +: dwidth])
                );
        end
    endgenerate
endmodule