import uvm_pkg::*;
`include "uvm_macros.svh"

class instruction_transaction extends uvm_sequence_item;

    rand bit [31:0] instruction;
    rand int unsigned memory_index;

    `uvm_object_utils(instruction_transaction)

    function new(string name = "instruction_transaction");
        super.new(name);
    endfunction

endclass