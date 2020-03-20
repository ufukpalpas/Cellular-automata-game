`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2019 12:50:59
// Design Name: 
// Module Name: partThree
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


module partThree(input logic clk, en, get,[1:0] swt, [3:0] in, [1:0] as, 
input logic btn0, btn1, btn2, btn3, btnRst,
output logic Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, [3:0] an, [15:0] leds,
output logic[7:0] rowsOut,
output logic shcp, stcp, mr, oe, ds );

logic [3:0] regOut0; // outputs of leds
logic [3:0] regOut1;
logic [3:0] regOut2;
logic [3:0] regOut3;

logic [15:0] count = 16'b0000000000000000; // count system
logic old0, old1, old2, old3; // old button states
logic [63:0] allOut;    // 64 bit autput of 8x8 
logic[7:0][7:0] data_in = allOut; // the value that will be expressed tothe converter
logic [7:0][7:0] oldData = allOut; // to make the reset state 
logic [7:0][7:0] oldDataIn = 0; // for gameover state
int data0[15:0] = '{4,6,8,10,20,22,24,26,32,34,44,46,48,50,60,62}; //1 // positions
int data1[15:0] = '{5,7,9,11,21,23,25,27,40,42,45,47,56,58,61,63};//'{0,2,5,7,16,18,21,23,33,35,45,47,49,51,61,63}; //2
int data2[15:0] = '{0,2,13,15,16,18,29,31,36,38,41,43,52,54,57,59};//'{1,3,12,14,17,19,28,30,37,39,40,42,53,55,56,58}; //3
int data3[15:0] = '{1,3,12,14,17,19,28,30,33,35,37,39,49,51,53,55};//'{9,11,13,15,25,27,29,31,36,38,41,43,52,54,57,59}; //4
logic Q; // 1ms clock output of timer
logic r0 = 1; // 1 enable input
logic gameOver = 0; 
logic over = 0; // for restart state
logic[7:0][7:0] tempData = 0; // to ignore the affect of previous game rule implementation during the game
logic click = 0; // debouncer for buttons
//int k = 0;
//logic [7:0] temp;

//initial
//begin

//    for(int i = 0; i < 0; i = i + 1)
//    begin
//        for(int j = 0; j < 8; j = j + 1)
//        begin
//            data_in[i][j] = allOut[k];
//            k = k + 1;
//        end
//    end
    
//    for(int change = 0; change < 4; change = change + 1)
//    begin
//        for(int init = 0; init < 8; init = init + 1)
//        begin
//            temp[init] = data_in[change][init]; 
//        end
        
//        for(int init2 = 0; init2 < 8; init2 = init2 + 1)
//        begin
//           data_in[change][init2] = data_in[7-change][init2]; 
//           data_in[7-change][init2] = temp[init2];
//        end
//    end
//end

partTwo two(clk, en, over, gameOver, btn3, btnRst, count, get, swt, in, as, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, an, leds, allOut, regOut0, regOut1, regOut2, regOut3);
timer20msec timer(clk, 0, r0, Q); //this provides 1 ms clk for buttons
always_ff @( posedge Q)//Q)
begin   
       if(!btn0 & !btn2 & !btn1 & !btn3) // debouncer for the buttons
         click = 0;

       oldDataIn <= data_in; 
       if(!data_in && oldDataIn)
           gameOver = 1; // detect the finish state
           
           
        if(btnRst == 1 && !click)// reset state
        begin
            data_in = oldData;
            count = 0;  
            gameOver = 0;
            over = 0;
            click = 1;
        end
        
        
        if(gameOver == 1) // restart
        begin
            if(btn3 == 1 && !click)// && !old3)
            begin
                count = 0;
                gameOver = 0;
                over = 1;
                click = 1;
            end
        end
        
        if(gameOver == 0)
        begin
            //old0 <= btn0;
            if(btn0 && !click)// && !old0) // first state
            begin
                checkAll(data0, 16);
                count = count + 1; // increment the count
                click = 1; // debouncer
            end
            //old1 <= btn1;
            if(btn1 && !click)// && !old1) // second state
            begin
                checkAll(data1, 16);
                click = 1;
                count = count + 1;
            end
            //old2 <= btn2;
            if(btn2 && !click)// && !old2) // third state
            begin
                checkAll(data2, 16);
                click = 1;
                count = count + 1;
            end
            //old3 <= btn3;        
            if(btn3 && !click)// && !old3) // fourth state
            begin
                checkAll(data3, 16);
                count = count + 1;
                click = 1;
            end
        end
end

function automatic int modulo(input int num); // to avoid the problems that can be coused by 8. or -1. column or row
    int val = num % 8; // 8.
    if(val < 0) // -1.
        val = val + 8;
    return val;
endfunction
    
    
function automatic int checkAll (input int data[15:0], input int size);
    int row;
    int column;
    for(int i = 0; i < size; i = i + 1)
    begin 
        row = data[i] / 8; // find location of rows
        column = data[i] % 8; // find location of columns
        // right, left, top, bottom Each if statement is one of my rule 
        //data_in[row][column] = 0; (for test reasons)
        if((data_in[row][modulo(column + 1)] == 1) && (data_in[row][modulo(column - 1)] == 1) && (data_in[modulo(row + 1)][column] == 1) && (data_in[modulo(row - 1)][column] == 0))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 0) && (data_in[row][modulo(column - 1)] == 1) && (data_in[modulo(row + 1)][column] == 1) && (data_in[modulo(row - 1)][column] == 0))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 0) && (data_in[row][modulo(column - 1)] == 0) && (data_in[modulo(row + 1)][column] == 1) && (data_in[modulo(row - 1)][column] == 1))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 1) && (data_in[row][modulo(column - 1)] == 1) && (data_in[modulo(row + 1)][column] == 0) && (data_in[modulo(row - 1)][column] == 0))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 0) && (data_in[row][modulo(column - 1)] == 1) && (data_in[modulo(row + 1)][column] == 0) && (data_in[modulo(row - 1)][column] == 0))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 1) && (data_in[row][modulo(column - 1)] == 0) && (data_in[modulo(row + 1)][column] == 0) && (data_in[modulo(row - 1)][column] == 1))
            tempData[row][column] = 1; 
        else if((data_in[row][modulo(column + 1)] == 1) && (data_in[row][modulo(column - 1)] == 0) && (data_in[modulo(row + 1)][column] == 0) && (data_in[modulo(row - 1)][column] == 0))
            tempData[row][column] = 1; 
        else
            tempData[row][column] = 0; 
    end
    
    for(int say = 0; say < 16; say = say + 1) // to express to the converter without any unwanted rule effects
    begin
        row = data[say] / 8;
        column = data[say] % 8;
        data_in[row][column] = tempData[row][column];
    end
    return 1;
endfunction    

    
SevSeg_4digit sevseg(clk, regOut3, regOut2, regOut1, regOut0, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, an); // to show in 7 segment
converter conv(clk, data_in, rowsOut, shcp, stcp, mr, oe, ds );     // to show results in 8x8
endmodule

