/*********************************************************************************
*		Modulo fsm: 															 *
*
*
*
**********************************************************************************/



module fsm 
  ( input wire reset,  //lleva a estado base
  	input wire enable_general,	//habilitacion/deshabilitacion de sistema
  	input wire finished,  //Flag de habilitacion/deshabilitacion de clock
    input wire clk, //Clock general 10kHz
    input wire SNN, //Sensor Norton Norte
    input wire SNS,	//Sensor Norton Sur
    input wire STH,	//Sensor Thevenin
    output reg [1:0] Semaforo_NN, //Senal de estado de semaforo calle Norton Norte
    output reg [1:0] Semaforo_NS, //Senal de estado de semaforo	calle Norton Norte
    output reg [1:0] Semaforo_TH, //Senal de estado de semaforo	calle Norton Norte
    output reg [1:0] Giro_NN_izq, //Senal de estado de semaforo	Giro calle Norton izquierda
    output reg [1:0] Giro_NN_der, //Senal de estado de semaforo	Giro calle Norton derecha
    output reg [1:0] Giro_TH_izq, //Senal de estado de semaforo	Giro calle Thevenin izquierda
    output reg [1:0] Semaforo_peaton_N, //Senal de estado de semaforo peatonal Norton
    output reg [1:0] Semaforo_peaton_TH1, //Senal de estado de semaforo peatonal Thevenin 1
    output reg [1:0] Semaforo_peaton_TH2, //Senal de estado de semaforo peatonal Thevenin 1
	output reg [15:0] secondsToCount); //Tiempo de estado

	
	/*Definicion de tablas de tiempos*/

    parameter [2:1] A = 2'b00;
    parameter [2:1] B = 2'b01;
    parameter [2:1] C = 2'b10;
    parameter [2:1] D = 2'b11;	    
	
	/*Definicion de estados de semaforos*/
	parameter RED = 2'b00;
	parameter YELLOW = 2'b01;
	parameter GREEN = 2'b10;
	parameter OFF = 2'b11; 
	
	/*Declaracion de variables internas para tablas y estados*/

   	reg[3:1] tabla;
    reg[7:0] estado; 
	
	/*Declaracion de variables internas para tablas y estados*/
	
		
  	//loop de estados
	always @ (posedge clk or SNS or SNN or STH or reset or enable_general)	
		begin	
		if(enable_general == 0)
			begin
				estado <= 0; //Todo apagado hasta habilitad enable	
				secondsToCount <= 0;
			end	
		if(enable_general == 1)
			begin
			if(reset) //RESET ARRANCA EN ESTADO 1
			begin 
				tabla <= A;
		        estado <= 1;
			end
			  //CASO 4
			if(!SNS & !SNN & STH & (estado != 4))			
			begin
				tabla <= B;
				estado <= 4; //thevenin al este  
			end
			// CASO 5
			else if ( !SNS & SNN &  !STH & (estado != 10))
			begin
				tabla <= C;
				estado <= 10; //norton al norte en verde 
			end
			// CASO 6
			else if (SNS & !SNN & !STH & (estado != 7))
			begin
				tabla <= D;
				estado <= 7; //norton al sur       
			end
			// CASO 1
			else
			begin
				tabla <= A;
			end	 
			
			if(finished == 1) begin
				case(estado)
					0:
					begin
						Semaforo_NN	<= OFF;
						Semaforo_NS <= OFF;
						Semaforo_TH	<= OFF;
						Giro_NN_izq	<= OFF;
						Giro_NN_der <= OFF;
						Giro_TH_izq <= OFF;
						Semaforo_peaton_N <= OFF;
						Semaforo_peaton_TH1 <= OFF;
						Semaforo_peaton_TH2 <= OFF;
					end
					1: 
					begin
						secondsToCount <= 17;
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= GREEN;
						Semaforo_peaton_N <= RED;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= RED;
						estado <= estado + 1;
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end		  		
					2:
					begin  
						secondsToCount <= 3;
					    Semaforo_NN <= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= GREEN;
						Semaforo_peaton_N <= RED;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= GREEN; 
	                    estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end	
					3:
					begin  
						secondsToCount <= 1;
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= YELLOW;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= RED;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= GREEN; 
						$display("ESTADO %d", estado);
						estado <= estado + 1;
						$display("TIEMPO %d", secondsToCount);
					end
					4:	 
					begin 	   
						case(tabla)
							A: secondsToCount <= 55;
							B: secondsToCount <= 5;
							C: secondsToCount <= 27;
							D: secondsToCount <= 27;
						endcase		
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= GREEN;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;
						Semaforo_peaton_N <= RED;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= GREEN; 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end	 
					5: 
					begin 
						secondsToCount <= 3;	
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= YELLOW;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;
						Semaforo_peaton_N <= RED;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= GREEN; 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end
					6:
					begin  
						secondsToCount <= 1;	
						Semaforo_NN	<= RED;
						Semaforo_NS <= YELLOW ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= GREEN;
						Semaforo_peaton_TH1 <= RED;
						Semaforo_peaton_TH2 <= RED; 
						estado <= estado + 1;	  
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end
					7: 
					begin 
					case(tabla)
						A: secondsToCount <= 27;
						B: secondsToCount <= 14;
						C: secondsToCount <= 14;
						D: secondsToCount <= 54;
					endcase		
					Semaforo_NN	<= RED;
					Semaforo_NS <= GREEN ;
					Semaforo_TH	<= RED;
					Giro_NN_izq	<= RED;
					Giro_NN_der <= RED;
					Giro_TH_izq <= RED;
					Semaforo_peaton_N <= GREEN;
					Semaforo_peaton_TH1 <= RED;
					Semaforo_peaton_TH2 <= RED; 
					estado <= estado + 1;	 
					$display("ESTADO %d", estado);
					$display("TIEMPO %d", secondsToCount);
					end
					8:
					begin 
						secondsToCount <= 3;
						Semaforo_NN	<= RED;
						Semaforo_NS <= YELLOW ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= GREEN;
						Semaforo_peaton_TH1 <= RED;
						Semaforo_peaton_TH2 <= RED; 
						estado <= estado + 1;	 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end
					9:
					begin 
						secondsToCount <= 1;
						Semaforo_NN	<= YELLOW;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= GREEN;
						Semaforo_peaton_TH1 <= RED;
						Semaforo_peaton_TH2 <= RED; 
						estado <= estado + 1;	 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end
					10:
					begin  
						case(tabla)
							A: secondsToCount <= 24;
							B: secondsToCount <= 12;
							C: secondsToCount <= 48;
							D: secondsToCount <= 12;
						endcase		
						Semaforo_NN	<= GREEN;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= GREEN;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= GREEN;
						Semaforo_peaton_TH1 <= RED;
						Semaforo_peaton_TH2 <= RED; 
						estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end
					11:
					begin 
						secondsToCount <= 3;	
						Semaforo_NN	<= YELLOW;
						Semaforo_NS <= RED;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= RED;
						Semaforo_peaton_N <= GREEN;
						Semaforo_peaton_TH1 <= GREEN;
						Semaforo_peaton_TH2 <= RED; 
						estado <= 1;
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", secondsToCount);
					end	 
				endcase
			end	
		end
	end
