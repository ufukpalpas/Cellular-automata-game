`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2019 01:47:41
// Design Name: 
// Module Name: endx25ms
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


module endx25ms(input logic clkQ, clr, cnt,
output logic tc);
logic [7:0] C;
logic [7:0] M = 8'b00000000;
initial
begin
assign tc = 1;
end
always_ff @(posedge clkQ)
    if(clr | tc) 
        C <= M + 1;
    else  if(cnt)
        C <= C + 1;
      
always_ff @(posedge clkQ)
    if(C == 8'b00011001) 
        tc = 1; 
    else 
        tc = 0; //500ms 25 times clk
endmodule
