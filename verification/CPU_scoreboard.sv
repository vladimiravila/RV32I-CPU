import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(CPU_scoreboard)

    uvm_analysis_imp #(
        CPU_monitor_transaction,
        CPU_scoreboard
    ) analysis_port;

    CPU_monitor_transaction latest_transaction;

    function new(
        string name = "CPU_scoreboard",
        uvm_component parent = null
    );
        super.new(name, parent);

        analysis_port = new("analysis_port", this);
    endfunction

    function void write(
        CPU_monitor_transaction transaction
    );

        latest_transaction = transaction;

        $display(
            "CPU MONITOR: PC=%0d instruction=%b x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d branch=%0b forward_a=%b forward_b=%b ICache=%0b DCache=%0b",
            transaction.pc,
            transaction.instruction,
            transaction.x1,
            transaction.x2,
            transaction.x3,
            transaction.x4,
            transaction.x5,
            transaction.branch_taken,
            transaction.forward_a,
            transaction.forward_b,
            transaction.icache_hit,
            transaction.dcache_hit
        );

    endfunction

    function void check_results();

        if (latest_transaction == null) begin
            `uvm_error(
                "CPU_SCOREBOARD",
                "No transaction was received"
            );
            return;
        end

        if (latest_transaction.x1 != 42) begin
            `uvm_error(
                "CPU_SCOREBOARD",
                $sformatf(
                    "x1 incorrect: expected 42, got %0d",
                    latest_transaction.x1
                )
            );
        end
        else begin
            `uvm_info(
                "CPU_SCOREBOARD",
                "x1 PASS: expected 42, got 42",
                UVM_LOW
            );
        end

        if (latest_transaction.x2 != 50) begin
            `uvm_error(
                "CPU_SCOREBOARD",
                $sformatf(
                    "x2 incorrect: expected 50, got %0d",
                    latest_transaction.x2
                )
            );
        end
        else begin
            `uvm_info(
                "CPU_SCOREBOARD",
                "x2 PASS: expected 50, got 50",
                UVM_LOW
            );
        end

        if (latest_transaction.x3 != 92) begin
            `uvm_error(
                "CPU_SCOREBOARD",
                $sformatf(
                    "x3 incorrect: expected 92, got %0d",
                    latest_transaction.x3
                )
            );
        end
        else begin
            `uvm_info(
                "CPU_SCOREBOARD",
                "x3 PASS: expected 92, got 92",
                UVM_LOW
            );
        end

    endfunction

endclass