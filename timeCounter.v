module Timer (CLK, secondsToCount,startCounting);
	
	input CLK;
  input secondsToCount;
  input startCounting;
  input resetCounter;
	
	output timeFinished;
	
	// Time in Seconds
	reg[6:0] timeInSeconds;
	
	//Time in Clock Cycles
	reg[13:0] timeClockCount;
	
  //Time In Cycles to Compare
  
	parameter ONE_SECOND= 14'd9999;

	
	always @(posedge clk)
		begin
			timeFinished<= 0; 
      timeClockCount = timeClockCount+1;
			
			//El contador de ciclos va de 0 a 9999 (es decir, cuenta 1 segundo).
			if(timeClockCount == ONE_SECOND)
				timeInSeconds <= timeInSeconds + 1;
        timeClockCount <= 0;
			else
				timeClockCount <= timeClockCount+1;
			
			if(startCounting) //Si se resetea, autom�ticamente se pone expired en cero.
				begin
					timeClockCount <= 0;
					timeInSeconds <= 0;
			 	end
			
			if (timeInSeconds==secondsToCount) //Si cuento un segundo de clock, reseteo el contador de ciclos y disminuyo en uno la cantidad e segundos que falta contar
				begin
					timeFinished <= 1; //Veo si ya termin� de contar los N segundos que correspond�an.
				end
		end
endmodule

//testbench para el Timer


/*module testTimer();	
	reg reset;
	reg[6:0] timeParameter;
	reg startTimer;
	wire expired;
	wire oneHztmp;
	reg clk;
	
	Timer test(clk, reset, timeParameter, startTimer, expired);
	
	/*Tasks para ayudar en la verificaci�n
	task assertCycleCount;
		input[13:0]	clkCycleCount;
		if(test.clkCycleCount !== clkCycleCount)
			begin
				$display("error");
				$display("expected: %d", clkCycleCount);
				$display("got: %d", test.clkCycleCount);
				$stop();
			end
	endtask
	
	task assertExpired;
		input exp;
		if(test.expired !== exp)
			begin
				$display("error: expired");
				$display("expected: %d", exp);
				$display("got: %d", test.expired);
				$stop();
			end
	endtask
	
	//Comienza testeo
	initial begin
		clk=0;
		forever #100000ns clk = ~ clk;
	end
	
	initial begin
		$display("starting test");
		
		reset=0;
		timeParameter = 5;	 
		startTimer = 0;
		#1s
		
		//assetCycleCount(14'd0);
		//assertExpired(0); 
		
		reset=0;
		startTimer=1;
		
		#1s
		//assetCycleCount(14'd0);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd1);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd2);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd9997);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd9998);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd9990);
		//assertExpired(0); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd0);
		//assertExpired(1); 
		
		startTimer=0;
		
		#1s
		//assetCycleCount(14'd1);
		//assertExpired(0); 
		
		startTimer=0;
		
		#14s
		//assetCycleCount(14'd2);
		//assertExpired(0); 
		
		startTimer=0;
		$finish;
		//$display ("Passed Test");
	end	
	
endmodule*/