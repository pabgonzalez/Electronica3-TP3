module fsm
  (
    input wire CLK, //48MHz
    input wire SNN,
    input wire SNS,
    input wire STH,
    input wire PNN,
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
  
  reg[7:0] tabla = 'A';
  reg[7:0] estado = 1;
  
  always @ (SNN or SNS or STH)
    begin
      if ( SNN & !SNS & !STH & (estado != 5) )
        begin
          tabla = 'C';
          estado = 5; //norton al norte en verde
        end
      else if...
    end
        
        
  //loop de estados
  always @ (posedge CLK)
    begin
      case (estado)
        1: begin end
        2:
        3:
    end
          
endmodule
 
