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
<<<<<<< HEAD
  parameter integer overFlow = 19;              //cycles for the bitpattern	
=======
  parameter integer overFlow = 16;              //cycles for the bitpattern	
>>>>>>> 0ade061 (DIN Bits Firing as intended)
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
<<<<<<< HEAD
=======

>>>>>>> 0ade061 (DIN Bits Firing as intended)
  
  wire SCLK; 
  
  //*************************CLOCKGENERATOR OBJECT***********************************  
  wire [clockCounterSize - 1:0] sclkCounter;  
  clockGenerator #(.clockCounterSize(clockCounterSize), .fullCycles(fullCycles), .halfCycles(halfCycles)) CG1 (.fastClk(CLOCK_50), .SCLK(SCLK), .clkGenEn(Enable), .resetN(resetN), .sclkCounter(sclkCounter));
  //*********************************************************************************

  //*************************CLOCKCOUNTER OBJECT***********************************  
  wire [counterWidth - 1: 0] bitCounter; 
  clockCounter #(.counterWidth(counterWidth), .overFlow(overFlow)) CC1 (.SCLK(SCLK), .counterValue(bitCounter), .resetN(resetN), .clockCounterEn(Enable)); 
  //*******************************************************************************  
  
<<<<<<< HEAD
endmodule 


module clockCounter #(parameter integer counterWidth = 5, parameter integer overFlow = 19)(SCLK, counterValue, resetN, clockCounterEn); 
=======
  //*************************DINLogic**********************************************
  wire DIN; 
  wire CSN; 
  wire [2:0] channelSelect;
  
  //Select the channel of the ADC through the switches 
  assign channelSelect[0] = SW[2]; 
  assign channelSelect[1] = SW[3];
  assign channelSelect[2] = SW[4];
  DINLogic DIN1(.channelSelect(channelSelect), .counterValue(bitCounter), .Enable(Enable), .resetN(resetN), .SCLK(SCLK), .CSN(CSN), .DIN(DIN));
  //*******************************************************************************
  
  assign GPIO_0[0] = SCLK; 
  assign GPIO_0[1] = DIN; 
  assign GPIO_0[2] = CSN;
  
endmodule 

module DOUTLogic(SCLK, CSN, DOUT, Enable, counterValue, resetN, Done, DOUTArr);
	
	//Appends the DOUT value to the DOUTArr serially
	
	input SCLK; 
	input CSN; 
	input DOUT;
	input Enable; 
	input resetN;
   input [4:0] counterValue; 
 
	
	output DOUTArr; 
	output Done; 
	
	reg [15:0] DOUTArr; 
	reg Done; 
	
	always @ (posedge SCLK) begin 
	
		if(Enable && !CSN && resetN) begin 
			Done <= 1'b0; 
			case(counterValue) 			
			4'd0: DOUTArr[15] <= DOUT; //0
			4'd1: DOUTArr[14] <= DOUT; //ADD2
			4'd2: DOUTArr[13] <= DOUT; //ADD1
			4'd3: DOUTArr[12] <= DOUT; //ADD0
			4'd4: DOUTArr[11] <= DOUT; //D11
			4'd5: DOUTArr[10] <= DOUT; //D10
			4'd6: DOUTArr[9] <= DOUT;  //D9
			4'd7: DOUTArr[8] <= DOUT;  //D8
			4'd8: DOUTArr[7] <= DOUT;  //D7
			4'd9: DOUTArr[6] <= DOUT;  //D6
			4'd10:DOUTArr[5] <= DOUT;  //D5
			4'd11:DOUTArr[4] <= DOUT ; //D4
			4'd12:DOUTArr[3] <= DOUT ; //D3
			4'd13:DOUTArr[2] <= DOUT ; //D2
			4'd14:DOUTArr[1] <= DOUT ; //D1
			4'd15: begin
						DOUTArr[0] <= DOUT ; //D0
						Done <= 1'b1; 
					end
			default:DOUTArr <= 16'b0 ;			
			endcase 
		end 	
		 else 
			DOUTArr <= 16'b0; 
	end 
endmodule 

module DINLogic(channelSelect, counterValue, Enable, resetN, SCLK, CSN, DIN);

	//DINLogic to send the correct bits at the correct clock cycle 
	//counter size is 5 bits to accomodate 19 clock cycles 
	
	input [2:0] channelSelect; //XYZ for Channel Select 
	input [4:0] counterValue; 
	input Enable; 
	input resetN; 
	input SCLK; 

	output CSN; 
	output DIN; 
		
   reg CSN;
	reg DIN; 
		
	
	always @ (SCLK) begin 	
		if(!resetN || counterValue == 5'd16)
			CSN <= 1'b1; 
		else if(counterValue == 5'd1)
			CSN <= 1'b0;
		else 
			CSN <= 1'b0; 
	end
		
	always @ (posedge SCLK) begin	
	if(Enable) begin 
		case(counterValue) 		
		4'd0: DIN <= 1'b1;  //WRITE
		4'd1: DIN <= 1'b0;  //SEQ
		4'd2: DIN <= 1'b0;  //DONTC
		4'd3: DIN <= channelSelect[2];  //ADD2
		4'd4: DIN <= channelSelect[1];  //ADD1
		4'd5: DIN <= channelSelect[0];  //ADD0
		4'd6: DIN <= 1'b1;  //PM1
		4'd7: DIN <= 1'b1;  //PM0
		4'd8: DIN <= 1'b0;  //SHADOW
		4'd9: DIN <= 1'b0; //DONTC
	   4'd10: DIN <= 1'b1; //RANGE (0 for 0 to 2 x REFvin)	
		4'd11: DIN <= 1'b0; //CODING (0 for Two's Complement)
		default: DIN <= 1'b0;  			
		endcase 
	 end		
	end 

endmodule  

module clockCounter #(parameter integer counterWidth = 5, parameter integer overFlow = 17)(SCLK, counterValue, resetN, clockCounterEn); 
>>>>>>> 0ade061 (DIN Bits Firing as intended)

	//clockCounter counts the SCLK and stores the value in CounterValue
	
	input SCLK; 
	input resetN; 
	input clockCounterEn; 
	output counterValue; 
	
	reg [counterWidth - 1: 0] counterValue; 
	
<<<<<<< HEAD
	always @ (posedge SCLK or resetN) begin 		
=======
	always @ (negedge SCLK) begin 		
>>>>>>> 0ade061 (DIN Bits Firing as intended)
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
	
<<<<<<< HEAD
	assign SCLK = (sclkCounter < halfCycles)? 1'b0 : 1'b1;  
=======
	assign SCLK = (sclkCounter >= halfCycles)? 1'b1 : 1'b0;  
>>>>>>> 0ade061 (DIN Bits Firing as intended)
	
	always @ (posedge fastClk) begin    
		if(clkGenEn == 1'b1) begin 	
			 if(!resetN || sclkCounter == fullCycles) 
				sclkCounter <= 0; 
			 else 
				sclkCounter <= sclkCounter + 1'b1; 
			end  
	end 
	
endmodule 


<<<<<<< HEAD
=======

>>>>>>> 0ade061 (DIN Bits Firing as intended)
