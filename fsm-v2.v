module fsm
  (
    input wire CLK, //48MHz
    input wire SNN, //sensor Norton Norte
    input wire SNS,
    input wire STH,
    input wire PNN, //Pulsador Norton Norte
    input wire PNS,
    input wire PTH,
    output reg CS1, //change S1
    output reg CS2,
    output reg CS3,
    output reg CG1,
    output reg CG2,
    output reg CG3
  );


  //Tabla de tiempos del estado 1
    reg [7:0] time_E1 [3:0];
    time_E1[0] = 17; //Tabla A
    time_E1[1] = 3; //Tabla B
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


  
    reg[7:0] tabla = 'A';
    reg[7:0] estado = 1;
  
    always @ (SNN or SNS or STH)
        begin
        //CASO 4
        if ( !SNS & !SNN & STH & (estado != 3) )
            begin
                tabla = 'B';
                estado = 3; //norton al norte en verde
                index = 1;
            end
      // CASO 5
        else if ( !SNS & SNN &  !STH & (estado != 5) )
            begin
                tabla = 'C';
                estado = 5; //norton al norte en verde
            end
      // CASO 6
        else if ( SNS & !SNN & !STH & (estado != 4) )
            begin
                tabla = 'D';
                estado = 4; //norton al norte en verde
            end
      // CASO 1
        else 
            begin
                tabla = 'A';
                estado = estado + 1; 
            end
        end
        
        
  //loop de estados
    always @ (posedge CLK, estado)
        begin
            case (estado)
                1:      if (tabla ==)
                2:
                3:
                4:
                5:
        end



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

        // Transicion al proximo estado (secuencial)
    always @(negedge resetn, posedge clk)
        if (resetn == 0) y <= A;
        else y <= Y;

    // Salida (combinacional)
    assign z = (y == C);
endmodule
          
endmodule