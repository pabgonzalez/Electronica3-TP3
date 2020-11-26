module fsm
  (
    input wire red_check_SemaforoNN_E6,
    input wire [31:0] ms, //milisecond
    input wire reset_chrono,
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
    output reg CSemaforo_peaton_TH2
  );

  //Elemento que contará los segundos

   // timeCounter myTimeCounter ()  

    parameter [2:1] A = 2'b00;
    parameter [2:1] B = 2'b01;
    parameter [2:1] C = 2'b10;
    parameter [2:1] D = 2'b11;

  //Tabla de tiempos del estado 1
    reg [7:0] time_E1 [3:0];
    time_E1[0] = 17; //Tabla A
    time_E1[1] = 17; //Tabla B
    time_E1[2] = 17; //Tabla C
    time_E1[3] = 17; //Tabla D

  //Tabla de tiempos del estado 2
  
    reg [7:0] time_E2 [3:0];
    time_E2[0] = 3; //Tabla A
    time_E2[1] = 3; //Tabla B
    time_E2[2] = 3; //Tabla C
    time_E2[3] = 3; //Tabla D

  //Tabla de tiempos del estado 3
  
    reg [7:0] time_E3 [3:0];
    time_E3[0] = 55; //Tabla A
    time_E3[1] = 110; //Tabla B
    time_E3[2] = 27; //Tabla C
    time_E3[3] = 27; //Tabla D

  //Tabla de tiempos del estado 4
  
    reg [7:0] time_E4 [3:0];
    time_E4[0] = 27; //Tabla A
    time_E4[1] = 14; //Tabla B
    time_E4[2] = 14; //Tabla C
    time_E4[3] = 54; //Tabla D

  //Tabla de tiempos del estado 5
  
    reg [7:0] time_E5 [3:0];
    time_E5[0] = 24; //Tabla A
    time_E5[1] = 12; //Tabla B
    time_E5[2] = 48; //Tabla C
    time_E5[3] = 12; //Tabla D

    //chequear que este en el rojo del estado 1

    reg [7:0] time_E6 [3:0];
    time_E6[0] = 24; //Tabla A
    time_E6[1] = 12; //Tabla B
    time_E6[2] = 48; //Tabla C
    time_E6[3] = 12; //Tabla D
  
    reg[3:1] tabla = A;
    reg[7:0] estado = 1;
  
    always @ (SNN or SNS or STH)
        begin
      //CASO 4
        if ( !SNS & !SNN & STH & (estado != 3) )
            begin
                tabla <= B;
                estado <= 3; //thevenin al este
            end
      // CASO 5
        else if ( !SNS & SNN &  !STH & (estado != 5) )
            begin
                tabla <= C;
                estado <= 5; //norton al norte en verde
            end
      // CASO 6
        else if ( SNS & !SNN & !STH & (estado != 4) )
            begin
                tabla <= D;
                estado <= 4; //norton al sur
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

                case (estado)
                    1: 
                    begin
                        if (ms >= time_E1[tabla])
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces 
                            end
                    end

                    2:
                    begin
                        if (ms >= time_E2[tabla])
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;

                            end
                    end
                    
                    3: 
                    begin
                        if (ms >= time_E3[tabla])
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces 
                            end
                    end

                    4: 
                    begin
                        if (ms >= time_E4[tabla])
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces 
                            end
                    end

                    5: 
                    begin
                        if (ms >= time_E5[tabla])
                            begin
                                estado = estado + 1;
                                reset_chrono <= 1;
                                //cambio de luces 
                            end
                    end

                    6:
                    begin
                        if (red_check_SemaforoNN_E6)
                            estado = 1;
                            reset_chrono <= 1;
                    end
        end

endmodule