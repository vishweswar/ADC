`timescale 1ns/1ps  

module signalCaptureBlock(CLOCK_50, clkCounterEn); 


  input CLOCK_50; 
  input clkCounterEn; 
 
  
  
  wire CLOCK_50; 
  wire clkCounterEn; 
  wire SCLK; 
  wire resetN; 
  
  clockGenerator C1 (.fastClk(CLOCK_50), .SCLK(SCLK), .clkCounterEn(clkCounterEn), .resetN(resetN));
  
endmodule 




module clockGenerator #(parameter clockPeriodNS = 50)(fastClk, SCLK, clkCounterEn, resetN); 

	//clock generator to generate 1/clockPeriodNS MHz from 50MHz
	//the clockPeriodNS needs to be a multiple of 10 for accuracy 

   localparam clockCounterMax = clockPeriodNS/10 - 1;  
	localparam clockCounterSize = $clog2(clockPeriodNS/10); 
	localparam binCCS = {clockCounterSize{1'b1}}; 
	
	input fastClk;
	input clkCounterEn;
	input resetN; 
   output SCLK; 

	reg [clockCounterSize -1:0] SCLK;    
		
	//assign fastClk_N = (clkCounterEn == 1'b1)?(~fastClk):1'b0; //inverted fastClock
	
	always @ (fastClk) begin 

	 if(!resetN | SCLK == binCCS)
		SCLK <= 0; 
	 else  
	   SCLK <= SCLK + 1'b1;
	 
	end 
	
endmodule 