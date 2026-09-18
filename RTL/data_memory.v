module data_memory(
	input wire clk,
	input wire reset,
	input wire mem_write,
	input wire mem_read,
	input wire [31:0] address,
	input wire [31:0] write_data,
	output wire [31:0] read_data
);

reg [31:0] memory [0:255];
integer i;

always @(posedge clk) begin 

	if (reset) begin
		for (i=0; i < 256; i=i+1)
			memory[i] <= 32'd42;
	end 
	
	else if (mem_write) begin
	memory[address[9:2]] <= write_data;
	end
end

assign read_data = mem_read ? memory[address[9:2]] : 32'd0;	// this turns the 32 bit address into 8 bytes by diving by 4 since shifiting a zero in binary divides by 2. if we shift two we divide by 4. 

endmodule
