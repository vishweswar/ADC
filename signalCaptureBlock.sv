`timescale 1ns/1ps  


module signalCaptureBlock(CLOCK_50, GPIO_0, SW); 
  
  //**************************CLOCKGENERATOR PARAMETERS**************************** 
  parameter integer clockPeriodNS = 60; 	         //needs to be a multiple of 20ns 
  parameter integer cycleCountMax = 3;             //ceil(clockPeriodNS/20); 		  	
  parameter integer clockCounterSize = 2;          //log2(cycleCountMax); 				
  parameter integer  fullCycles = 2; 			      //cycleCountMax - 1;
  parameter integer  halfCycles = 1;				   //ceil(fullCycles/2); 
  //*******************************************************************************
  
  //**************************CLOCKGENERATOR PARAMETERS**************************** 
  parameter integer overFlow = 19;              //cycles for the bitpattern	
  parameter integer counterWidth = 5; 	         //ceil(log2(overFlow))   	
  //*******************************************************************************

  input CLOCK_50;
  input SW[9:0];  
  inout [35:0] GPIO_0; 
  
 
  wire CLOCK_50; 
  wire resetN; 
  wire Enable; 

  
  assign resetN = (SW[1] == 1'b1)?1'b1:1'b0; 
  assign Enable = (SW[0] == 1'b1)?1'b1:1'b0; 
  
  wire SCLK; 
  
  //*************************CLOCKGENERATOR OBJECT***********************************  
  wire [clockCounterSize - 1:0] sclkCounter;  
  clockGenerator #(.clockCounterSize(clockCounterSize), .fullCycles(fullCycles), .halfCycles(halfCycles)) CG1 (.fastClk(CLOCK_50), .SCLK(SCLK), .clkGenEn(Enable), .resetN(resetN), .sclkCounter(sclkCounter));
  //*********************************************************************************

  //*************************CLOCKCOUNTER OBJECT***********************************  
  wire [counterWidth - 1: 0] bitCounter; 
  clockCounter #(.counterWidth(counterWidth), .overFlow(overFlow)) CC1 (.SCLK(SCLK), .counterValue(bitCounter), .resetN(resetN), .clockCounterEn(Enable)); 
  //*******************************************************************************  
  
endmodule 


module clockCounter #(parameter integer counterWidth = 5, parameter integer overFlow = 19)(SCLK, counterValue, resetN, clockCounterEn); 

	//clockCounter counts the SCLK and stores the value in CounterValue
	
	input SCLK; 
	input resetN; 
	input clockCounterEn; 
	output counterValue; 
	
	reg [counterWidth - 1: 0] counterValue; 
	
	always @ (posedge SCLK or resetN) begin 		
		if(clockCounterEn == 1'b1) begin 
			if(!resetN || counterValue == overFlow) 
				counterValue <= 0; 
			else 
				counterValue <= counterValue + 1'b1; 		
		end 
	end 
	
endmodule 


module clockGenerator #(parameter integer clockCounterSize = 4, parameter integer fullCycles = 2, parameter integer halfCycles = 3)(fastClk, SCLK, clkGenEn, resetN, sclkCounter); 

	//clock generator to generate 1/clockPeriodNS MHz from 50MHz	

   input fastClk;
	input clkGenEn;
	input resetN; 
	
	output sclkCounter; 
	output SCLK; 
	

	wire SCLK; 
   reg [clockCounterSize - 1:0] sclkCounter;    
	
	assign SCLK = (sclkCounter < halfCycles)? 1'b0 : 1'b1;  
	
	always @ (posedge fastClk) begin    
		if(clkGenEn == 1'b1) begin 	
			 if(!resetN || sclkCounter == fullCycles) 
				sclkCounter <= 0; 
			 else 
				sclkCounter <= sclkCounter + 1'b1; 
			end  
	end 
	
endmodule 


