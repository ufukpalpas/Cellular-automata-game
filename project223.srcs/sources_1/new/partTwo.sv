`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2019 18:44:48
// Design Name: 
// Module Name: partTwo
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


module partTwo(input logic clk, en, over, gameOver, restartOn, startBtn, [15:0] count, get,[1:0] swt, [3:0] in, [1:0] as,
output logic Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, [3:0] an, [15:0] leds, [63:0] allOut, [3:0] regOut0, [3:0] regOut1, [3:0] regOut2, [3:0] regOut3);
//logic [3:0] regOut0;
//logic [3:0] regOut1;
//logic [3:0] regOut2;
//logic [3:0] regOut3;
//logic [63:0] allOut;
logic start = 0; // check is game started
partOne one( clk, en,over, gameOver, restartOn, startBtn, count, in, as, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, an, regOut3, regOut2, regOut1, regOut0);
logic [15:0] o0 = 0; // page 1
logic [15:0] o1 = 0; // page 2
logic [15:0] o2 = 0; // page 3
logic [15:0] o3 = 0; // page 4
logic oldGet = 0; // get switch register 
//logic [63:0] allOut;
//logic restart_onOld = 0;

always_ff @(posedge clk, posedge get)
begin
//restart_onOld <= restartOn;
    if( restartOn && over == 1) // for restrt state change in leds  code 
    begin
        o3 <= 0;
        o1 <= 0;
        o2 <= 0;
        o0 <= 0;
    end
    oldGet <= get; // register for switch to avoid unwanted inputs
    if(get & !oldGet & swt[0] == 1 & swt[1] == 1 ) // arrange page 1
    begin
        o0 <= {regOut0, regOut1, regOut2, regOut3};
    end 
    else if(get & !oldGet & swt[0] == 0 & swt[1] == 1) // arrange page 2
    begin
        o1 <= {regOut0, regOut1, regOut2, regOut3};
    end 
    else if(get & !oldGet & swt[0] == 1 & swt[1] == 0) // arrange page 3
    begin
        o2 <= {regOut0, regOut1, regOut2, regOut3};
    end
    else if(get & !oldGet & swt[0] == 0 & swt[1] == 0) // arrange page 4
    begin
        o3 <= {regOut0, regOut1, regOut2, regOut3};
    end
    
    allOut <= {o0, o1, o2, o3}; // 11 10 01 00 // express al in a single 64 bit logic 
end


always_ff @(posedge clk) // led states 
begin
    if(swt == 2'b00) // page 1 leds 
        leds = o3;
    else if(swt == 2'b01) // page 2 leds 
        leds = o2;
    else if(swt == 2'b10) //  pge 3 leds
        leds = o1;
    else if(swt == 2'b11) // page 4 leds
        leds = o0;
//    case(swt) //  same features with switch case (problematic implementations)
//    2'b00: leds = o3;
//    2'b01: leds = 02;
//    2'b10: leds = o1;
//    2'b11: leds = o0;
//    endcase
end

//SevSeg_4digit sevseg(clk, regOut3, regOut2, regOut1, regOut0, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, an);

endmodule