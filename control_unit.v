`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:			Pennsylvania State University
//					
// Engineer: 		Uffaz Nathaniel
//
// Create Date:		4/26/2013
// Design Name: 	Control Unit
// Module Name:     control_unit
// Project Name:	Processor
// Target Devices: 	N/A
// Tool versions:	N/A
// Description:		Describes a control unit
//
// Dependencies:	N/A
//
// Revision:		N/A
//
//
// Additional Comments: I was running into issues with race conditions so I
//						added a delay at line 266
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit
(
	instruction,
	data_mem_wren,
	reg_file_wren,
	reg_file_dmux_select,
	reg_file_rmux_select,
	alu_mux_select,
	alu_control,
	alu_zero,
	pc_control
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 		[31:0]		instruction;
	input 					alu_zero; 
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 		[3:0]		data_mem_wren;
	output					reg_file_wren;
	output					reg_file_dmux_select;
	output					reg_file_rmux_select;
	output					alu_mux_select;
	output		[3:0]		alu_control;
	output		[2:0]		pc_control;
	
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
	reg [3:0]	data_mem_wren;
	reg 		reg_file_wren;
	reg 		reg_file_dmux_select;
	reg 		reg_file_rmux_select;
	reg 		alu_mux_select;
	reg [3:0] 	alu_control;
	reg [2:0] 	pc_control;
    
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
	reg [25:0] address;
	reg [5:0] funct;
	reg [15:0] immediate;
    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;
    reg [4:0] shamt;
    reg [2:0] type;
	
	wire [5:0] op;
	
	
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	
	assign op = instruction[31:26]; // Set the opcode
	
	always @(instruction)
	begin
		// ##############################################################################
		// For the various instructions, determine the appropriate fields
		// ##############################################################################		
		if (op == 6'b000000) begin // R format
			address		= 26'b00000000000000000000000000;
			immediate	= 16'b0000000000000000;
			rs			= instruction[25:21];
			rt			= instruction[20:16];
			rd			= instruction[15:11];
			shamt		= instruction[10:6];
			type		= 3'b001;
			funct		= instruction[5:0];
		end else if (op == 6'b000010 || op == 6'b000011) begin // J format
			address		= instruction[25:0];
			immediate	= 16'b0000000000000000;
			rs			= 5'b00000;
			rt			= 5'b00000;
			rd			= 5'b00000;
			shamt		= 5'b00000;
			type		= 3'b100;
			funct		= 6'b000000;
		end else begin // I format
			address		= 26'b00000000000000000000000000;
			immediate	= instruction[15:0];
			rs			= instruction[25:21];
			rt			= instruction[20:16];
			rd			= 5'b00000;
			shamt		= instruction[10:6];
			type		= 3'b010;
			funct		= instruction[5:0];
		end
	
	
		
		

		// ##############################################################################
		// Singal: data_mem_wren
		// ##############################################################################
		if (op == 6'h2B) begin // store word
			
			/*if (immediate[2:0] == 0) begin // bytes 0-3
				data_mem_wren = 4'b1111;
			end else if (immediate[2:0] == 1) begin // bytes 0-2
				data_mem_wren = 4'b0111;
			end else if (immediate[2:0] == 2) begin // bytes 0-1
				data_mem_wren = 4'b0011;
			end else if (immediate[2:0] == 3) begin // bytes 0
				data_mem_wren = 4'b0001;
			end*/
			
			data_mem_wren = 4'b1111;
			
		end else begin // no write
			data_mem_wren = 4'b0000;
		end
		
		
		
		// ##############################################################################
		// Singal: reg_file_wren
		// ##############################################################################
		if (op == 6'h4 || op == 6'h5 || op == 6'h2 || op == 6'h3 || (op == 6'h0 && funct == 6'h8)) begin // branch
			reg_file_wren = 0;
		end else begin // Otherwise 1
			reg_file_wren = 1;
		end
		
		
		
		
		
		
		// ##############################################################################
		// Singal: reg_file_dmux_select
		// ##############################################################################
		if (op == 6'h23 ||
			op == 6'h21 ||
			op == 6'h25 ||
			op == 6'h20 ||
			op == 6'h24) begin // variations of load word
			reg_file_dmux_select = 0;
		end else begin
			reg_file_dmux_select = 1;
		end
		
		
		
		
		// ##############################################################################
		// Singal: reg_file_rmux_select
		// ##############################################################################
		if (op == 6'h0) begin // R format
			reg_file_rmux_select = 1;
		end else begin // I format or other
			reg_file_rmux_select = 0;
		end
		
		
		
		
		
		// ##############################################################################
		// Singal: alu_mux_select
		// ##############################################################################
		if (!(op == 6'h0 || op == 6'b000010 || op == 6'b000011)) begin // I format
			alu_mux_select = 1;
		end else begin // R or J format
			alu_mux_select = 0;
		end
		
		
		
		
		
		
		// ##############################################################################
		// Singal: alu_control
		// ##############################################################################
		if ((op == 6'h0 && funct == 6'h24) || op == 6'hC) begin // AND
			alu_control = 4'b0000;
		end else if ((op == 6'h0 && funct == 6'h25) || op == 6'hD) begin // OR
			alu_control = 4'b0001;
		end else if ((op == 6'h0 && funct == 6'h21) || op == 6'h9) begin // ADD - unsigned
			alu_control = 4'b0010; 
		end else if ((op == 6'h0 && funct == 6'h26)) begin // XOR
			alu_control = 4'b0011;
		end else if ((op == 6'h0 && funct == 6'h27)) begin // NOR
			alu_control = 4'b0100;
		end else if ((op == 6'h0 && funct == 6'h22)) begin // SUBTRACT - unsigned
			alu_control = 4'b0110;
		end else if ((op == 6'h0 && funct == 6'h2A) || op == 6'hA) begin // SLT
			alu_control = 4'b0111;
		end else if ((op == 6'h0 && funct == 6'h0)) begin // SLL
			alu_control = 4'b1000;
		end else if ((op == 6'h0 && funct == 6'h2)) begin // SRL
			alu_control = 4'b1001;
		end else if ((op == 6'h0 && funct == 6'h3)) begin // SRA
			alu_control = 4'b1010;
		end else if ((op == 6'h0 && funct == 6'h20) || op == 6'h8 || op == 6'h2B || op == 6'h23) begin  // ADD - signed
			alu_control = 4'b1011;
		end else if ((op == 6'h0 && funct == 6'h22) || op == 6'h4 || op == 6'h5) begin // SUB - signed - AND bne, beq
			alu_control = 4'b1100;
		end else begin
			alu_control = 4'b1111;
		end		
		
		
		// ##############################################################################
		// Singal: pc_control
		// ##############################################################################
		// NOTE: the delay is to avoid a race condition
		#0.5 if (op == 6'h2 || op == 6'h3) begin // j, jal
			pc_control = 3'b001;
		end else if (op == 6'h0 && funct == 6'h8) begin // jr
			pc_control = 3'b010;
		end else if (op == 6'h4 && alu_zero == 1) begin // beq
			
				$display("###beq");
				pc_control = 3'b011;
				
		end else if (op == 6'h5 && alu_zero == 0) begin // bne
			
				$display("###bne");
				pc_control = 3'b011;
		
		end else begin // Default
			pc_control = 3'b000;
		end
		
		
	end
	
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    
 endmodule  



