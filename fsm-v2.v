module fsm
  (
    input wire red_check_SemaforoNN_E6,
    input wire [31:0] ms, //milisecond
    output reg reset_chrono,
    input wire CLK, //10kHz
    input wire SNN, //sensor Norton Norte
    input wire SNS,
    input wire STH,
    input wire PNN, //Pulsador Norton Norte
    input wire PNS,
    input wire PTH,

    output reg CSemaforo_NN, //change S1
    output reg CSemaforo_NS,
    output reg CSemaforo_TH,
    output reg CGiro_NN_izq,
    output reg CGiro_NN_der,
    output reg CGiro_TH_izq,
    output reg CSemaforo_peaton_N,
    output reg CSemaforo_peaton_TH1,
    output reg CSemaforo_peaton_TH2,

    output reg set_Semaforo_NN, //change S1
    output reg set_Semaforo_NS,
    output reg set_Semaforo_TH,
    output reg set_Giro_NN_izq,
    output reg set_Giro_NN_der,
    output reg set_Giro_TH_izq,
    output reg set_Semaforo_peaton_N,
    output reg set_Semaforo_peaton_TH1,
    output reg set_Semaforo_peaton_TH2,

    input wire reset_general,
    input wire enable_general
  );

  //Elemento que contar� los segundos

   // timeCounter myTimeCounter ()  

    parameter [2:1] A = 2'b00;
    parameter [2:1] B = 2'b01;
    parameter [2:1] C = 2'b10;
    parameter [2:1] D = 2'b11;

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
    reg[3:1] tabla = A;
    reg[7:0] estado = 9;
    
    always @ (SNN or SNS or STH)
        begin
      //CASO 4
        if ( !SNS & !SNN & STH & (estado != 3) )
            begin
                tabla <= B;
                estado <= 3; //thevenin al este  
                reset_chrono = 1;
            end
      // CASO 5
        else if ( !SNS & SNN &  !STH & (estado != 5) )
            begin
                tabla <= C;
                estado <= 5; //norton al norte en verde 
                reset_chrono = 1;
            end
      // CASO 6
        else if ( SNS & !SNN & !STH & (estado != 4) )
            begin
                tabla <= D;
                estado <= 4; //norton al sur       
                reset_chrono = 1;
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
                            	set_Semaforo_NN <= 1;
                            	set_Semaforo_NS <= 1;
                            	set_Semaforo_TH <= 1;
                            	set_Giro_NN_izq <= 1;
                            	set_Giro_NN_der <= 0;
                            	set_Giro_TH_izq <= 0;
                            	set_Semaforo_peaton_N <= 1;
                            	set_Semaforo_peaton_TH1 <= 0;
                            	set_Semaforo_peaton_TH2 <= 1;    
                            	reset_chrono = 1;
                            	estado = 1;
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
        end

endmodule