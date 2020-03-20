`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2019 11:12:19
// Design Name: 
// Module Name: partOne
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


module partOne(input logic clk, en, over, gameOver, restartOn, startBtn, [15:0] count, [3:0] in, [1:0] as,
output logic Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, [3:0] an,[3:0] regOut3,[3:0] regOut2,[3:0] regOut1,[3:0] regOut0);

logic [3:0] regIn; // input 4 bit 
//logic [3:0] regOut0;
//logic [3:0] regOut1;
//logic [3:0] regOut2;
//logic [3:0] regOut3;
logic [3:0] regIn0; // first in 7 seg
logic [3:0] regIn1; // second in 7 seg
logic [3:0] regIn2;
logic [3:0] regIn3;
logic start = 0; // check wheter the game is stated 
logic oldStart = 0; // to avoid double start
logic restart = 0; 


//TIMER
logic tc;
logic [31:0] C;
logic [31:0] M = 32'b00000000000000000000000000000000;

initial
begin
    assign tc = 1;
end
always_ff @(posedge clk)
    if(C > 32'b00000010111110101111000010000000)  // 250 ms
        C <= M + 1;
    else 
        C <= C + 1;
        
always_ff @(posedge clk)
begin
    if(C <= 32'b00000001011111010111100001000000) //250ms
        tc = 1; 
    else if(C > 32'b00000001011111010111100001000000 & C <= 32'b00000010111110101111000010000000) //500ms
        tc = 0;
end
//TIMER END



always_ff @(posedge clk)
begin
    regIn = ((in % 4096) % 256) % 16; // to hexadecimal
end

always_ff @(posedge clk)
begin
    if(startBtn == 1) // start or not 
        start <= 1;
     else if(restartOn == 1 && over == 1) // restart 
     begin
        start <= 0;
     end
end

always_ff @(posedge clk)
begin
        
    if(gameOver == 1)
    begin
        if(tc == 1) // blink open for 250ms
        begin
            regOut0 = count / 1000;
            regOut1 = (count % 1000) /100;
            regOut2 = ((count % 1000) % 100) / 10;
            regOut3 = ((count % 1000) % 100) % 10;
        end else if(tc == 0) // blink closed for 250 ms
        begin 
            regOut0 = 0;
            regOut1 = 0;
            regOut2 = 0;
            regOut3 = 0;
        end
    end
    
    if( gameOver == 0)
    begin
        if(start == 1) // part 1 7 segment 
        begin
             regOut0 = count / 1000;
             regOut1 = (count % 1000) /100;
             regOut2 = ((count % 1000) % 100) / 10;
             regOut3 = ((count % 1000) % 100) % 10; 
        end
        else
        begin
            if( restartOn == 1 && over == 1) // restart state 
            begin
                regOut0 = 0;
                regOut1 = 0;
                regOut2 = 0;
                regOut3 = 0;
            end
            else
            begin
                case(as) // show entered values
                2'b00: 
                begin
                    regIn3 = regIn; // register for first input
                    if(en)
                         regOut3 = regIn3;
                     else
                        regOut3 = regOut3;
                end
                2'b01:
                begin
                    regIn2 = regIn; // register for second input 
                    if(en)
                        regOut2 = regIn2;
                    else
                        regOut2 = regOut2;
                end
                2'b10:
                begin
                    regIn1 = regIn; // register for third input
                    if(en)
                         regOut1 = regIn1;
                     else
                        regOut1 = regOut1;
                end
                2'b11:
                begin
                    regIn0 = regIn; // register for fourth input
                    if(en)
                         regOut0 = regIn0;
                    else
                         regOut0 = regOut0;
                end
                endcase
            end
        end
    end
end

//SevSeg_4digit sevseg(clk, regOut3, regOut2, regOut1, regOut0, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, an);

endmodule

