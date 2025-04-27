# Forwarding case 1: Forward result from input of the memory stage to input (input A of the ALU) of the execution stage
.data
.text
.globl main

main:

# Populate registers $t0 and $t1
addiu $t0, $zero, 2
addiu $t1, $zero, 4

addu $t2, $t0, $t1  # data hazard here with $t0 and $t1
subu $t3, $t1, $t2  # data hazard here with $t2
addu $t4, $t2, $t3  # data hazard here with $t3

Exit:
halt
