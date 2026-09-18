import uvm_pkg::*;
`include "uvm_macros.svh"

class CPU_environment extends uvm_env;

    `uvm_component_utils(CPU_environment)

    CPU_agent CPU_agent_instance;
    CPU_scoreboard CPU_scoreboard_instance;

    function new(
        string name = "CPU_environment",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        CPU_agent_instance =
            CPU_agent::type_id::create(
                "CPU_agent_instance",
                this
            );

        CPU_scoreboard_instance =
            CPU_scoreboard::type_id::create(
                "CPU_scoreboard_instance",
                this
            );

    endfunction

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        CPU_agent_instance.CPU_monitor_instance.analysis_port.connect(
            CPU_scoreboard_instance.analysis_port
        );

    endfunction

endclass
