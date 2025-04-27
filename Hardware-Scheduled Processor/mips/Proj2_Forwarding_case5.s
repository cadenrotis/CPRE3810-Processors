# Forwarding case 5: Forward result from the writeback stage to to the dataIn input in the memory stage
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
sw $t3 0($s0)       # data hazard here with $t3

lw $t5, 0($s0)      
sw $t5 0($s0)       # data hazard here with $t3

Exit:
halt
