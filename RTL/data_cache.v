module data_cache(
    input wire clk,
    input wire reset,

    input wire mem_read,
    input wire mem_write,

    input wire [31:0] address,
    input wire [31:0] write_data,

    input wire [31:0] memory_read_data,

    output wire [31:0] read_data,

    output wire memory_read,
    output wire memory_write,
    output wire [31:0] memory_address,
    output wire [31:0] memory_write_data,

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

    assign hit = valid[index] &&
                 (tag[index] == address_tag);

    // Backing memory is asynchronous, so no pipeline stall
    // is needed for a load miss.
    assign stall = 1'b0;

    // Load:
    // hit  -> cache data
    // miss -> backing memory data
    assign read_data =
        mem_read ?
        (hit ? data[index] : memory_read_data) :
        32'd0;

    assign memory_read =
        mem_read && !hit;

    assign memory_write =
        mem_write;

    assign memory_address =
        address;

    assign memory_write_data =
        write_data;

    integer i;

    always @(posedge clk) begin

        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                data[i] <= 32'd0;
                tag[i] <= 28'd0;
                valid[i] <= 1'b0;
            end
        end

        else begin

            if (mem_read && !hit) begin
                data[index] <= memory_read_data;
                tag[index] <= address_tag;
                valid[index] <= 1'b1;
            end

            if (mem_write) begin
                data[index] <= write_data;
                tag[index] <= address_tag;
                valid[index] <= 1'b1;
            end

        end
    end

endmodule