endmodule 

/*
module time_fsm
(
input start_clock,
input wire reset,
input wire CLK,   //10k
input reg [15:0] secondsToCount, 
output reg finished
);      

//parameter max_time = 200*1000; //200 segundos          
reg [15:0] count;
reg [15:0] seconds;
reg [7:0] countSeconds;
parameter MAX = 9999; 

always @ (posedge CLK && secondsToCount) 
	begin
			$display("ARRANCA%d", secondsToCount);  
			finished <= 0;   
			count <= count + 1;	  
			$display("count %d", count); 
			if (count == MAX) begin
				seconds <= seconds + 1;
				count <= 0; 
				$display("seconds %d", seconds);
			end		 
			else if (seconds == (secondsToCount))
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
endmodule      */

/*
module testfsm();
	
   	reg CLK_10k;
	reg [15:0] seconds;
	reg reset;  
	reg finished;	  
	time_fsm C1(.reset(reset), .secondsToCount (seconds), .CLK(CLK_10k), .finished(finished)); 	  
	
	
	reg SNN_test;
	reg STH_test;
	reg SNS_test;	
	wire NN_red, NN_yellow, NN_green; //semáforo Norton al Norte
	wire NS_red, NS_yellow, NS_green; //semáforo Norton al Sur
	wire TH_red, TH_yellow, TH_green; //semáforo Thevenin
	
	wire GNNL_red, GNNL_green; //semáforo Norton al Norte
	wire GNNR_red, GNNR_green; //semáforo Norton al Sur
	wire GTH_red, GTH_green; //semáforo Thevenin	
	
	wire [1:0] lightTH;
	wire [1:0] lightNN;
	wire [1:0] lightNS;
	wire [1:0] lightGTH;
	wire [1:0] lightGNN_R;
	wire [1:0] lightGNN_L;
	
	fsm fsmGeneral(
		.clk(CLK_10k),
		.SNN(SNN_test), 
	    .SNS(SNS_test),
	    .STH(STH_test),
	    .Semaforo_NN(lightNN), 
	    .Semaforo_NS(lightNS),
	    .Semaforo_TH(lightTH),
	    .Giro_NN_izq(lightGNN_L),
	    .Giro_NN_der(lightGNN_R),
	    .Giro_TH_izq(lightGTH),
		.timer(seconds), 
		.reset(reset),
		.finished(finished));	


	initial begin
		CLK_10k=0;
		forever #100000ns CLK_10k = ~ CLK_10k;
	end											 


	initial begin
		reset = 1; 
		#1s
		STH_test =1;
		SNN_test =0;
		SNS_test =0;
		
		#100s
		/*
		STH_test =0;
		SNN_test =1;
		SNS_test =0;
		#100s  
		$finish;
	end
		
endmodule  */