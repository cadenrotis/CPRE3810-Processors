# Forwarding case 4: Forward result from the writeback stage to input (input B of the ALU) of the execution stage
.data
num: .word  10             
.text
.globl main

main:
la   $s0, num        # load address of num variable into $s0

# Populate registers $t0 and $t1
addiu $t0, $zero, 2
addiu $t1, $zero, 4

addu $t2, $t0, $t1  # data hazard here with $t0 and $t1
lw $t3, 0($s0)      
and $t4, $t2, $t3   # data hazard here with $t3 --> Load-use hazard

lw $t5, 0($s0)      
and $t4, $t4, $t5   # data hazard here with $t5 --> Load-use hazard

Exit:
halt
