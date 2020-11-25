module timeCounter (clk, secondsToCount,startCounting,timeFinished);
	
	input clk;
  	input secondsToCount;
  	input startCounting;

	
	output timeFinished;
	reg timeFinished;

	// Time in Seconds
	reg[6:0] timeInSeconds;
	
	//Time in Clock Cycles
	reg[13:0] timeClockCount;
	
  //Time In Cycles to Compare
  
	parameter ONE_SECOND= 14'd9999;
	string test = "Estoy aca";
	
													
	always @(posedge clk)
		begin		
			timeFinished <= 0;
			if(timeFinished == 0)	  
				begin	
					timeClockCount <= timeClockCount+1;	
					$display("%d timeClockCount", timeClockCount);
					if(timeClockCount == ONE_SECOND)
						//begin
							timeInSeconds <= timeInSeconds + 1;
							$display("%d SEGUNDOS", timeInSeconds);
        					timeClockCount <= 0;	  
				
						//end
				end
				
			if(startCounting) //Si se resetea, autom�ticamente se pone expired en cero.
				//begin 
					timeClockCount <= 0;
					timeInSeconds <= 0;
			 	//end
			
			if (timeInSeconds==secondsToCount) //Si cuento un segundo de clock, reseteo el contador de ciclos y disminuyo en uno la cantidad e segundos que falta contar
				begin
					timeFinished <= 1; //Veo si ya termin� de contar los N segundos que correspond�an.
					$display("TERMINO");
				end
		end
endmodule

//testbench para el Timer


module testTimer();	
	reg startCounting;
	reg[6:0] secondsToCount;
	wire expired;
	wire oneHztmp;
	reg clk;   	  
	string testMsg = "HOLIS";
	
	timeCounter test(clk, secondsToCount, startCounting, timeFinished);
	
	initial
		begin
	clk <= 1'b0; 
		end
		
	//Comienza testeo
	initial begin
		
		forever #100000ns clk = ~ clk;
	end	  
	
	initial begin	
		
		$display("starting test");
		#1s
		startCounting = 0;
		secondsToCount = 5;	
		
		#5s
		startCounting = 0;
		secondsToCount = 1;	
		
	end

  /*always @(posedge clk)	   							   
	  
	  begin
		//$display("%d secondsToCount",test.secondsToCount);	
		//$display("%d timeClockCount",test.timeClockCount);	  
		//$display("%d clk",clk);	 		
	  end	*/
endmodule