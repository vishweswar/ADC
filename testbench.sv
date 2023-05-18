`timescale 1ns/1ps  

module testbench; 

 //force CLOCK_50 via do file
 
 wire CLOCK_50, DIN, Done;
 reg DOUT;
 wire [9:0] SW_drive;// SW1, SW2, SW3, SW4; 
 reg [9:0] SW;
 wire [15:0] DOUTArr;  
 wire [11:0] D;  
 wire [35:0] GPIO_0; 


 
 assign D[11:0] = 12'b110111111111; 
 
 assign SW_drive[0] = (SW[0] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[1] = (SW[1] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[2] = (SW[2] == 1'b1)? 1'b1:1'b0;
 assign SW_drive[3] = (SW[3] == 1'b1)? 1'b1:1'b0;  
 assign SW_drive[4] = (SW[4] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[5] = (SW[5] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[6] = (SW[6] == 1'b1)? 1'b1:1'b0;
 assign SW_drive[7] = (SW[7] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[8] = (SW[8] == 1'b1)? 1'b1:1'b0; 
 assign SW_drive[9] = (SW[9] == 1'b1)? 1'b1:1'b0; 

 
 int cycleCounter;  
 
 //assign SW_drive[0] = 1'b1; 

 signalCaptureBlock SCB1 (.CLOCK_50(CLOCK_50), .SW(SW_drive), .DOUT(DOUT), .DIN(DIN), .Done(Done), .DOUTArr(DOUTArr), .GPIO_0(GPIO_0), .SCLK(SCLK), .CSN(CSN)); 

 //.SW1(SW1),  .SW2(SW2),  .SW3(SW3),  .SW4(SW4),
initial begin 

    $display("Driving Enable and SCLKReset PINS \n"); 
	 SW[0] = 1'b1; //Enable On
	 SW[0] = 1'b1; //Enable On
	 
	 SW[9] = 1'b1;  #25; //Reset OFF	 
	 SW[9] = 1'b0;  #50; //Reset ON	 
	 SW[9] = 1'b1; #50; //Reset OFF 
	 
 
    $display("Setting ADC Channel to 100\n");
	 SW[2] = 0; //ADD0
	 SW[3] = 1; //ADD1 
	 SW[4] = 0; //ADD2
	 
	 $display("Driving Reset PIN \n"); 	 
	 SW[1] = 1'b1;  #25; //Reset OFF	 
	 SW[1] = 1'b0;  #50; //Reset ON	 
	 SW[1] = 1'b1; #50; //Reset OFF 	
	 #500; 
	
	 SW[1] = 1'b0;  #50; //Reset ON	 
	 SW[1] = 1'b1; #50; //Reset OFF 
	 	 
 end 
 
 
 //Driving the cycleCounter 
 always @ (negedge SCLK) begin  
	if(!CSN) begin  
		case(cycleCounter) 	
		 17:DOUT <=  1'b0; 
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
 
 always @ (negedge SCLK) begin 		
	if(CSN || cycleCounter == 17) 
		cycleCounter <= 0; 
	else
		cycleCounter <=  cycleCounter + 1; 	
 end 
 
endmodule 