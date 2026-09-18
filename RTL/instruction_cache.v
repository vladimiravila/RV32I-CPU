module instruction_cache (
    input wire clk,
    input wire reset,

    input wire [31:0] address,
    input wire [31:0] memory_data,

    output wire [31:0] instruction,
    output wire stall,
	 output wire hit
);

    reg [31:0] data [0:3];
    reg [27:0] tag [0:3];
    reg valid [0:3];

    wire [1:0] index;
    wire [27:0] address_tag;
    assign index = address[3:2];
    assign address_tag = address[31:4];

    assign hit = valid[index] && (tag[index] == address_tag);

    assign instruction = hit ? data[index] : 32'h00000013;

    assign stall = !hit;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                data[i] <= 32'd0;
                tag[i] <= 28'd0;
                valid[i] <= 1'b0;
            end
        end
        else if (!hit) begin
            data[index] <= memory_data;
            tag[index] <= address_tag;
            valid[index] <= 1'b1;
        end
    end

endmodule