
/*________________________________SEMAFORO 2________________________________*/
module semaforo2     //giros y semaforos peatonales
	(
  		//input wire en,
  		//input wire reset, 
		//input wire set,	
		//input wire change,
		input wire light,
		input wire clk, 
		output reg green,   
		output reg red
	);

	parameter RED = 2'b00;
	parameter YELLOW = 2'b01;
	parameter GREEN = 2'b10;
	
	always @ (posedge clk)
	begin 
		case(light)	 
			RED: 
			begin
				red <= 1;
				green <= 0;
			end
			GREEN:
			begin
				red <= 0;
				green <= 1;
			end
			default:
			begin
				red <= 0;
				green <= 0;
			end
		endcase	
	end
	/*
	parameter RED = 3'b01;
	parameter GREEN = 3'b10;	
	parameter OFF = 3'b00;
	parameter ERROR = 3'b11; 

//States
	parameter [2:1] E_RED = 3'b01; 
	parameter [2:1] E_GREEN = 3'b10;
	parameter [2:1] E_OFF = 3'b00; 
	parameter [2:1] E_ERROR = 3'b11; 
    reg [3:1] E, e;				   */
  
//Next-state logic
/*	always @ (en, set, change) 
		begin              
			case (e)
				E_OFF:		if (en) E = (set ? E_RED : E_GREEN);
							else E = E_OFF;
				E_RED:		if (en & !change) E = E_RED;  
							else if (en & change) E = E_GREEN;   
							else E = E_OFF;
				E_GREEN:	if (en & !change) E = E_GREEN;  
							else if (en & change) E = E_RED;  
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
    			E_OFF: 		{green, red} = OFF;
    			E_RED: 		{green, red} = RED; 
    			E_GREEN: 	{green, red} = GREEN;
    			E_ERROR:	{green, red} = ERROR;
    		endcase 	
    	end    */
endmodule
