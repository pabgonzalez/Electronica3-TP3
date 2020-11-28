
/*________________________________SEMAFORO 2________________________________*/
module semaforo2     //giros y semaforos peatonales
	(
		input wire light,
		input wire clk, 
		output reg green,   
		output reg red
	);

	parameter RED = 2'b00;
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
				//$display("SEMAFORO GIRO: ROJO %d VERDE %d", red, green);
			end
		endcase	
	end
endmodule
