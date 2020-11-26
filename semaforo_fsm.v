
/*________________________________SEMAFORO________________________________*/
module semaforo
	(
  		input wire en,
  		input wire reset, 
		input wire set,	
		input wire change,	
		input wire clklf, 
		output reg green,  
		output reg yellow, 
		output reg red
	);
	        
	parameter RED = 3'b001;
	parameter YELLOW = 3'b010;
	parameter GREEN = 3'b100;	
	parameter OFF = 3'b000;
	parameter ERROR = 3'b111; 

//States
	parameter [3:1] E_RED = 3'b000; 
	parameter [3:1] E_YELLOW2R = 3'b001;   
	parameter [3:1] E_YELLOW2G = 3'b010;
	parameter [3:1] E_GREEN = 3'b011;
	parameter [3:1] E_OFF = 3'b100; 
	parameter [3:1] E_ERROR = 3'b101; 
    reg [3:1] E, e;
    
//Timer
reg [15:0] counter_R2G = 16'b0; 
reg time_up_R2G = 1'b0;    
reg [15:0] counter_G2R = 16'b0; 
reg time_up_G2R = 1'b0;
  
//Next-state logic
	always @ (en, set, change, time_up_R2G, time_up_G2R) 
		begin              
			case (e)
				E_OFF:		if (en) E = (set ? E_RED : E_GREEN);
							else E = E_OFF;
				E_RED:		if (en & !change) E = E_RED;  
							else if (en & change) E = E_YELLOW2G;   
							else E = E_OFF;
				E_GREEN:	if (en & !change) E = E_GREEN;  
							else if (en & change) E = E_YELLOW2R;  
							else E = E_OFF; 
				E_YELLOW2G: if (en & time_up_R2G) E = E_GREEN;   
							else if (en & !time_up_R2G) E = E_YELLOW2G;
							else E = E_OFF;
				E_YELLOW2R: if (en & time_up_G2R)  E = E_RED;   
							else if (en & !time_up_G2R) E = E_YELLOW2R;
							else E = E_OFF;
				default:	E = E_ERROR; 
			endcase 
			
		end

//Update current state
    always @ (posedge clklf)
    	begin   
    		if (reset) e <= E_OFF;
    		else e <= E;
    		
    		//update lights
    		case (e)
    			E_OFF: 		{green, yellow, red} = OFF;
    			E_RED: 		{green, yellow, red} = RED; 
    			E_YELLOW2G: {green, yellow, red} = YELLOW;
    			E_YELLOW2R: {green, yellow, red} = YELLOW;
    			E_GREEN: 	{green, yellow, red} = GREEN;
    			E_ERROR:	{green, yellow, red} = ERROR;
    		endcase 
    		
    		//Timer 
    		if (e == E_YELLOW2R) counter_G2R = counter_G2R + 1;
    		else counter_G2R = 0;
    		if (counter_G2R >= 30000) time_up_G2R = 1;
    		else time_up_G2R = 0; 
    		
    		if (e == E_YELLOW2G) counter_R2G = counter_R2G + 1;
    		else counter_R2G = 0;
    		if (counter_R2G >= 10000) time_up_R2G = 1;
    		else time_up_R2G = 0;	
    	end  
endmodule

