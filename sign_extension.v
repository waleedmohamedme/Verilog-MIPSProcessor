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

module sign_extension

(
    in,	//16-bit input
	out	//32-bit sign extended output
);

    //--------------------------
	// Parameters
	//--------------------------	
	parameter INPUT_DWIDTH = 16;
	parameter OUTPUT_DWIDTH = 32;
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 		[INPUT_DWIDTH-1:0]	in;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	[OUTPUT_DWIDTH-1:0] 	out; 
		
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
	localparam SIGN_BIT_LOCATION = INPUT_DWIDTH-1;
	localparam SIGN_BIT_REPLICATION_COUNT = OUTPUT_DWIDTH - INPUT_DWIDTH;
	
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
    
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	assign out = {{SIGN_BIT_REPLICATION_COUNT{in[SIGN_BIT_LOCATION]}},in[INPUT_DWIDTH-1:0]};
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    
 endmodule  



