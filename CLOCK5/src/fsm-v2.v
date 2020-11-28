module fsm 
  ( input wire reset,
  	input wire finished,
    //input wire red_check_SemaforoNN_E6,
    //input wire [31:0] ms, //milisecond
    input wire clk, //10kHz
    input wire SNN, //sensor Norton Norte
    input wire SNS,
    input wire STH,
	/*
    input wire PNN, //Pulsador Norton Norte
    input wire PNS,
    input wire PTH,	   */

    output reg [2:0] Semaforo_NN, //change S1
    output reg [2:0] Semaforo_NS,
    output reg [2:0] Semaforo_TH,
    output reg [2:0] Giro_NN_izq,
    output reg [2:0] Giro_NN_der,
    output reg [2:0] Giro_TH_izq,
    /*output reg [2:0] Semaforo_peaton_N,
    output reg [2:0] Semaforo_peaton_TH1,
    output reg [2:0] Semaforo_peaton_TH2,	  */
	/*
    output reg set_Semaforo_NN, //change S1
    output reg set_Semaforo_NS,
    output reg set_Semaforo_TH,
    output reg set_Giro_NN_izq,
    output reg set_Giro_NN_der,
    output reg set_Giro_TH_izq,
    output reg set_Semaforo_peaton_N,
    output reg set_Semaforo_peaton_TH1,
    output reg set_Semaforo_peaton_TH2,	   */

    //input wire reset_general,
    //input wire enable_general	 
	output reg [15:0] timer
  );

  //Elemento que contarï¿½ los segundos

   // timeCounter myTimeCounter ()  

    parameter [2:1] A = 2'b00;
    parameter [2:1] B = 2'b01;
    parameter [2:1] C = 2'b10;
    parameter [2:1] D = 2'b11;	  
	
    parameter [2:1] initialStateB = 3;
    parameter [2:0] initialStateC = 5;
    parameter [2:0] initialStateD = 4;	  
	
	parameter RED = 2'b00;
	parameter YELLOW = 2'b01;
	parameter GREEN = 2'b10;

   	reg[3:1] tabla;
    reg[7:0] estado; 
 /*
	initial begin
	finished = 1;
	tabla = A;
	estado = 1;
	end	   			   */ 	   
	
   initial begin
	    timer <= 0; 
   end 

 always @ ((SNS & SNN & STH) or reset)	 
	 begin	
 			if(reset) //RESET ARRANCA EN ESTADO 1
			begin 
				tabla <= A;
                estado <= 1;
				Semaforo_NN	<= RED;
				Semaforo_NS <= RED;
				Semaforo_TH	<= RED;
				Giro_NN_izq	<= RED;
				Giro_NN_der <= GREEN;
				Giro_TH_izq <= GREEN;
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
end	  
		
  //loop de estados
	always @ (posedge clk)	
		begin
			if(finished == 1) begin
				  case(estado)
					1: 
					begin
						timer <= 17;
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= GREEN;
	                    estado <= estado + 1; 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end		  		
					2:
					begin  
						timer <= 3;
					    Semaforo_NN <= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= GREEN;
	                    	estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end	
					3:
					begin  
						timer <= 1;
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= YELLOW;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;	
						$display("ESTADO %d", estado);
						estado <= estado + 1;	
						$display("TIEMPO %d", timer);
					end
					4:	 
					begin 	   
						case(tabla)
							A: timer <= 55;
							B: timer <= 5;
							C: timer <= 27;
							D: timer <= 27;
						endcase		
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= GREEN;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end	 
					5: 
					begin 
						timer <= 3;	
						Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= YELLOW;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end
					6:
					begin  
						timer <= 1;	
						Semaforo_NN	<= RED;
						Semaforo_NS <= YELLOW ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	  
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end
					7: 
					begin 
					case(tabla)
						A: timer <= 27;
						B: timer <= 14;
						C: timer <= 14;
						D: timer <= 54;
					endcase		
					Semaforo_NN	<= RED;
					Semaforo_NS <= GREEN ;
					Semaforo_TH	<= RED;
					Giro_NN_izq	<= RED;
					Giro_NN_der <= RED;
					Giro_TH_izq <= RED;
					estado <= estado + 1;	 
					$display("ESTADO %d", estado);
					$display("TIEMPO %d", timer);
					end
					8:
					begin 
						timer <= 3;
						Semaforo_NN	<= RED;
						Semaforo_NS <= YELLOW ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end
					9:
					begin 
						timer <= 1;
						Semaforo_NN	<= YELLOW;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	 
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end
					10:
					begin  
						case(tabla)
							A: timer <= 24;
							B: timer <= 12;
							C: timer <= 48;
							D: timer <= 12;
						endcase		
						Semaforo_NN	<= GREEN;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= GREEN;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= RED;
						estado <= estado + 1;	
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end
					11:
					begin 
						timer <= 3;	
						Semaforo_NN	<= YELLOW;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= RED;
						estado <= 1;
						$display("ESTADO %d", estado);
						$display("TIEMPO %d", timer);
					end	 
				endcase
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