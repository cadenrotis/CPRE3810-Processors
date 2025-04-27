# MIPS test file that incorporates all control hazard avoidance cases simultaneously
.data
.text
.globl main

main:

# Populate registers $t0 and $t1
addiu $t0, $zero, 4
addiu $t1, $zero, 4
j case1

case1:
beq $t0, $t1, branch_taken1  # Branch taken --> control hazard
j ToCase2              

branch_taken1:
and $t3, $t1, $t2         # Potential data hazard

ToCase2:
j case2                   # Control hazard

case2:
beq $t0, $t1, branch_taken2  # Branch not taken
j ToCase3

branch_taken2:
and $t3, $t1, $t2         # Potential data hazard

ToCase3:
j case3                   # Control hazard

case3:
j step1                   # Control hazard

add_two_nums:
addu $t2, $t0, $t1
jr $ra                    # Control hazard

step1:
jal add_two_nums          # Control hazard

Exit:
halt