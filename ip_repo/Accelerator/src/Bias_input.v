module BiasList_input #(

    parameter dwidth = 16,
    parameter PE_Num = 8

)(
    input wire clk,
    input wire [4:0] rom_bias_raddr,
    output wire signed [PE_Num*dwidth-1:0] rom_bias
);

    // instantiate rom_bias
    ROM_bias bias_input (
      .clka(clk),    
      .ena(1'b1),             // input wire ena
      .addra(rom_bias_raddr),  // input wire [3 : 0] addra
      .douta(rom_bias)         // output wire [15 : 0] douta
    );    
    
endmodule