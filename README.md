# CPRE3810-Processors
GitHub repository containing all VHDL code and writeups for Caden Otis and Christopher Hausner's single and multi-cycle processors design and analysis projects.

# Project Overview:
Our first project was to design a single-cycle processor, where only one MIPS instruction is fetched, decoded, and executed per cycle (at every positive edge of the clock). For this project, we first needed to implement a control logic module that would take care of the decoding of every MIPS instruction, and then properly set control signals that will be sent out to all major functional units within the processor digital circuit (Register File, ALU, Data Memory, MUXes, and PC update logic). Once we created our control logic module and thoroughly tested it with its own testbench, we then had to modify our ALU (previously created in a lab) to support new types of MIPS instructions. Part of this modification involved us implementing a shifter module to handle all shifting-related MIPS instructions. We then needed to create a Load Selector module to handle the loading of byte and halfword values from Data Memory. After putting everything together into one final digital circuit and writing our own MIPS tests, our final processor design was able to handle almost all instructions we threw at it. 

Part of our second project was to design a Software Scheduled Pipeline Processor. This processor uses the basis of the single-cycle processor to create a 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback), allowing for multiple instructions to be in the 
processor at one time, unlike the single-cycle processor. Using this pipelined approach allows for shorter cycle times/cycle periods and cycles to be executed per instruction (CPI). However, pipelining also brings new challenges into the mix: data and control hazards.
To avoid these hazards, we insert NOP instructions (don't change state or memory) into each MIPS test file that will be ran on the processor to stall the pipeline. However, this increases the average CPI of the processor, hindering the performance gain from switching
to a pipelined processor.

Part of our second project was also to design a Hardware Scheduled Pipeline Processor. This processor builds off of our software-scheduled processor to make the pipelined design more efficient with more performance gain. To do this, we modify the hardware of the processor
to detect hazards and then forward or stall depending on the situation (for data hazards) or flush (for control hazards) without ever touching the MIPS test files. By forwarding, this reduces the amount of stalling needed, which helps to lower the average CPI to the
ideal value of 1.0, giving us the best performance gain.

Our third and final project was to perform a comparative performance analysis between all three processors that we designed and created thus far. In this project, we analyzed the performance of each processor, considered SW and HW optimizations that we could’ve made to these processors, and wrote assembly programs that these optimizations into consideration. We then reflected on the challenges that we faced while making these three processors and how we got around them.


# Resources Used: 
 - VHDL
 - QuestaSim
 - MIPS Assembly
 - MARS MIPS Assembler and Runtime Simulator
 - CPRE 3810 Toolflow (custom tool for running our processors against MIPS test files)
 - Microsoft Excel
 - Google Docs

# Directory Navigation: 
Most VHDL files can be found in the /proj/ directory for the single-cycle processor or in the current directory in the mips, src, and test files.

For VHDL source files used for the main components of our processors, navigate to src/TopLevel.
For the VHDL testbenches used for testing our processors in QuestaSim, navigate to the test subdirectory.
For the MIPS assembly instructions files we used for exhaustive testing of our processors, navigate to the mips subdirectory.
