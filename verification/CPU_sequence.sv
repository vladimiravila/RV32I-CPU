import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_sequence extends uvm_sequence #(instruction_transaction);

    `uvm_object_utils(CPU_sequence)

    function new(string name = "CPU_sequence");
        super.new(name);
    endfunction

    task body();

        instruction_transaction instruction;

        instruction = instruction_transaction::type_id::create("instruction_1");
        start_item(instruction);
        instruction.memory_index = 0;
        instruction.instruction  = 32'h02A00093;
        finish_item(instruction);
        start_item(instruction);
        instruction.memory_index = 1;
        instruction.instruction  = 32'h00808113;
        finish_item(instruction);

        instruction = instruction_transaction::type_id::create("instruction_3");
        start_item(instruction);
        instruction.memory_index = 2;
        instruction.instruction  = 32'h002081B3;
        finish_item(instruction);

    endtask

endclass
