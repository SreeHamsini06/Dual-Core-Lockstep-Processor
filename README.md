Dual-Core Lockstep Processor with Fault Injection and Automated Error Recovery

Project Overview

This project presents the design and simulation of a dual-core lockstep processor using Verilog HDL and Xilinx Vivado. Two identical processor cores execute in parallel, while a comparator monitors their execution for mismatches.

The system incorporates fault injection and an automated recovery controller to investigate processor reliability under injected faults.

Objectives

- Design two identical processor cores.
- Implement lockstep execution and mismatch detection.
- Introduce controlled faults into Core 2.
- Develop an automated error recovery controller.
- Verify system behavior using simulation testbenches.

Tools and Technologies

- HDL: Verilog
- Simulation Tool: Xilinx Vivado 2022.2
- Design: Dual-core processor architecture
- Verification: Behavioral simulation

System Architecture

The design includes:

- Two processor cores
- Instruction memory and control logic
- Register files and ALUs
- Comparator
- Fault injection unit
- Recovery controller

Simulation and Verification

1. Normal Operation

The processor cores execute without intentional fault injection.

"Normal Operation" (simulation_results/no_fault.png)

2. Fault Injection

Controlled fault injection produces a mismatch between the processor cores, which is detected by the comparison logic.

"Fault Injection" (simulation_results/fault_injection.png)

3. Automated Recovery

The recovery controller activates after fault detection and generates recovery-control signals.

"Recovery" (simulation_results/recovery.png)

Results

Behavioral simulation demonstrates fault-injection activation, mismatch detection, error indication, and recovery-controller activity. Full restoration of processor state requires verification of matching core execution following recovery.

Future Scope

- FPGA hardware implementation
- Enhanced checkpointing and rollback
- Expanded fault-injection test coverage
- Performance and resource utilization analysis# Dual-Core-Lockstep-Processor
Design and simulation of a dual-core lockstep processor with fault injection,error detection, and automated recovery using Verilog HDL and Xilinx Vivado
