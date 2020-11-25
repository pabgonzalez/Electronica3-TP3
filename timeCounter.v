module Timer (CLK, secondsToCount,startCounting,timeFinished);
	
	input CLK;
  input secondsToCount;
  input startCounting;

	
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


module testTimer();	
	reg startCounting;
	reg[6:0] secondsToCount;
	reg startTimer;
	wire expired;
	wire oneHztmp;
	reg clk;
	
	timeCounter test(clk, secondsToCount, startCounting, timeFinished);
	
	//Comienza testeo
	initial begin
		clk=0;
		forever #100000ns clk = ~ clk;
	end
	
	initial begin
		$display("starting test");
		
		startCounting=1;
		secondsToCount = 5;	 
		
	end

  test.timeInSeconds

  always @*
    $display("%d",test.secondsToCount);
	
endmodule