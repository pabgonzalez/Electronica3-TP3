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

/*
output wire gpio_11, 	//green peatonal TH1
output wire gpio_9,  	//red peatonal TH1  
output wire gpio_19, 	//green peatonal TH2
output wire gpio_18,  	//red peatonal TH2       
output wire gpio_21, 	//green peatonal N
output wire gpio_13,	//red peatonal N 	  
*/
input wire gpio_3, 		//Sensor TH
input wire gpio_4,		//Sensor NN
input wire gpio_48,		//Sensor NS
/*input wire gpio_45,		//Pulsador NN    
input wire gpio_46,		//Pulsador NS
input wire gpio_47		//Pulsador Th 
*/
); 

//Clocks
SB_LFOSC OSCInst0(.CLKLFEN(1'b1), .CLKLFPU(1'b1), .CLKLF(CLK_10k));      
//wire CLK_3M;   
//SB_HFOSC OSCInst1(.CLKHFEN(1'b1), .CLKHFPU(1'b1), .CLKHF(CLK_HF));   //clock general de 48MHz
//clock_divider clock3M(.clk_in(CLK_HF), .clk_out(CLK_3M));     

//wire [31:0] ms = 32'b0;
wire [31:0] seconds;
wire clock_reset;                                  
chronometer C1(.clock_reset(clock_reseT), .seconds(seconds), .clk(CLK_10k)); 

/*
wire CSemaforo_NN; //change S1
wire CSemaforo_NS;
wire CSemaforo_TH;
wire CGiro_NN_izq;
wire CGiro_NN_der;
wire CGiro_TH_izq;
wire CSemaforo_peaton_N;
wire CSemaforo_peaton_TH1;
wire CSemaforo_peaton_H2;	  */
/*
wire set_Semaforo_NN; //change S1
wire set_Semaforo_NS;
wire set_Semaforo_TH;
wire set_Giro_NN_izq;
wire set_Giro_NN_der;
wire set_Giro_TH_izq;
wire set_Semaforo_peaton_N;
wire set_Semaforo_peaton_TH1;
wire set_Semaforo_peaton_TH2;		
*/ 

wire [1:0] lightTH;
wire [1:0] lightNN;
wire [1:0] lightNS;
wire [1:0] lightGTH;
wire [1:0] lightGNN_R;
wire [1:0] lightGNN_L;

fsm fsmGeneral(.clock_reset(clock_reseT),
	.clk(CLK_10k),
	.SNN(gpio_4), 
    	.SNS(gpio_48),
    .STH(gpio_3),
    .Semaforo_NN(lightNN), 
    .Semaforo_NS(lightNS),
    .Semaforo_TH(lightTH),
    .Giro_NN_izq(lightGNN_L),
    .Giro_NN_der(lightGNN_R),
    .Giro_TH_izq(lightGTH));

semaforo semaforo_thevenin(.light(lightTH), .clk(CLK_10k), .green(gpio_26), .yellow(gpio_25), .red(gpio_23)); //thevenin
semaforo semaforo_nortonN(.light(lightNN), .clk(CLK_10k), .green(gpio_35), .yellow(gpio_32), .red(gpio_27)); //norton norte 
semaforo semaforo_nortonS(.light(lightNS), .clk(CLK_10k), .green(gpio_34), .yellow(gpio_37), .red(gpio_31)); //norton sur

semaforo2 giro_thevenin(.light(lightGTH), .clk(CLK_10k), .green(gpio_43), .red(gpio_36)); //G TH
semaforo2 giro_NN_L(.light(lightGNN_L), .clk(CLK_10k), .green(gpio_38), .red(gpio_42)); //G NN L
semaforo2 giro_NN_R(.light(lightGNN_R), .clk(CLK_10k), .green(gpio_44), .red(gpio_6)); //G NN R

/*
semaforo2 giro_thevenin(.en(gpio_2), .reset(gpio_28), .set(set_Giro_TH_izq), .change(CGiro_TH_izq), .clk(CLK_10k), .green(gpio_43), .red(gpio_36)); //G TH
semaforo2 giro_NN_L(.en(gpio_2), .reset(gpio_28), .set(set_Giro_NN_izq), .clk(CLK_10k), .green(gpio_38), .red(gpio_42)); //G NN L
semaforo2 giro_NN_R(.en(gpio_2), .reset(gpio_28), .set(set_Giro_NN_der), .change(CGiro_NN_der), .clk(CLK_10k), .green(gpio_44), .red(gpio_6)); //G NN R
*/
/*
semaforo2 peatonal_TH_1(.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_peaton_TH1), .change(CSemaforo_peaton_TH1), .clklf(CLK_10k), .green(gpio_11), .red(gpio_9)); //P th1
semaforo2 peatonal_TH_2 (.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_peaton_TH2), .change(CSemaforo_peaton_TH2), .clklf(CLK_10k), .green(gpio_19), .red(gpio_18)); //P th2
semaforo2 peatonal_N (.en(gpio_2), .reset(gpio_28), .set(set_Semaforo_peaton_N), .change(CSemaforo_peaton_N), .clklf(CLK_10k), .green(gpio_21), .red(gpio_13)); //P n 	 
*/ 

