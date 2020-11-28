module time_fsm
(
input wire reset,
input wire CLK,   //10k
input reg [15:0] secondsToCount, 
output reg finished
);      

//parameter max_time = 200*1000; //200 segundos          
reg [15:0] count;
reg [15:0] seconds;
reg [7:0] countSeconds;
parameter MAX = 10000;  


always @ (posedge CLK && secondsToCount) 
	begin 	

			finished <= 0;   
			count <= count + 1;	  
			//$display("count %d", count); 
			if (count == MAX) begin 
				seconds <= seconds + 1;
				count <= 0; 
				$display("seconds %d", seconds);
			end		 
			else if (seconds == secondsToCount)
				begin 
				count <= 0;
				seconds <= 0;
				finished <= 1;
				$display("Se termino");	
				$display("TERMINOOOOOOOOOOOOOO %d", finished);
				end	
			//end 
		end
	
	always @(reset)
		begin  
		$display("Estoy en reset");
		seconds <= 0;  
		count <= 0;
		finished <= 1;
		end
endmodule      