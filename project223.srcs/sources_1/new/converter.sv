module converter(input logic clk, input logic [7:0][7:0] data_in,
     output logic[7:0] rowsOut,
     output logic shcp, stcp, mr, oe, ds );

     logic [7:0][7:0] data;
     always_comb
     for(int k=0; k<8; k++)
     for(int j=0; j<8; j++)
     begin
         data[7-j][k]=data_in[k][j];
     end

     logic f;
     logic [23:0] dstotal;

     int i; logic [2:0] a = 0;

     assign dstotal =  {data[a][7:0],16'b0};
      logic [7:0] counter =0;

       always_ff@(posedge clk)
       counter <= counter+1;

       assign f = counter[7];

       always_ff@(negedge f)
       if(i==410)
       i<=1;
       else
       i <= i+1;

       always_ff@(negedge clk)
       if(i<28)
       begin
       shcp<=f;
       stcp<=~f;
       end
       else
       begin
       shcp<=0;
       stcp<=1;
       end


       always_ff@(posedge f)
           if(i>28 && i<409)
           oe <= 0;
           else
           oe<= 1;

     always_ff@(negedge f)
     begin
     if(i<3)
     mr<=0;
     else
     mr<=1;
     if(i>2&&i<27)
     ds <= dstotal[i-3];
     else
     ds <=0;
     if(i==410) a <= a+1;
     end




     always_comb
     case(a)
     0: rowsOut = 1;
     1: rowsOut = 2;
     2: rowsOut = 4;
     3: rowsOut = 8;
     4: rowsOut = 16;
     5: rowsOut = 32;
     6: rowsOut = 64;
     7: rowsOut = 128;
     default: rowsOut = 0;
     endcase

endmodule