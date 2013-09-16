`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:			Pennsylvania State University
//					
// Engineer: 		Uffaz Nathaniel
//
// Create Date:		4/26/2013
// Design Name: 	Instruction Memory
// Module Name:     instruction_memory
// Project Name:	Processor
// Target Devices: 	N/A
// Tool versions:	N/A
// Description:		Describes an instruction memory
//
// Dependencies:	N/A
//
// Revision:		N/A
//
//
// Additional Comments: N/A
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module instruction_memory

(
	address,
	instruction
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input		[31:0]	address;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	[31:0] 	instruction;
		
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
    reg	[31:0] instruction_memory	[255:0];
	
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
	initial
	begin
		$readmemh("program.mips",instruction_memory);
	end
	
	assign instruction = instruction_memory[address[9:2]];
	
 endmodule  



