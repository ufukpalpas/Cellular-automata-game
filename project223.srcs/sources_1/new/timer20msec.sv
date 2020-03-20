`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2019 01:15:22
// Design Name: 
// Module Name: timer20msec
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


module timer20msec( input logic clk, load, en, //logic[31:0] M, // 1 ms counter
output logic Q);

logic[31:0] countdown; // count down until 1ms 
logic[31:0] M = 32'b00000000000000011000011010100000;//00000000000111101000010010000000; //constant 100.000 clock times because 1 ms 

logic[31:0] next;
assign next = countdown - 1; // start condition

always_ff @(posedge clk)
    if(load|Q)
        countdown <= M - 1 ; // decrease 
    else if(en)
        countdown <= next; // restart the counted value 
 
always_ff @(posedge clk)
    if(countdown == 0) 
        Q = 1;
    else
        Q = 0;

endmodule
