# Forwarding case 2: Forward result from input of the memory stage to input (input B of the ALU) of the execution stage
.data
num: .word  10             
.text
.globl main

main:
la   $s0, num        # load address of num variable into $s0

# Populate registers $t0 and $t1
addiu $t0, $zero, 2
addiu $t1, $zero, 4

addu $t2, $t0, $t1 # data hazard here with $t0 and $t1
sll $t3, $t2, 2    # data hazard here with $t2
srl $t4, $t3, 2    # data hazard here with $t3
sw $t4, 0($s0)     # data haxard gere with $t4

Exit:
halt
