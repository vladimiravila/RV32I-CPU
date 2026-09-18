module testbench_CPU;

    logic clk;

    CPU_verification_interface CPU_interface(clk);

    RV32I_CPU CPU (
        .clk(clk),
        .reset(CPU_interface.reset),

        .debug_x1(CPU_interface.x1),
        .debug_x2(CPU_interface.x2),
        .debug_x3(CPU_interface.x3),
        .debug_x4(CPU_interface.x4),
        .debug_x5(CPU_interface.x5),

        .debug_if_id_pc(CPU_interface.if_id_pc),
        .debug_if_id_instruction(CPU_interface.if_id_instruction),

        .debug_pc(CPU_interface.pc),
        .debug_instruction(CPU_interface.instruction),

        .debug_branch_taken(CPU_interface.branch_taken),
        .debug_forward_a(CPU_interface.forward_a),
        .debug_forward_b(CPU_interface.forward_b),

        .debug_icache_hit(CPU_interface.icache_hit),
        .debug_dcache_hit(CPU_interface.dcache_hit)
    );

    always #5 clk = ~clk;

    initial begin

        uvm_config_db#(
            virtual CPU_verification_interface
        )::set(
            null,
            "*",
            "CPU_interface",
            CPU_interface
        );

        clk = 0;
        CPU_interface.reset = 1;

    end

    initial begin
        run_test("CPU_test");
    end

endmodule