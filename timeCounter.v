module timeCounter (clk, secondsToCount, startCounting, timeFinished, reset);
	
	input clk;	 
	input reset;
  	input secondsToCount;
  	input startCounting;

	
	output timeFinished;
	reg timeFinished;
	//reg timeFinished;

	// Time in Seconds
	reg[6:0] timeInSeconds;
	
	//Time in Clock Cycles
	reg[13:0] timeClockCount;
	
  //Time In Cycles to Compare
  
	parameter ONE_SECOND= 14'd9999;
	//string test = "Estoy aca";
	
													
	always @(posedge clk)
		begin		
			timeFinished <= 0;

			if (timeClockCount == ONE_SECOND || reset == 1)
				timeClockCount <= 0;
			else 
				timeClockCount <= timeClockCount + 1;

			if (reset == 1)
				begin 
					timeClockCount <= 0;
					timeInSeconds <= 0;
				end
							
			else if(timeClockCount == ONE_SECOND) 
				begin
					timeInSeconds <= timeInSeconds + 1;
					$display("%d contador SEG", timeInSeconds);
        			timeClockCount <= 0;
				end
					  
			else if(startCounting || reset == 0) //Si se resetea, autom?ticamente se pone expired en cero. 
				begin
					timeClockCount <= 0;
					timeInSeconds <= 0;
				end
				
			 	
			else if (timeInSeconds==secondsToCount) //Si cuento un segundo de clock, reseteo el contador de ciclos y disminuyo en uno la cantidad e segundos que falta contar
				begin 
					timeFinished <= 1; //Veo si ya termin? de contar los N segundos que correspond?an.
					$display("TERMINO");   
				end

		end
endmodule

//testbench para el Timer


module testTimer();	
	reg startCounting;	
	reg reset;
	reg timeFinished;
	reg[6:0] secondsToCount;
	reg clk;   	  
	//string testMsg = "HOLIS";
	
	timeCounter test(clk, secondsToCount, startCounting, timeFinished, reset);
	
		
	//Comienza testeo
	initial begin
		clk = 0;
		forever #100000ns clk = ~ clk;
	end	  
	
	initial begin	
		
		$display("starting test");
		#1s
		timeFinished = 0;
		reset = 0;
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