# Control hazard avoidance case 3: Jumping and flushing of the earlier stages
.data
.text
.globl main

main:
# Populate registers $t0 and $t1
addiu $t0, $zero, 2
addiu $t1, $zero, 4
j Step1               # control hazard   

add_two_nums:
addu $t2, $t0, $t1
jr $ra                # control hazard         

Step1:
jal add_two_nums      # control hazard   

Exit:
halt