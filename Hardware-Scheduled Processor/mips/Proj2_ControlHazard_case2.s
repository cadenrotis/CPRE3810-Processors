# Control hazard avoidance case 2: Branch not taken, so flushing isn't needed
.data
.text
.globl main

main:

# Populate registers $t0 and $t1
addiu $t0, $zero, 2
addiu $t1, $zero, 4

beq $t0, $t1, Next  # no control hazard since the branch won't be taken 
j Exit              # potential control hazard

Next:
and $t3, $t1, $t2   # potential data hazard

Exit:
halt