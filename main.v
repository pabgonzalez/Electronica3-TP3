module main
(   
input wire gpio_37, 	//enable
input wire gpio_42, 	//reset
input wire gpio_34, 	//change
output wire gpio_31, 	//green
output wire gpio_35, 	//yellow
output wire gpio_32,  	//red 
output reg gpio_2   //test
);
SB_LFOSC OSCInst0(.CLKLFEN(1'b1), .CLKLFPU(1'b1), .CLKLF(CLK_10k));      
wire CLK_6M;   
SB_HFOSC OSCInst1(.CLKHFEN(1'b1), .CLKHFPU(1'b1), .CLKHF(CLK_HF));   //clock general de 48MHz
clock_divider clock6M(.clk_in(CLK_HF), .clk_out(CLK_6M));     

//wire [31:0] ms = 32'b0;
wire [31:0] ms;                                  
chronometer C1(.miliseconds(ms), .CLK(CLK_10k)); 

semaforo S1(.EN(gpio_37), .RST(gpio_42), .CHANGE(gpio_34), .CLK(CLK_6M), .CHRONO(ms), .GREEN(gpio_31), .YELLOW(gpio_35), .RED(gpio_32)); 

always @ (ms)
	begin   
		if (ms < 5000)
			gpio_2 = 1;
		else 
			gpio_2 = 0;
	end    
endmodule  

//cronometro
module chronometer
(
output reg [31:0] miliseconds,
input wire CLK
);      

parameter max_time = 32'hFFFFFFFF; //10 segundos          
reg [3:0] count = 0; 
parameter cycle = 10;
always @ (posedge CLK)
	begin         
		count = count + 1;   
		if ( (count % cycle) == 0) 
			miliseconds = miliseconds + 32'b1;
		if (count >= cycle) 
			count = 0; 
		if (miliseconds >= max_time)
			miliseconds = 32'b0;              
	end
endmodule      


// DIVISOR DEL CLOCK	
module clock_divider
(   
input wire clk_in,
output reg clk_out
);        
	parameter DIVIDER = 16;
    reg [3:0] N = 4'b0;  //contador de 3 bits
    always @ (negedge clk_in)
        begin
        	N <= N + 4'b1;
         	if (N >= (DIVIDER-1))
         		N <= 4'b0;
        end  
    always @ (N)
    	begin
    		clk_out = (N<DIVIDER/2) ? 1'b0 : 1'b1;
    	end
endmodule 

/*
module semaphore_control
(                  
	input wire CLK,    
	input wire ms, 
	wire alternate,
	output wire change
);                  
	reg waiting = 0;
	reg [15:0] start = 0;
	always @ (posedge CLK)
		begin  
			if ( change )
				begin
					change = 0;
					waiting = 1;   
				end
			if ( alternate )
				begin
					change = 1;
					alternate = 0; 
				end
			else
				change = 0;    
			if ( waiting ) 
				begin
					start = ms;
					waiting = 0;
				end
		end    

endmodule     
	*/