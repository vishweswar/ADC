`timescale 1ns/1ps  

module signalCaptureBlock(CLOCK_50, clkCounterEn); 


  input CLOCK_50; 
  input clkCounterEn; 
  
  //wire CLOCK_50; 
  wire clkCounterEn; 
  wire invertedClk; 
  wire SCLK; 
  
  clockGenerator C1 (.fastClk(CLOCK_50), .fastClk_N(invertedClk), .SCLK(SCLK), .clkCounterEn(clkCounterEn));
  
endmodule 




module clockGenerator(fastClk, fastClk_N, SCLK, clkCounterEn); //clock generator to generate 20MHz from 50MHz

	input fastClk;
	input clkCounterEn;
   output SCLK; 

	output wire fastClk_N; 
	reg SCLK; 

		
	assign fastClk_N = (clkCounterEn == 1'b1)?(~fastClk):1'b0; //inverted fastClock
	
endmodule 