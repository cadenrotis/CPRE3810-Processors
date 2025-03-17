# CPRE3810-Processors
GitHub repository containing all VHDL code and writeups for Caden Otis and Christopher Hausner's single and multi-cycle processors design and analysis projects.

# Project Overview:
Our first project was to design a single-cycle processor, where only one MIPS instruction is fetched, decoded, and executed per cycle (at every positive edge of the clock). For this project, we first needed to implement a control logic module that would take care of the decoding of every MIPS instruction, and then properly set control signals that will be sent out to all major functional units within the processor digital circuit (Register File, ALU, Data Memory, MUXes, and PC update logic). Once we created our control logic module and thoroughly tested it with its own testbench, we then had to modify our ALU (previously created in a lab) to support new types of MIPS instructions. Part of this modification involved us implementing a shifter module to handle all shifting-related MIPS instructions. We then needed to create a Load Selector module to handle the loading of byte and halfword values from Data Memory. After putting everything together into one final digital circuit and writing our own MIPS tests, our final processor design was able to handle almost all instructions we threw at it. 

Part of our second project was to design a Software Scheduled Pipeline Processor. *Finish once project is done

Part of our second project was also to design a Hardware Scheduled Pipeline Processor. *Finish once project is done

Our third and final project was to perform a comparative performance analysis between all three processors that we designed and created thus far. *Finish once project is done

# Resources Used: 
 - VHDL
 - QuestaSim
 - MIPS Assembly
 - MARS MIPS Assembler and Runtime Simulator
 - CPRE 3810 Toolflow (custom tool for running our processors against MIPS test files)
 - Microsoft Excel
 - Google Docs
