module main
(   
input wire gpio_37, 	//enable
input wire gpio_31, 	//reset
input wire gpio_32,     //set S1
input wire gpio_27,		//change S1
output wire gpio_26, 	//green S1
output wire gpio_25, 	//yellow S1
output wire gpio_23,  	//red S1   
input wire gpio_42, 	//set S2
input wire gpio_36,   	//change S2
output wire gpio_43, 	//green S2
output wire gpio_34		//red S2
); 

//Clocks
SB_LFOSC OSCInst0(.CLKLFEN(1'b1), .CLKLFPU(1'b1), .CLKLF(CLK_10k));      
wire CLK_3M;   
SB_HFOSC OSCInst1(.CLKHFEN(1'b1), .CLKHFPU(1'b1), .CLKHF(CLK_HF));   //clock general de 48MHz
clock_divider clock3M(.clk_in(CLK_HF), .clk_out(CLK_3M));     

//wire [31:0] ms = 32'b0;
wire [31:0] ms;                                  
chronometer C1(.miliseconds(ms), .CLK(CLK_10k)); 

semaforo S1(.en(gpio_37), .reset(gpio_31), .set(gpio_32), .change(gpio_27), .clklf(CLK_10k), .green(gpio_26), .yellow(gpio_25), .red(gpio_23)); 
//instanciar 3 semaforo 
//instanciar 6 semaforo2
//instanciar cronometro
//instanciar FSM
//semaforo2 S2(.en(gpio_37), .reset(gpio_31), .set(gpio_42), .change(gpio_36), .clklf(CLK_10k), .green(gpio_43), .red(gpio_34));


endmodule     
   
//cronometro
module chronometer
(
output reg [31:0] miliseconds,
input wire CLK,   //10k
input wire reset
);      

parameter max_time = 10*1000; //10 segundos          
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
always @ (reset)
	begin
		if (reset == 1)
			miliseconds = 0;
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

