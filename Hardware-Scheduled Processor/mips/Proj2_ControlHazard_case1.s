# Control hazard avoidance case 1: Branch taken, reuqiring flushing of the earlier stages
.data
.text
.globl main

main:

# Populate registers $t0 and $t1
addiu $t0, $zero, 4
addiu $t1, $zero, 4

beq $t0, $t1, Next  # control hazard since the branch will be taken
j Exit              # potential control hazard

Next:
and $t3, $t1, $t2   # potential data hazard

Exit:
halt