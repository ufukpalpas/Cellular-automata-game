`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2019 01:48:41
// Design Name: 
// Module Name: timer10msec
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


module timer10msec( input logic clk, load, en, //logic[31:0] M,
output logic Q);

logic[31:0] countdown;
logic[31:0] M = 32'b00000000000011110100001001000000; //constant

logic[31:0] next;
assign next = countdown - 1;

always_ff @(posedge clk)
    if(load|Q)
        countdown <= M - 1 ;
    else if(en)
        countdown <= next;
 
always_ff @(posedge clk)
    if(countdown == 0)
        Q = 1;
    else
        Q = 0;

endmodule
