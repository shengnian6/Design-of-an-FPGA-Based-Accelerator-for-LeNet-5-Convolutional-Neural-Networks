module WinList_input #(

    parameter dwidth = 16,
    parameter PE_Num = 8

)(
    input wire clk,
    input wire [7:0] rom_win_raddr,
    output wire signed [PE_Num*dwidth-1:0] rom_win
);

    // instantiate rom_win
    ROM_weight win_input (
      .clka(clk),    
      .ena(1'b1),             // input wire ena
      .addra(rom_win_raddr),  // input wire [7 : 0] addra
      .douta(rom_win)         // output wire [127 : 0] douta
    );

endmodule