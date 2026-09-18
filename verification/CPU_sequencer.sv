import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_sequencer extends uvm_sequencer #(instruction_transaction);

    `uvm_component_utils(CPU_sequencer)

    function new(
        string name = "CPU_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass
