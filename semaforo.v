module semaforo
	(				
	input wire EN, //enable
	input wire RST,	//reset
	input wire CHANGE,	//change 
	input wire CLK,  
	input wire [31:0] CHRONO,
	output reg GREEN, //green 
	output reg YELLOW, //yellow
	output reg RED	//red     
	//output reg test
	);	

parameter red = 3'b001;
parameter yellow = 3'b010;
parameter green = 3'b100;	
parameter apagar = 3'b000;
parameter error = 3'b111;
parameter yellow_total_time = 3000;        
reg pass = 1;
reg prev_change = 0; 
reg [31:0] start_CHRONO = 0;          
                
always @ (posedge CLK)
	begin      
		if(!EN)      //apago
			{GREEN,YELLOW,RED} = apagar;	 
		else if(EN & RST)		//reseteo
			{GREEN,YELLOW,RED} = red; 
		else if(EN & CHANGE & !RST & ({GREEN,YELLOW,RED} != yellow))
			prev_change = CHANGE;   
		else if( EN & !CHANGE & !RST & (prev_change | ({GREEN,YELLOW,RED} == yellow)) )	
			begin                           
				prev_change = 0;
				case ({GREEN,YELLOW,RED})
					red: begin {GREEN,YELLOW,RED} = yellow; pass = 1; start_CHRONO = CHRONO;	end
					green: begin {GREEN,YELLOW,RED} = yellow; pass = 0; start_CHRONO = CHRONO; end
					//yellow: begin {GREEN,YELLOW,RED} = pass ? green : red; end 
					yellow:
						begin                                              
							//test = 0;
							if (CHRONO >= (start_CHRONO + yellow_total_time))
								begin
									prev_change = 1;
									start_CHRONO = 0;
									{GREEN,YELLOW,RED} = ( pass ? green : red ); 
								end     
						   //	if ( start_CHRONO + yellow_total_time > 10000 )
								//test = 1;    
						   //	else 
								//test = 0;
						end
					apagar: {GREEN,YELLOW,RED} = apagar;  
					default: {GREEN,YELLOW,RED} = error;
				endcase	  	
			end
	end
endmodule  
