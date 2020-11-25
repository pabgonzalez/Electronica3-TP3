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
    time_E1[1] = 17; //Tabla B
    time_E1[2] = 17; //Tabla C
    time_E1[3] = 17; //Tabla D
  
    reg [7:0] time_E2 [3:0];
    time_E2[0] = 17; //Tabla A
    time_E2[1] = 17; //Tabla B
    time_E2[2] = 17; //Tabla C
    time_E2[3] = 17; //Tabla D
  
    reg [7:0] time_E3 [3:0];
    time_E3[0] = 17; //Tabla A
    time_E3[1] = 17; //Tabla B
    time_E3[2] = 17; //Tabla C
    time_E3[3] = 17; //Tabla D
  
    reg [7:0] time_E4 [3:0];
    time_E4[0] = 17; //Tabla A
    time_E4[1] = 17; //Tabla B
    time_E4[2] = 17; //Tabla C
    time_E4[3] = 17; //Tabla D
  
    reg [7:0] time_E5 [3:0];
    time_E5[0] = 17; //Tabla A
    time_E5[1] = 17; //Tabla B
    time_E5[2] = 17; //Tabla C
    time_E5[3] = 17; //Tabla D
  
    reg [7:0] time_E6 [3:0];
    time_E6[0] = 17; //Tabla A
    time_E6[1] = 17; //Tabla B
    time_E6[2] = 17; //Tabla C
    time_E6[3] = 17; //Tabla D
  
    reg[7:0] tabla = 'A';
    reg[7:0] estado = 1;
  
    always @ (SNN or SNS or STH)
        begin
        //Caso 4
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
            if(tabla != 'A')
                begin
                    tabla = 'A';
                    estado = estado + 1; 
                end
        end
        
        
  //loop de estados
    always @ (posedge CLK, estado)
        begin
            case (estado)
                1: begin end
                2:
                3:
        end
          
endmodule