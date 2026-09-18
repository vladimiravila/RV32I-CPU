import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_driver extends uvm_driver #(instruction_transaction);

    `uvm_component_utils(CPU_driver)

    virtual CPU_verification_interface CPU_interface;

    function new(
        string name = "CPU_driver",
        uvm_component parent = null
    );
        super.new(name, parent);
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
                "CPU_DRIVER",
                "CPU_interface was not found"
            )

    endfunction

  task run_phase(uvm_phase phase);

    instruction_transaction instruction;

    forever begin

        seq_item_port.get_next_item(instruction);

        $display(
            "CPU DRIVER: index=%0d instruction=%b",
            instruction.memory_index,
            instruction.instruction
        );

        if (!uvm_hdl_deposit(
                $sformatf(
                    "testbench_CPU.CPU.imem.memory[%0d]",
                    instruction.memory_index
                ),
                instruction.instruction
            )) begin

            `uvm_error(
                "CPU_DRIVER",
                $sformatf(
                    "Could not write instruction memory location %0d",
                    instruction.memory_index
                )
            )

        end
        else begin

            $display(
                "CPU DRIVER: deposit SUCCESS index=%0d",
                instruction.memory_index
            );

        end

        seq_item_port.item_done();

    end

endtask

endclass
