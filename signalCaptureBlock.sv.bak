`timescale 1ns/1ps  

module signalCaptureBlock(CLOCK_50, clkCounterEn); 
  
  parameter clockPeriodNS = 80; //needs to be a multiple of 20ns
  parameter integer cycleCountMax = $ceil(clockPeriodNS/20); 
  parameter clockCounterSize = $clog2(cycleCountMax); 
  

  input CLOCK_50; 
  input clkCounterEn; 
  
  wire [clockCounterSize - 1:0] sclkCounter; 
	
  wire CLOCK_50; 
  wire clkCounterEn; 
  wire SCLK; 
  wire resetN; 
  
  
  clockGenerator #(.clockCounterSize(clockCounterSize), .cycleCountMax(cycleCountMax)) C1 (.fastClk(CLOCK_50), .SCLK(SCLK), .clkCounterEn(clkCounterEn), .resetN(resetN), .sclkCounter(sclkCounter));
  
endmodule 


module clockGenerator #(parameter clockCounterSize = 2, parameter cycleCountMax = 3)(fastClk, SCLK, clkCounterEn, resetN, sclkCounter); 

	//clock generator to generate 1/clockPeriodNS MHz from 50MHz	

	parameter fullCycles = cycleCountMax - 1;
	parameter halfCycles = $ceil(cycleCountMax/2); 

   input fastClk;
	input clkCounterEn;
	input resetN; 
	
	output sclkCounter; 
	output SCLK; 
	

	wire SCLK; 
   reg [clockCounterSize - 1:0] sclkCounter;    
	
	assign SCLK = (sclkCounter < halfCycles)? 1'b0 : 1'b1;  
	
	always @ (posedge fastClk) begin    
		if(clkCounterEn == 1'b1) begin 	
			 if(!resetN | sclkCounter == fullCycles) 
				sclkCounter <= 0; 
			 else 
				sclkCounter <= sclkCounter + 1'b1; 
			end  
	end 
	
endmodule 