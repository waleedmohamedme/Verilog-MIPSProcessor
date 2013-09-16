`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:			Pennsylvania State University
//					
// Engineer: 		Uffaz Nathaniel
//
// Create Date:		4/26/2013
// Design Name: 	CPU
// Module Name:     cpu
// Project Name:	Processor
// Target Devices: 	N/A
// Tool versions:	N/A
// Description:		Describes a CPU
//
// Dependencies:	N/A
//
// Revision:		N/A
//
//
// Additional Comments: N/A
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cpu
(
	clk,
	rst
);

	 //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 					clk;
	input 					rst;
	
	//--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
	
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
    
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
	wire [31:0] pc_to_address;
	wire [31:0] instruction;
	wire [31:0] instruction_signextended;
	
	wire [3:0]	signal_data_mem_wren;
	wire		signal_reg_file_wren;
	wire		signal_reg_file_dmux_select;
	wire		signal_reg_file_rmux_select;
	wire		signal_alu_mux_select;
	wire [3:0]	signal_alu_control;
	wire [2:0]	signal_pc_control;
	
	wire [4:0] 	reg_waddr;
	
	wire [31:0]	reg_rdata0;
	wire [31:0]	reg_rdata1;
	wire [31:0]	reg_wdata;
	
	wire [31:0] alu_operand1;
	
	wire [31:0] alu_result;
	
	wire alu_flag_overflow;
	wire alu_flag_zero;
	
	wire [31:0] datamemory_rdata;
	
	wire [4:0] reg_radd0;
	wire [4:0] reg_radd1;
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	program_counter	prgCnt (.clk(clk),
							.rst(rst),
							.pc(pc_to_address),
							.pc_control(signal_pc_control),
							.jump_address(instruction[25:0]),
							.branch_offset(instruction[15:0]),
							.reg_address(reg_rdata0));
	
	instruction_memory instMemr (.address(pc_to_address),
								 .instruction(instruction));
								 
	control_unit cntrlUnit (.instruction(instruction),
							.data_mem_wren(signal_data_mem_wren),
							.reg_file_wren(signal_reg_file_wren),
							.reg_file_dmux_select(signal_reg_file_dmux_select),
							.reg_file_rmux_select(signal_reg_file_rmux_select),
							.alu_mux_select(signal_alu_mux_select),
							.alu_control(signal_alu_control),
							.alu_zero(alu_flag_zero),
							.pc_control(signal_pc_control));
	
	sign_extension instrSignExtend (.in(instruction[15:0]),
								   .out(instruction_signextended));
	
	
	assign reg_radd0 = instruction[25:21];
	assign reg_radd1 = instruction[20:16];
	
	
	mux_2to1 #(.DWIDTH(5)) instructionRegFileSelectMux (.in0(reg_radd1),
										  .in1(instruction[15:11]),
										  .out(reg_waddr),
										  .sel(signal_reg_file_rmux_select));
	
	register_file regFile (.clk(clk),
						   .raddr0(reg_radd0),
						   .rdata0(reg_rdata0),
						   .raddr1(reg_radd1),
						   .rdata1(reg_rdata1),
						   .waddr(reg_waddr),
						   .wdata(reg_wdata),
						   .wren(signal_reg_file_wren));
						   
	mux_2to1 aluOperand1SelectMux (.in0(reg_rdata1),
								   .in1(instruction_signextended),
								   .out(alu_operand1),
								   .sel(signal_alu_mux_select));
	
	arithmetic_logic_unit alu(.control(signal_alu_control),
							  .operand0(reg_rdata0),
							  .operand1(alu_operand1),
							  .result(alu_result),
							  .overflow(alu_flag_overflow),
							  .zero(alu_flag_zero));
	
	data_memory dataMemory (.clk(clk),
							.addr(alu_result),
							.rdata(datamemory_rdata),
							.wdata(reg_rdata1),
							.wren(signal_data_mem_wren));
	
	mux_2to1 dataMemoryRDataSelectMux (.in0(datamemory_rdata),
									   .in1(alu_result),
								       .out(reg_wdata),
									   .sel(signal_reg_file_dmux_select));
									   
									   
	
	
	always @(posedge clk)
	begin
		$display("INSTRUCTION=%h - radd0=%d - radd1=%d - reg_rdata0=%-d - reg_rdata1=%-d",
			instruction,
			instruction[25:21], 
			instruction[20:16], 
			reg_rdata0, 
			reg_rdata1);
	end
		
	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
endmodule
