//cronometro
module chronometer
(

input wire reset,
input wire CLK,   //10k
input reg [15:0] secondsToCount, 
output reg finished
);      

//parameter max_time = 200*1000; //200 segundos          
reg [15:0] count = 0;
reg [15:0] seconds = 0;
reg [7:0] countSeconds;
parameter MAX = 9999;


always @ (posedge CLK)
	begin     
		count = count + 1;    
		if (count == MAX) begin
			seconds = seconds + 1;
			count = 0; 
			$display("seconds %d", seconds);
		end		 
		if (seconds == secondsToCount)
			begin  
			seconds = 0;
			finished <= 1;
			$display("Se termino");	
			$display("TERMINOOOOOOOOOOOOOO %d", finished);
			end
	end            
	
always @ (posedge reset)
		if ( reset == 1)  
		begin 
			seconds <= 0;  
			count <= 0;
			finished <= 0;
		end
endmodule      

module testTimer1();
	
	reg CLK_10k;
	reg [31:0] seconds;
	reg reset;
	wire finished;
	chronometer test (.CLK(CLK_10k), .secondsToCount(seconds), .reset(reset), .finished(finished)); 


	initial begin
		CLK_10k <=0;	
	end
	always #100000ns CLK_10k = ~ CLK_10k;											 

	
	initial begin 
		seconds <= 2;
		#5s
		reset = 1;
		seconds <= 3; 
		#10s
		$finish;
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