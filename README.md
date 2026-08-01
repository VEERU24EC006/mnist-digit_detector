Hardware Architecture and Working Principles
This design takes a trained neural network and translates its mathematical operations into physical digital logic. The architecture is highly optimized for inference and is built upon several independent modules:

Memory Optimization (ROM vs. BRAM): Instead of utilizing standard Block RAM (BRAM) for all data storage, this design heavily leverages Read-Only Memory (ROM) structures for the static weights and biases. Since the AI model is already trained and fixed, these values never change during inference. Utilizing ROM minimizes the footprint of dynamic on-chip memory, significantly reduces overall power consumption, and bypasses the unnecessary logic overhead required for read/write operations.

Separate ROM Files: The trained weights, input pixels, and biases are distributed into distinct physical ROM structures rather than being bottlenecked in a single massive memory bank. This allows the hardware to fetch a pixel and all 10 corresponding weights simultaneously in a single clock cycle, ensuring massive data throughput.

Top Module: The highest level of the architecture hierarchy. It wires all the sub-modules together and bridges the internal logic to the physical I/O pins of the FPGA (Clock, Reset, Start, and the predicted output).

Finite State Machine (FSM): The control center of the design. It dictates the strict timing required to generate memory addresses, enable the MAC units at the exact right clock cycle, and trigger the final decision phase once all 784 pixels are processed.

MAC Units: Multiply-Accumulate blocks. There are 10 of these running in parallel, one dedicated to each digit. For every clock cycle, they multiply the incoming pixel value by its unique weight and add it to a running accumulated score.

Argmax: Once the FSM signals that the image processing is complete, this module simultaneously compares the final 10 scores and outputs the index (0 through 9) of the highest value, locking in the final hardware prediction.

Hardware Target and Implementation
This design has been fully synthesized, implemented, and routed for physical hardware. A generated .bit bitstream file is available in this repository.

Target Board: Digilent Basys 3

Target Silicon Part: xc7a35tcpg236-1 (Artix-7)

Inputs: Clock, Reset, Start (Mapped to physical switches)

Outputs: Predicted Digit [3:0], Done flag (Mapped to physical LEDs)

Synthesis and Performance Results
The SystemVerilog RTL successfully synthesizes into a highly efficient, lightweight hardware footprint.

Resource Utilization
The architecture efficiently infers hardware multipliers instead of wasting general logic gates, using exactly one DSP slice per digit.

LUTs: 971 (4.67%)

Flip-Flops (FF): 358 (0.86%)

Block RAM (BRAM): 2 (4.00%)

DSP Slices: 10 (11.11%)

Timing Constraints
The system operates flawlessly on a 100 MHz clock (10.00 ns period) with zero timing violations.

Worst Negative Slack (WNS): +1.804 ns

Worst Hold Slack (WHS): +0.142 ns

Total Negative Slack (TNS): 0.000 ns
Status: All user-specified timing constraints are successfully met.

Power Summary
The hardware operates with extreme efficiency compared to a standard CPU running inference.

Total On-Chip Power: 0.116 W

Dynamic Power: 0.044 W

Device Static Power: 0.072 W
