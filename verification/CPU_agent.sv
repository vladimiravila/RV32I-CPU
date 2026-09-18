import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_agent extends uvm_agent;

    `uvm_component_utils(CPU_agent)

    CPU_sequencer CPU_sequencer_instance;
    CPU_driver CPU_driver_instance;
    CPU_monitor CPU_monitor_instance;

    function new(
        string name = "CPU_agent",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        CPU_sequencer_instance =
            CPU_sequencer::type_id::create(
                "CPU_sequencer_instance",
                this
            );

        CPU_driver_instance =
            CPU_driver::type_id::create(
                "CPU_driver_instance",
                this
            );

        CPU_monitor_instance =
            CPU_monitor::type_id::create(
                "CPU_monitor_instance",
                this
            );

    endfunction

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        CPU_driver_instance.seq_item_port.connect(
            CPU_sequencer_instance.seq_item_export
        );

    endfunction

endclass
