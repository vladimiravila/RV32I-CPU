module ALU (
	input wire [31:0] operand_a,
	input wire [31:0] operand_b,
	input wire [3:0] alu_control,
	output reg [31:0] result
);

	always @(*) begin
		case (alu_control)
		
			4'b0000: result = operand_a + operand_b; // ADD
         4'b0001: result = operand_a - operand_b; // SUB
         4'b0010: result = operand_a & operand_b; // AND
         4'b0011: result = operand_a | operand_b; // OR
         4'b0100: result = operand_a ^ operand_b; // XOR

		default: result = 32'd0;
		endcase
	end
endmodule 