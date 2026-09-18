module immediate_generator(
	input wire [31:0] instruction,
	input wire [1:0] immediate_type,
	output reg[31:0] immediate
);

always @(*) begin
    case (immediate_type)

        2'b00: begin
            // I-type: ADDI, LW (immediate)
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        end

        2'b01: begin
            // S-type: SW (save)
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end
		  
		  2'b10: begin //B-Type BEQ
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end

        default:
            immediate = 32'd0;

    endcase
end

endmodule