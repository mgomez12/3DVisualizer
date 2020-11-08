`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2020 02:01:14 PM
// Design Name: 
// Module Name: transformation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module transformation(

    );
  blk_mem_gen_0 points_mem (clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[4:0],douta[35:0]" */;
  input clka;
  input ena;
  input [4:0]addra;
  output [35:0]douta;
endmodule
    
endmodule
