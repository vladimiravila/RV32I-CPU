module instruction_memory (
    input wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];

    assign instruction = memory[address[9:2]];

endmodule





/*
module instruction_memory (

	input wire [31:0] address,
	output reg [31:0] instruction

);

	always @(*) begin
    instruction = 32'h00000013;

    case (address)
        32'h00000000: instruction = 32'h02A00093; // ADDI x1, x0, 42
        32'h00000004: instruction = 32'h00002103; // LW   x2, 0(x0)
        32'h00000008: instruction = 32'h002081B3; // ADD  x3, x1, x2

        default: instruction = 32'h00000013;
    endcase
end
endmodule 
*/
