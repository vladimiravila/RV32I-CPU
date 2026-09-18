import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_monitor_transaction extends uvm_sequence_item;

    bit [31:0] pc;
    bit [31:0] instruction;

    bit [31:0] x1;
    bit [31:0] x2;
    bit [31:0] x3;
    bit [31:0] x4;
    bit [31:0] x5;

    bit branch_taken;

    bit [1:0] forward_a;
    bit [1:0] forward_b;

    bit icache_hit;
    bit dcache_hit;

    `uvm_object_utils(CPU_monitor_transaction)

    function new(string name = "CPU_monitor_transaction");
        super.new(name);
    endfunction

endclass


class CPU_monitor extends uvm_monitor;

    `uvm_component_utils(CPU_monitor)

    virtual CPU_verification_interface CPU_interface;

    uvm_analysis_port #(CPU_monitor_transaction) analysis_port;

    function new(
        string name = "CPU_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);

        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if (!uvm_config_db#(virtual CPU_verification_interface)::get(
                this,
                "",
                "CPU_interface",
                CPU_interface
            ))

            `uvm_fatal(
                "CPU_MONITOR",
                "CPU_interface was not found"
            )

    endfunction

    task run_phase(uvm_phase phase);

        CPU_monitor_transaction transaction;

        forever begin

            @(posedge CPU_interface.clk);

            if (CPU_interface.reset)
                continue;

            transaction =
                CPU_monitor_transaction::type_id::create(
                    "transaction"
                );

            transaction.pc =
                CPU_interface.pc;

            transaction.instruction =
                CPU_interface.instruction;

            transaction.x1 =
                CPU_interface.x1;

            transaction.x2 =
                CPU_interface.x2;

            transaction.x3 =
                CPU_interface.x3;

            transaction.x4 =
                CPU_interface.x4;

            transaction.x5 =
                CPU_interface.x5;

            transaction.branch_taken =
                CPU_interface.branch_taken;

            transaction.forward_a =
                CPU_interface.forward_a;

            transaction.forward_b =
                CPU_interface.forward_b;

            transaction.icache_hit =
                CPU_interface.icache_hit;

            transaction.dcache_hit =
                CPU_interface.dcache_hit;

            analysis_port.write(transaction);

        end

    endtask

endclass
