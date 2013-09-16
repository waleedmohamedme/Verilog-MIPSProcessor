`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:			Pennsylvania State University
//					
// Engineer: 		Uffaz Nathaniel
//
// Create Date:		4/26/2013
// Design Name: 	ALU
// Module Name:     arithmetic_logic_unit
// Project Name:	Processor
// Target Devices: 	N/A
// Tool versions:	N/A
// Description:		Describes an ALU
//
// Dependencies:	N/A
//
// Revision:		N/A
//
//
// Additional Comments: N/A
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module arithmetic_logic_unit

(
    control,	//specifies the alu operation
    operand0, 	//first operand
    operand1, 	//second operand
    result, 	//alu result
	overflow,	//overflow flag (underflow as well)
    zero 		//zero flag
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 		[3:0]	control;
	input 		[31:0] 	operand0; 
	input		[31:0]	operand1;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	[31:0] 	result; 
	output			overflow;
	output			zero;
	
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
    reg [31:0]	result;
	reg 		overflow;
	reg 		zero;
	
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
	always @(control)
	begin
	
		case (control)
			4'b0000 : // AND
				begin
					result 		= operand0 & operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end	
			4'b0001: // OR
				begin
					result 		= operand0 | operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end	
			4'b0010: // add
				begin
					result 		= operand0 + operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b0011: // XOR
				begin
					result 		= operand0 ^ operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b0100: // NOR
				begin
					result 		= ~(operand0 | operand1);
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b0110: // Subtract
				begin
					result 		= operand0 - operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b0111: // set on less than
				begin
					result 		= (operand0 < operand1) ? -1 : 0;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b1000: // shift left
				begin
					result 		= operand0 << operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b1001: // shift right
				begin
					result 		= operand0 >> operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b1010: // shift right arithmetic
				begin
					result 		= operand0 >>> operand1;
					overflow 	= 0;
					zero		= (result == 0) ? 1 : 0;
				end
			4'b1011: // Signed add
				begin
					result 		= operand0 + operand1;
					
					// See page 226 in Computer Organization and Design
					if ((operand0 >= 0 && operand1 >= 0 && result < 0) ||
						(operand0 < 0 && operand1 < 0 && result >= 0)) begin
						overflow = 1;
					end else begin
						overflow = 0;
					end
					
					zero		= (result == 0) ? 1 : 0;
					
					//$display("**********************zero=%d  add=%b    %d+%d", zero, result, operand0, operand1);
				end
			4'b1100: // Signed subtract
				begin
					result 		= operand0 - operand1;
					
					// See page 226 in Computer Organization and Design
					if ((operand0 >= 0 && operand1 < 0 && result < 0) ||
						(operand0 < 0 && operand1 >= 0 && result >= 0)) begin
						overflow = 1;
					end else begin
						overflow = 0;
					end
					
					zero		= (result == 0) ? 1 : 0;
					
					//$display("**********************zero=%d        subtract=%b    %d-%d", zero, result, operand0, operand1);
				end
			default:
				begin
					zero 		= 0;
					overflow 	= 0;
				end				
		endcase
		
	end

	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    
 endmodule

