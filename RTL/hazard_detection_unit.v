module hazard_detection_unit (
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    input wire [4:0] id_ex_rd,
    input wire id_ex_mem_read,

    output reg stall
);

always @(*) begin
    stall = 1'b0;

    if (id_ex_mem_read &&
        (id_ex_rd != 0) &&
        ((id_ex_rd == id_rs1) || (id_ex_rd == id_rs2))) begin
        stall = 1'b1;
    end
end

endmodule 