module register_file(
	input wire clk,
	input wire reset,
	input wire [4:0] rs1,
	input wire [4:0] rs2,
	input wire [4:0] rd,
	input wire [31:0] write_data,
	input wire reg_write,
	output wire [31:0] read_data1,
	output wire [31:0] read_data2,
	output wire [31:0] debug_x1,
	output wire [31:0] debug_x2,
	output wire [31:0] debug_x3,
	output wire [31:0] debug_x4,
	output wire [31:0] debug_x5
);

reg [31:0] registers [0:31];
integer i;

always @(posedge clk) begin

	if(reset)begin 
	for (i=0; i<32; i=i+1)
		registers[i] <= 0;
	end 
	
	else if (reg_write &&(rd != 0)) begin
	registers[rd] <= write_data;
	end
end 

assign read_data1 = (rs1 == 0) ? 0:registers[rs1];
assign read_data2 = (rs2 == 0) ? 0:registers[rs2];
assign debug_x1 = registers[1];
assign debug_x2 = registers[2];
assign debug_x3 = registers[3];
assign debug_x4 = registers[4];
assign debug_x5 = registers[5];
endmodule 