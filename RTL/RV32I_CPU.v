module RV32I_CPU(
	input wire clk,
	input wire reset,
	output wire [31:0] debug_x1,
	output wire [31:0] debug_x2,
	output wire [31:0] debug_if_id_pc,
	output wire [31:0] debug_if_id_instruction,
	output wire [31:0] debug_pc,
   output wire [31:0] debug_instruction,
	output wire [31:0] debug_x3,
	output wire [31:0] debug_x4,
	output wire [31:0] debug_x5,
	output wire debug_branch_taken,
	output wire [1:0] debug_forward_a,
	output wire [1:0] debug_forward_b,
	output wire debug_icache_hit,
	output wire debug_dcache_hit
);
	wire[31:0]instruction;
	wire[4:0]rs1;
	wire[4:0]rs2;
	wire[4:0]rd;
	wire[3:0]alu_control;
	wire [31:0] read_data1;
	wire [31:0] read_data2;
	wire [31:0] alu_result;
	wire [31:0] pc;
   wire [31:0] next_pc;
	wire [31:0] immediate;
	wire [31:0] alu_operand_b; // This and alu_src are for the immediate generator. 
	wire alu_src; //where does operand b come from (immediate or read_data)
	wire reg_write; //does ALU result get written to a register
	wire mem_read;
	wire mem_write;
	wire [31:0] data_memory_read_data;
	wire [31:0] write_back_data;
	wire [1:0] immediate_type;
	wire [31:0] if_id_pc;
	wire [31:0] if_id_instruction;
	wire [31:0] id_ex_pc;
	wire [31:0] id_ex_read_data1;
	wire [31:0] id_ex_read_data2;
	wire [31:0] id_ex_immediate;

	wire [4:0] id_ex_rd;
	wire [3:0] id_ex_alu_control;

	wire id_ex_alu_src;
	wire id_ex_reg_write;
	wire id_ex_mem_read;
	wire id_ex_mem_write;
	
	wire [31:0] ex_mem_alu_result;
	wire [31:0] ex_mem_write_data;

	wire [4:0] ex_mem_rd;

	wire ex_mem_reg_write;
	wire ex_mem_mem_read;
	wire ex_mem_mem_write;
	wire [31:0] mem_wb_alu_result;
	wire [31:0] mem_wb_memory_data;

	wire [4:0] mem_wb_rd;

	wire mem_wb_reg_write;
	wire mem_wb_mem_read;
	
	wire [1:0] forward_a;
	wire [1:0] forward_b;

	reg [31:0] alu_forward_a;
	reg [31:0] alu_forward_b;
	wire [4:0] id_ex_rs1;
	wire [4:0] id_ex_rs2;
	wire stall;
	wire branch;
	wire id_ex_branch;
	wire branch_taken;
	wire [31:0] branch_target;
	wire flush;
	wire [31:0] memory_instruction;
	wire icache_stall;
	wire [31:0] memory_read_data;
	wire memory_read;
	wire memory_write;
	wire [31:0] memory_address;
	wire [31:0] memory_write_data;
	wire dcache_stall;
	wire pipeline_stall;
	wire icache_hit;
	wire dcache_hit;
	
	assign debug_icache_hit= icache_hit;
	assign debug_dcache_hit= dcache_hit;
	assign debug_forward_a = forward_a;
	assign debug_forward_b = forward_b;
	assign debug_branch_taken = branch_taken;
	assign debug_if_id_pc = if_id_pc;
	assign debug_if_id_instruction = if_id_instruction;
	assign debug_pc = pc;
	assign debug_instruction = instruction;
	assign pipeline_stall = stall || icache_stall || dcache_stall;
	assign flush = branch_taken;
	assign branch_target = id_ex_pc + id_ex_immediate;
	assign branch_taken = id_ex_branch && (alu_forward_a == alu_forward_b);
	assign write_back_data = mem_wb_mem_read ? mem_wb_memory_data : mem_wb_alu_result;	
	assign next_pc = branch_taken ? branch_target : (pc + 32'd4);
	assign alu_operand_b = id_ex_alu_src ? id_ex_immediate : alu_forward_b;
	
	always @(*) begin
    case (forward_b)
        2'b00: alu_forward_b = id_ex_read_data2;
        2'b10: alu_forward_b = ex_mem_alu_result;
        2'b01: alu_forward_b = write_back_data;
        default: alu_forward_b = id_ex_read_data2;
    endcase
	 case (forward_a)
        2'b00: alu_forward_a = id_ex_read_data1;
        2'b10: alu_forward_a = ex_mem_alu_result;
        2'b01: alu_forward_a = write_back_data;
        default: alu_forward_a = id_ex_read_data1;
    endcase
end

	ex_mem_register ex_mem_reg(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),
    .write_data_in(alu_forward_b),

    .rd_in(id_ex_rd),

    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),

    .alu_result_out(ex_mem_alu_result),
    .write_data_out(ex_mem_write_data),

    .rd_out(ex_mem_rd),

    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write)
);
	
	id_ex_register id_ex_reg(
    .clk(clk),
    .reset(reset),
    .pc_in(if_id_pc),
    .read_data1_in(read_data1),
    .read_data2_in(read_data2),
    .immediate_in(immediate),
    .rd_in(rd),
    .alu_control_in(alu_control),

    .alu_src_in(alu_src),
    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),

    .pc_out(id_ex_pc),
    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .immediate_out(id_ex_immediate),

    .rd_out(id_ex_rd),
    .alu_control_out(id_ex_alu_control),

   .alu_src_out(id_ex_alu_src),
   .reg_write_out(id_ex_reg_write),
   .mem_read_out(id_ex_mem_read),
	.mem_write_out(id_ex_mem_write),
	.rs1_in(rs1),
	.rs2_in(rs2),
	.rs1_out(id_ex_rs1),
	.rs2_out(id_ex_rs2),
	.stall(pipeline_stall),
	.branch_in(branch),
	.branch_out(id_ex_branch),
	.flush(flush)
);

	immediate_generator imm_gen(
	.instruction(if_id_instruction),
	.immediate(immediate),
	.immediate_type(immediate_type)
	);
	
	program_counter pc_unit(
	.clk(clk),
	.reset(reset),
	.next_pc(next_pc),
	.pc(pc),
	.stall(pipeline_stall),
	.branch_taken(branch_taken),
	.branch_target(branch_target)
	);

	instruction_memory imem(
    .address(pc),
    .instruction(memory_instruction)
	);

	instruction_cache icache(
    .clk(clk),
    .reset(reset),
    .address(pc),
    .memory_data(memory_instruction),
    .instruction(instruction),
    .stall(icache_stall),
	 .hit(icache_hit)
	);
	
	
	decoder dec (
	.instruction(if_id_instruction),
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	.alu_control(alu_control),
	.alu_src(alu_src),
	.reg_write(reg_write),
	.immediate_type(immediate_type),
	.mem_read(mem_read),
   .mem_write(mem_write),
	.branch(branch)
	);
	
	register_file reg_file(
	.clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),
    .write_data(write_back_data),
    .reg_write(mem_wb_reg_write),
    .read_data1(read_data1),
    .read_data2(read_data2),
	 .debug_x1(debug_x1),
    .debug_x2(debug_x2),
	 .debug_x3(debug_x3),
	 .debug_x4(debug_x4),
	 .debug_x5(debug_x5)
	 );
	 
	 ALU alu_unit (
    .operand_a(alu_forward_a),
    .operand_b(alu_operand_b),
    .alu_control(id_ex_alu_control),
    .result(alu_result)
	);
	
	data_memory data_mem (
    .clk(clk),
    .reset(reset),

    .mem_write(memory_write),
    .mem_read(memory_read),

    .address(memory_address),
    .write_data(memory_write_data),

    .read_data(memory_read_data)
	);

	data_cache dcache (
    .clk(clk),
    .reset(reset),

    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),

    .address(ex_mem_alu_result),
    .write_data(ex_mem_write_data),

    .memory_read_data(memory_read_data),

    .read_data(data_memory_read_data),

    .memory_read(memory_read),
    .memory_write(memory_write),

    .memory_address(memory_address),
    .memory_write_data(memory_write_data),

    .stall(dcache_stall),
	 .hit(dcache_hit)
	);
	
	 if_id_register if_id_reg(
    .clk(clk),
    .reset(reset),
    .pc_in(pc),
    .instruction_in(instruction),
    .pc_out(if_id_pc),
    .instruction_out(if_id_instruction),
	 .stall(pipeline_stall),
	 .flush(flush)
	);
	
	mem_wb_register mem_wb_reg(
    .clk(clk),
    .reset(reset),

    .alu_result_in(ex_mem_alu_result),
    .memory_data_in(data_memory_read_data),

    .rd_in(ex_mem_rd),

    .reg_write_in(ex_mem_reg_write),
    .mem_read_in(ex_mem_mem_read),

    .alu_result_out(mem_wb_alu_result),
    .memory_data_out(mem_wb_memory_data),

    .rd_out(mem_wb_rd),

    .reg_write_out(mem_wb_reg_write),
    .mem_read_out(mem_wb_mem_read)
	);

	forwarding_unit forwarding (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),

    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),

    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),

    .forward_a(forward_a),
    .forward_b(forward_b)
	);
	
	hazard_detection_unit hazard_unit (
    .id_rs1(rs1),
    .id_rs2(rs2),

    .id_ex_rd(id_ex_rd),
    .id_ex_mem_read(id_ex_mem_read),

    .stall(stall)
);
	
endmodule 