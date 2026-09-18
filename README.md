# RV32I CPU

A 5-stage pipelined RISC-V processor implemented in Verilog, supporting a subset of the RV32I instruction set. The processor includes instruction and data caches, data forwarding, hazard detection, and branch handling, along with a SystemVerilog/UVM verification environment.

## Architecture

* 5-stage pipeline: IF, ID, EX, MEM, WB
* Pipeline registers between stages
* Data forwarding for resolving data dependencies
* Load-use hazard detection and pipeline stalling
* Branch detection and pipeline flushing
* Register file and immediate generation
* Simple direct-mapped instruction and data caches

## Supported Instructions

The current decoder implements:

* ADD
* SUB
* AND
* OR
* XOR
* ADDI
* LW
* SW
* BEQ

## Verification

The project includes a directed UVM testbench containing:

* Sequence
* Sequencer
* Driver
* Monitor
* Scoreboard
* Agent
* Environment
* Test
* Instruction transaction

The demonstrated test loads a three-instruction program and checks the final values of x1, x2, and x3:

* x1 = 42
* x2 = 50
* x3 = 92

The test exercises register dependencies and data forwarding.

## Tools

* Verilog
* SystemVerilog
* UVM
* Intel Quartus
* ModelSim

## Project Structure

RV32I-CPU/
├── RTL/
│   ├── Processor and pipeline modules
│   ├── Cache and memory modules
│   └── Datapath and control modules
├── verification/
│   └── SystemVerilog/UVM testbench
├── testbench_CPU.sv
└── README.md


## Notes

This processor implements a subset of the RV32I instruction set. The current UVM environment demonstrates directed testing with a fixed test program rather than comprehensive randomized verification or functional coverage.
