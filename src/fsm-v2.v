module fsm
  (
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
	output reg [7:0] timer,
    output reg reset,
    output reg finished
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

  //Tabla de tiempos del estado 1
 /* 

    reg [7:0][3:0] time_E1;
    initial begin
        time_E1[0] = 8'd17; //Tabla A
        time_E1[1] = 8'd17; //Tabla B
        time_E1[2] = 8'd17; //Tabla C
        time_E1[3] = 8'd17; //Tabla D
    end

    //reg [3:0] time_E1 [7:0] = {8'd17, 8'd17, 8'd17, 8'd17};
    //time_E1[0] = 8'd17; //Tabla A
    //time_E1[1] = 8'd17; //Tabla B
    //time_E1[2] = 8'd17; //Tabla C
    //time_E1[3] = 8'd17; //Tabla D
    
  //Tabla de tiempos del estado 2
 
    reg [3:0] [7:0] time_E2 = {8'd3, 8'd3, 8'd3, 8'd3};
    //time_E2[0] = 8'd3; //Tabla A
    //time_E2[1] = 3; //Tabla B
    //time_E2[2] = 3; //Tabla C
    //time_E2[3] = 3; //Tabla D

  //Tabla de tiempos del estado 3
  
    reg [3:0] [7:0] time_E3 = {8'd55, 8'd110, 8'd27, 8'd27};
    //time_E3[0] = 8'd55; //Tabla A
    //time_E3[1] = 110; //Tabla B
    //time_E3[2] = 27; //Tabla C
    //time_E3[3] = 27; //Tabla D

  //Tabla de tiempos del estado 4
  
    reg [3:0] [7:0] time_E4 = {8'd3, 8'd3, 8'd3, 8'd3};
    //time_E4[0] = 8'd3; //Tabla A
    //time_E4[1] = 3; //Tabla B
    //time_E4[2] = 3; //Tabla C
    //time_E4[3] = 3; //Tabla D

  //Tabla de tiempos del estado 5

    reg [3:0] [7:0] time_E5 = {8'd27, 8'd14, 8'd14, 8'd54};
    //time_E5[0] = 8'd27; //Tabla A
    //time_E5[1] = 14; //Tabla B
    //time_E5[2] = 14; //Tabla C
    //time_E5[3] = 54; //Tabla D

//Tabla de tiempos del estado 6
  
    reg [3:0] [7:0] time_E6 = {8'd3, 8'd3, 8'd3, 8'd3};
    //time_E6[0] = 8'd3; //Tabla A
    //time_E6[1] = 3; //Tabla B
    //time_E6[2] = 3; //Tabla C
    //time_E6[3] = 3; //Tabla D

  //Tabla de tiempos del estado 7
  
    reg [3:0] [7:0] time_E7 = {8'd24, 8'd12, 8'd48, 8'd12};
    //time_E7[0] = 8'd24; //Tabla A
    //time_E7[1] = 12; //Tabla B
    //time_E7[2] = 48; //Tabla C
    //time_E7[3] = 12; //Tabla D

    //chequear que este en el rojo del estado 8

    reg [3:0] [7:0] time_E8 = {8'd24, 8'd12, 8'd48, 8'd12};
    //time_E8[0] = 8'd24; //Tabla A
    //time_E8[1] = 12; //Tabla B
    //time_E8[2] = 48; //Tabla C
    //time_E8[3] = 12; //Tabla D
    
 */	

    reg[3:1] tabla;
    reg[7:0] estado;
	
	initial begin
		finished <= 1;
		end

    
    always @ (SNN or SNS or STH)
        begin
      //CASO 4
        if(!SNS & !SNN & STH & (estado != initialStateB) )
            begin
				$
                tabla <= B;
                estado <= 3; //thevenin al este  
                //reset_chrono = 1;
            end
      // CASO 5
        else if ( !SNS & SNN &  !STH & (estado != initialStateC) )
            begin
                tabla <= C;
                estado <= 5; //norton al norte en verde 
                //reset_chrono = 1;
            end
      // CASO 6
        else if ( SNS & !SNN & !STH & (estado != initialStateD) )
            begin
                tabla <= D;
                estado <= 4; //norton al sur       
                //reset_chrono = 1;
            end

        /*pulsador
        else if (!SNS & !SNN & !STH)
            begin

            end
        */ 

      // CASO 1
        else 
            begin
                tabla <= A;
                //estado <= estado + 1; 
            end
        end
		
  //loop de estados
  always @ (posedge clk)	
	  begin
		  if(finished)
			  begin
				  case(estado)
					1: 
					begin 
						timer <= 17;	
					    Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= GREEN;
						Giro_TH_izq <= GREEN;
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1; 
						$display("ESTADO %d", estado);
					end		  		
					2:
					begin 
						timer <= 3;
					    Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= RED;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= GREEN;
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;	
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;
						$display("ESTADO %d", estado);
					end
					4:	 
					begin 
						case(tabla)
							A: timer <= 55;
							B: timer <= 110;
							C: timer <= 27;
							D: timer <= 27;
						endcase		
					    Semaforo_NN	<= RED;
						Semaforo_NS <= RED ;
						Semaforo_TH	<= GREEN;
						Giro_NN_izq	<= RED;
						Giro_NN_der <= RED;
						Giro_TH_izq <= RED;
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;  
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;  
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1; 
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1; 
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = estado + 1;
						$display("ESTADO %d", estado);
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
						/*Semaforo_peaton_N <= 0;
						Semaforo_peaton_TH1	<= 0;
						Semaforo_peaton_TH2 <= 0; */
	                    estado = 1;
						$display("ESTADO %d", estado);
					end
				endcase	
			end
		end	
/*		
		    output reg Semaforo_NN, //change S1
    output reg ,
    output reg ,
    output reg ,
    output reg ,
    output reg ,
    output reg ,
    output reg ,
    output reg ,
			
			                    CGiro_NN_der <= 1;
                    CSemaforo_peaton_TH2 <= 1;		
		
  //loop de estados
    always @ (posedge CLK)
        begin
            if (reset_chrono == 1)
                reset_chrono <= 0;

            if (reset_general == 1)
                estado = 9;

                case (estado)
                    9: //estado de reset
                    begin
                        if (enable_general == 1)
                        	begin
                            	{set_Semaforo_NN set_Semaforo_NS set_Semaforo_TH set_Giro_NN_izq set_Semaforo_peaton_N set_Semaforo_peaton_TH2} <= 1;
                            	{set_Giro_NN_der, set_Giro_TH_izq, set_Semaforo_peaton_TH1} <= 0;
                            	{reset_chrono, estado} <= 1;
                            end
                    end
                    
                    1: 
                    begin
                        CGiro_TH_izq <= 0;
                        CSemaforo_peaton_N <= 0;
                        CSemaforo_peaton_TH1 <= 0;
                        if (ms >= 17*1000)
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //seteo de luces para proximo estado (2)
                                CGiro_NN_der <= 1;
                                CSemaforo_peaton_TH2 <= 1;
                            end
                    end

                    2:
                    begin
                        CGiro_NN_der <= 0;
                        CSemaforo_peaton_TH2 <= 0;
                        if (ms >= 3*1000)
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //seteo de luces para proximo estado (3)
                                CSemaforo_TH <=1;
                            end
                    end
                    
                    3: 
                    begin
                        CSemaforo_TH <=0;
                        if (ms >= 55*1000)
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //seteo de luces para proximo estado (4)
                                CSemaforo_TH <= 1;
                            end
                    end

                    4: 
                    begin
                        CSemaforo_TH <=0;
                        if (ms >= 3*1000)
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces
                                CSemaforo_peaton_TH1 <= 1;
                                CSemaforo_peaton_TH2 <= 1;
                                CSemaforo_peaton_N <= 1;
                                CSemaforo_NS <= 1;
                            end
                    end

                    5: 
                    begin
                        CSemaforo_peaton_TH1 <= 0;
                        CSemaforo_peaton_TH2 <= 0;
                        CSemaforo_peaton_N <= 0;
                        CSemaforo_NS <= 0;
                        if (ms >= 27*1000)
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces 
                                CSemaforo_NS <= 1;
                            end
                    end

                    6:
                    begin
                        CSemaforo_NS <= 0;
                        if (red_check_SemaforoNN_E6) 
                        	begin
                            	estado = estado + 1;
                            	reset_chrono <= 1;

                            	//cambio luces hacia NN
                            	CSemaforo_NN <= 1;
                            	CGiro_NN_der <= 1;
                            	CGiro_NN_izq <= 1;     
                            end
                        end

                    7:
                    begin
                        CSemaforo_NN <= 0;
                        CGiro_NN_der <= 0;
                        CGiro_NN_izq <= 0;

                        if (red_check_SemaforoNN_E6) 
                        	begin
                            	estado = estado + 1;
                            	reset_chrono <= 1;

                            	//mantuve estado 7 (luz amarilla)
                            	CSemaforo_NN <= 1;
                            	CGiro_NN_izq <= 1;  
                            end
                    end

                    8:
                    begin
                        CSemaforo_NN <= 0;
                        CGiro_NN_izq <= 0;
                        if (red_check_SemaforoNN_E6) 
                        	begin
                            estado = 1;
                            reset_chrono <= 1;

                            //estado repite
                            CGiro_TH_izq <= 1;
                            CSemaforo_peaton_N <= 1;
                            CSemaforo_peaton_TH1 <= 1;
                            end
                        end
                endcase
        end		 */

endmodule 


module testfsm();
	
   	reg CLK_10k;
	reg [15:0] seconds;
	reg reset;  
	wire finished;	  
	
	chronometer C1(.reset(reset), .secondsToCount (seconds), .CLK(CLK_10k), .finished(finished)); 	  
	
	
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
		#1s 
		STH_test =0;
		SNN_test =0;
		SNS_test =1;
		
		#100s
		STH_test =1;
		SNN_test =0;
		SNS_test =0;
		#100s
		STH_test =0;
		SNN_test =1;
		SNS_test =0;
		#100s
		$finish;
	end
	
endmodule