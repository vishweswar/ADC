`timescale 1ns/1ps  

module testbench; 

 //force CLOCK_50 via do file
 
 wire CLOCK_50, DIN, Done;
 reg DOUT;
 wire [9:0] SW_drive; 
 reg [9:0] SW;
 wire [15:0] DOUTArr;  
 wire [11:0] D;  
 wire [35:0] GPIO_0; 


 
 assign D[11:0] = 12'b111110001100; 


 int cycleCounter;  
 
 assign SW_drive[0] = 1'b1; 

 signalCaptureBlock SCB1 (.CLOCK_50(CLOCK_50), .SW(SW_drive), .DOUT(DOUT), .DIN(DIN), .Done(Done), .DOUTArr(DOUTArr), .GPIO_0(GPIO_0), .SCLK(SCLK), .CSN(CSN)); 

 
initial begin 
  
    $display("Setting ADC Channel to 100\n");
	 SW[2] = 1; //ADD0
	 SW[3] = 1; //ADD1 
	 SW[4] = 1; //ADD2
	 #25; 
	 
	 $display("Driving Enable and Reset PINS \n"); 
	 SW[0] = 1'b1; //Enable On
	 SW[1] = 1'b1;  #25; //Reset OFF	 
	 SW[1] = 1'b0;  #50; //Reset ON	 
	 SW[1] = 1'b1;  #25; //Reset OFF 
	 	 
 end 
 
 
 //Driving the cycleCounter 
 always @ (negedge CSN or negedge SCLK) begin  
	if(!CSN) begin  
		case(cycleCounter) 	
		 0: DOUT <=  1'b0; //0
		 1: DOUT <=  (SW[4] == 1'b1)?1'b1:1'b0; //ADD2
		 2: DOUT <=  (SW[3] == 1'b1)?1'b1:1'b0; //ADD1
		 3: DOUT <=  (SW[2] == 1'b1)?1'b1:1'b0; //ADD0
		 4: DOUT <=  D[11]; //Data bits 
		 5: DOUT <=  D[10]; 
		 6: DOUT <=  D[9]; 
		 7: DOUT <=  D[8]; 
		 8: DOUT <=  D[7]; 
		 9: DOUT <=  D[6]; 
		 10:DOUT <=  D[5]; 
		 11:DOUT <=  D[4]; 
		 12:DOUT <=  D[3]; 
		 13:DOUT <=  D[2]; 
		 14:DOUT <=  D[1]; 
		 15:DOUT <=  D[0];  	
		endcase 
	end 
 end 
 
 always @ (negedge SCLK or SW[1]) begin 		
	if(SW[1] == 0 || cycleCounter == 16) 
		cycleCounter <= 0; 
	else
		cycleCounter <=  cycleCounter + 1; 	
 end 
 
endmodule 