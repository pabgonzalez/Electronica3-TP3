module test();
	
	reg CLK_10k;
	reg [15:0] seconds;
	reg reset;  
	reg finished;	  
	time_fsm C1(.reset(reset), .secondsToCount (seconds), .CLK(CLK_10k), .finished(finished)); 	  
	
	
	reg SNN_test;
	reg STH_test;
	reg SNS_test;	
	wire NN_red; 
	wire NN_yellow; 
	wire NN_green; //semáforo Norton al Norte
	wire NS_red; 
	wire NS_yellow; 
	wire NS_green; //semáforo Norton al Sur
	wire TH_red; 
	wire TH_yellow; 
	wire TH_green; //semáforo Thevenin
	
	wire GNNL_red;
	wire GNNL_green; //semáforo Norton al Norte
	wire GNNR_red; 
	wire GNNR_green; //semáforo Norton al Sur
	wire GTH_red; 
	wire GTH_green; //semáforo Thevenin	
	
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
	
		semaforo semaforo_thevenin(.light(lightTH), .clk(CLK_10k), .green(TH_green), .yellow(TH_yellow), .red(TH_red)); //thevenin
		semaforo semaforo_nortonN(.light(lightNN), .clk(CLK_10k), .green(NN_green), .yellow(NN_yellow), .red(NN_red)); //norton norte 
		semaforo semaforo_nortonS(.light(lightNS), .clk(CLK_10k), .green(NS_green), .yellow(NS_yellow), .red(NS_red)); //norton sur
		
		semaforo2 giro_thevenin(.light(lightGTH), .clk(CLK_10k), .green(GTH_green), .red(GTH_red)); //G TH
		semaforo2 giro_NN_L(.light(lightGNN_L), .clk(CLK_10k), .green(GNNL_green), .red(GNNL_red)); //G NN L
		semaforo2 giro_NN_R(.light(lightGNN_R), .clk(CLK_10k), .green(GNNR_green), .red(GNNR_red)); //G NN R	
	
	
	
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
		
		#200s
		/*
		STH_test =0;
		SNN_test =1;
		SNS_test =0;
		#100s  
		*/	 
		$finish;
	end
	
endmodule				