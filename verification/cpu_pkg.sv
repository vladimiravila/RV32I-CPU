package cpu_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "instruction_transaction.sv"
  `include "CPU_sequence.sv"
  `include "CPU_sequencer.sv"
  `include "CPU_driver.sv"
  `include "CPU_monitor.sv"
  `include "CPU_scoreboard.sv"
  `include "CPU_agent.sv"
  `include "CPU_environment.sv"
  `include "CPU_test.sv"
endpackage