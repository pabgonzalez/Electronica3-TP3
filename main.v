module main
(   
input wire gpio_2, 	//enable
input wire gpio_28, 	//reset   

//input wire gpio_32,     //set S1
//input wire gpio_27,		//change S1
output wire gpio_26, 	//green STH
output wire gpio_25, 	//yellow STH
output wire gpio_23,  	//red STH   
//input wire gpio_42, 	//set S2
//input wire gpio_36,   	//change S2  
output wire gpio_35, 	//green SNN
output wire gpio_32, 	//yellow SNN
output wire gpio_27,  	//red SNN  
output wire gpio_34, 	//green SNS
output wire gpio_37, 	//yellow SNS
output wire gpio_31,  	//red SNS

output wire gpio_36, 	//green GTH
output wire gpio_43,  	//red GTH  
output wire gpio_38, 	//green GNN Left
output wire gpio_42,  	//red GNN Left       
output wire gpio_44, 	//green GNN Right
output wire gpio_6,		//red GNN Right     


output wire gpio_11, 	//green Pulsador TH1
output wire gpio_9,  	//red Pulsador TH1  
output wire gpio_19, 	//green pulsador TH2
output wire gpio_18,  	//red Pulsador TH2       
output wire gpio_21, 	//green Pulsador N
output wire gpio_13,	//red Pulsador N 

input wire gpio_3, 		//Sensor TH
input wire gpio_4,		//Sensor NN
input wire gpio_48,		//Sensor NS
input wire gpio_45,		//Pulsador NN    
input wire gpio_46,		//Pulsador NS
input wire gpio_47		//Pulsador Th
); 

//Clocks
SB_LFOSC OSCInst0(.CLKLFEN(1'b1), .CLKLFPU(1'b1), .CLKLF(CLK_10k));      
wire CLK_3M;   
SB_HFOSC OSCInst1(.CLKHFEN(1'b1), .CLKHFPU(1'b1), .CLKHF(CLK_HF));   //clock general de 48MHz
clock_divider clock3M(.clk_in(CLK_HF), .clk_out(CLK_3M));     

//wire [31:0] ms = 32'b0;
wire [31:0] ms;
wire reset_chrono;                                  
chronometer C1(.miliseconds(ms), .reset(reset_chrono), .CLK(CLK_10k)); 
                           
wire CSemaforo_NN; //change S1
wire CSemaforo_NS;
wire CSemaforo_TH;
wire CGiro_NN_izq;
wire CGiro_NN_der;
wire CGiro_TH_izq;
wire CSemaforo_peaton_N;
wire CSemaforo_peaton_TH1;
wire CSemaforo_peaton_H2;

wire set_Semaforo_NN; //change S1
wire set_Semaforo_NS;
wire set_Semaforo_TH;
wire set_Giro_NN_izq;
wire set_Giro_NN_der;
wire set_Giro_TH_izq;
wire set_Semaforo_peaton_N;
wire set_Semaforo_peaton_TH1;
wire set_Semaforo_peaton_TH2;

semaforo S1(.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_TH), .change(CSemaforo_TH), .clklf(CLK_10k), .green(gpio_26), .yellow(gpio_25), .red(gpio_23)); //thevenin
semaforo S2(.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_NN), .change(CSemaforo_NN), .clklf(CLK_10k), .green(gpio_35), .yellow(gpio_32), .red(gpio_27)); //norton norte 
semaforo S3(.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_NS), .change(CSemaforo_NS), .clklf(CLK_10k), .green(gpio_34), .yellow(gpio_37), .red(gpio_31)); //norton sur

semaforo2 G1(.en(gpio_37), .reset(gpio_31), .set(set_Giro_TH_izq), .change(CGiro_TH_izq), .clklf(CLK_10k), .green(gpio_43), .red(gpio_36)); //G TH
semaforo2 G2(.en(gpio_37), .reset(gpio_31), .set(set_Giro_NN_izq), .change(CGiro_NN_izq), .clklf(CLK_10k), .green(gpio_38), .red(gpio_42)); //G NN L
semaforo2 G3(.en(gpio_37), .reset(gpio_31), .set(set_Giro_NN_der), .change(CGiro_NN_der), .clklf(CLK_10k), .green(gpio_44), .red(gpio_6)); //G NN R

		 
endmodule     

//cronometro
module chronometer
(
output reg [31:0] miliseconds,
input wire reset,
input wire CLK   //10k
);      

parameter max_time = 200*1000; //200 segundos          
reg [3:0] count = 0; 
parameter cycle = 10;
always @ (posedge CLK)
	begin         
		count = count + 1;   
		if ( (count % cycle) == 0) 
			miliseconds = miliseconds + 32'b1;
		if (count >= cycle) 
			count = 0; 
		if (miliseconds >= max_time)
			miliseconds = 32'b0;              
	end            
	
always @ (reset)
		if ( reset == 1)  
		begin
			miliseconds <= 0;  
			count <= 0;
		end
endmodule      


// DIVISOR DEL CLOCK	
module clock_divider
(   
input wire clk_in,
output reg clk_out
);        
	parameter DIVIDER = 16;
    reg [3:0] N = 4'b0;  //contador de 3 bits
    always @ (negedge clk_in)
        begin
        	N <= N + 4'b1;
         	if (N >= (DIVIDER-1))
         		N <= 4'b0;
        end  
    always @ (N)
    	begin
    		clk_out = (N<DIVIDER/2) ? 1'b0 : 1'b1;
    	end
endmodule 

