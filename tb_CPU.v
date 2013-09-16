`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:		
//				
// Engineer: 	
//
// Create Date:
// Design Name:
// Module Name:
// Project Name:	
// Target Devices: 
// Tool versions:
// Description:	
//
// Dependencies:
//
// Revision:
//
//
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
module tb_CPU;
  //----------------------------
 	// < Enter Input Ports in Alphabetical Order >
  // None
  // < Enter Output Ports in Alphabetical Order >
  // None
  // < Enter Bidirectional Ports in Alphabetical Order >
 	// None
  //----------------------------
   
  //--------------------------
  // Parameters
  //--------------------------
  
  //--------------------------
  // Input Ports
  //--------------------------
  
  //--------------------------
  // Output Ports
  //--------------------------
  
  //--------------------------
  // Bidirectional Ports
  //--------------------------
  // < Enter Bidirectional Ports in Alphabetical Order >
  // None
    
  ///////////////////////////////////////////////////////////////////
  // Begin Design
  ///////////////////////////////////////////////////////////////////
  //-------------------------------------------------
  // Signal Declarations: local params
  //-------------------------------------------------

  //-------------------------------------------------
  // Signal Declarations: reg
  //-------------------------------------------------  
  reg               clk              ;
  reg               rst              ;

  //-------------------------------------------------
  // Signal Declarations: wire
  //-------------------------------------------------  
    

	cpu U0
	(
		//----------------------------
		// < Enter Input Ports in Alphabetical Order >    
		.clk            ( clk            ),
		.rst            ( rst            )
		
		// < Enter Output Ports in Alphabetical Order >
		// None
		
		// < Enter Bidirectional Ports in Alphabetical Order >
		// None
	);


	always 
		#5 clk = ~clk;
	
	initial
	begin
	
		clk    = 1'b0      ; // time = 0 
		#1 rst    = 1'b1;
			
	end
	
	initial
	begin		
		repeat(5)
			@(posedge clk);
			
		rst = 1'b0;
	
		
		repeat(1000)
			@(posedge clk);
			
		$stop();
	end

         
endmodule

