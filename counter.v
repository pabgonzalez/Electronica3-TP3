module counter(clk, clr, load, D, Q, RCO); 
    /* 
    Q: salida de 8 bits
    D: entrada de 8 bits
    RCO: flag de fin de cuentas
    load: por si quiero inicializar con otro numero. Pero aca lo uso como 
          variable de entrada para saber hasta donde tengo que contar 
    */
    input clk, clr, load;
    input [7:0] D;
    output [7:0] Q;
    output RCO;
    reg [7:0] Q;
    reg RCO;
    
    parameter MAXCOUNT = 7'b11111111;
    parameter ZEROCOUNT = 7'b0;
    parameter ONECOUNT = 7'b0000001;
    parameter CLK_COUNT_AFTER_ONE_SECOND= 14'd9999;
	parameter CLK_ZERO_COUNT=14'b0;
    
    /*
    Actualiza los estados cada vez que detecta un flanco positivo de un clk
    */
    always @ (posedge clk)
        if (clr == 0 or RCO == 1)
            Q <= 8'b0;
        else
            if ((ENP==1) && (ENT==1))
                Q <= Q+1;
            else 
                Q <= Q;

    /*
    Verifica si el RCO llego a fin de cuentas y le mete un RCO = 1 para 
    inicializar las cuentas de nuevo
    */
    always @ (Q)
        if (Q == load)
            RCO <= 1;
        else 
            RCO <= 0;
endmodule 