import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_test extends uvm_test;

`uvm_component_utils(CPU_test)

CPU_environment CPU_environment_instance;

virtual CPU_verification_interface CPU_interface;

function new(
    string name = "CPU_test",
    uvm_component parent = null
);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    CPU_environment_instance =
        CPU_environment::type_id::create(
            "CPU_environment_instance",
            this
        );

    if (!uvm_config_db#(virtual CPU_verification_interface)::get(
            this,
            "",
            "CPU_interface",
            CPU_interface
        ))

        `uvm_fatal(
            "CPU_TEST",
            "CPU_interface was not found"
        )

endfunction

task run_phase(uvm_phase phase);

    CPU_sequence CPU_sequence_instance;

    phase.raise_objection(this);

    CPU_sequence_instance =
        CPU_sequence::type_id::create(
            "CPU_sequence_instance"
        );

    CPU_interface.reset = 1;

    $display(
        "CPU TEST: RESET ASSERTED, reset=%0b",
        CPU_interface.reset
    );

    repeat (2) @(posedge CPU_interface.clk);

    CPU_interface.reset = 0;

    $display(
        "CPU TEST: RESET RELEASED, reset=%0b",
        CPU_interface.reset
    );

    CPU_sequence_instance.start(
        CPU_environment_instance
            .CPU_agent_instance
            .CPU_sequencer_instance
    );

    #200;
CPU_environment_instance.CPU_scoreboard_instance.check_results();

    phase.drop_objection(this);

endtask
endclass
