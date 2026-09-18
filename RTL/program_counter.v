module program_counter(

	input wire clk,
	input wire reset,
	input wire stall,
	input wire branch_taken,
	input wire [31:0] branch_target,
	input wire [31:0] next_pc,
	output reg [31:0] pc
	); 
	
	always @(posedge clk) begin
    if (reset)
        pc <= 32'd0;
    else if (branch_taken)
        pc <= branch_target;
    else if (!stall)
        pc <= next_pc;
end

endmodule
	