module decoder (
	input wire [31:0] instruction,
	output wire [4:0] rs1,
	output wire [4:0] rs2,
	output wire [4:0] rd,
	output reg [3:0] alu_control,
	output reg alu_src, //if 1 immediate, if 0 read_data2
	output reg reg_write, //sends a signal to register file whether to write or not
	output reg mem_read,
	output reg mem_write,
	output reg [1:0] immediate_type, //is it a immediate (ex. addi) or a store type
	output reg branch
);

	localparam ALU_ADD = 4'b0000;
	localparam ALU_SUB = 4'b0001;
	localparam ALU_AND = 4'b0010;
	localparam ALU_OR = 4'b0011;
	localparam ALU_XOR = 4'b0100;
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire [6:0] funct7;
	assign rs1 = instruction[19:15]; //RISCV
	assign rs2 = instruction[24:20];
	assign rd = instruction[11:7];
	assign opcode = instruction[6:0];
	assign funct3 = instruction[14:12];
	assign funct7 = instruction[31:25];

always @(*) begin

	alu_control = 4'b0000;
	alu_src = 1'b0;
	reg_write = 1'b0;
	mem_read = 1'b0;
	mem_write = 1'b0;
	immediate_type=2'b00;
	branch = 1'b0;
	
	if (opcode == 7'b0110011) begin // R-type (arithmetic logical and shift)

	if (funct3 == 3'b000 && funct7 == 7'b0000000)
        alu_control = ALU_ADD; //ADD

	else if (funct3 == 3'b000 && funct7 == 7'b0100000)
        alu_control = ALU_SUB; //SUB

	else if (funct3 == 3'b111)
        alu_control = ALU_AND;  // AND

	else if (funct3 == 3'b110)
        alu_control = ALU_OR;  // OR

	else if (funct3 == 3'b100)
        alu_control = ALU_XOR;  // XOR

    alu_src = 1'b0;
    reg_write = 1'b1;
	 immediate_type=2'b00;
	
end	
	 
	 else if (opcode == 7'b1100011 && funct3 == 3'b000) begin // BEQ
    branch = 1'b1;
    immediate_type = 2'b10;
end
	else if(opcode == 7'b0010011 && funct3 == 3'b000)begin // ADDI
		alu_control=ALU_ADD;
		alu_src=1'b1;
		reg_write=1'b1;
		immediate_type=2'b00;
	end
	else if (opcode == 7'b0000011 && funct3 == 3'b010) begin   // LW, it uses ADD because to calculate the address of memory it adds the base register it is read/stored from and adds the immediate (offset) (x0)
		alu_control = ALU_ADD;
		alu_src = 1'b1;
		mem_read = 1'b1;
		mem_write = 1'b0;
		reg_write = 1'b1;
		immediate_type=2'b00;
	end
	else if (opcode == 7'b0100011 && funct3 == 3'b010) begin // SW
    alu_control = ALU_ADD;
    alu_src = 1'b1;
    mem_read = 1'b0;
    mem_write = 1'b1;
    reg_write = 1'b0;
	 immediate_type = 2'b01;
	end
end
endmodule 