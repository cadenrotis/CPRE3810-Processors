# MIPS test file that incorporates all forwarding and data hazard cases simultaneously
.data
num: .word  10             
.text
.globl main

main:
la   $s0, num        # load address of num variable into $s0

# Case 1:
addu $t2, $t0, $t1
subu $t3, $t1, $t2  # data hazard here with $t2
addu $t4, $t2, $t3  # data hazard here with $t3

# Case 2:
sll $t3, $t2, 2  # data hazard here with $t2
srl $t4, $t3, 2  # data hazard here with $t3
sw $t4, 0($s0)   # data haxard gere with $t4

# Case 3:
lw $t3, 0($s0)     
and $t4, $t3, $t2   # data hazard here with $t3 --> Load-use hazard
lw $t5, 0($s0)      
and $t4, $t5, $t4   # data hazard here with $t5 --> Load-use hazard

# Case 4:
lw $t3, 0($s0)      
and $t4, $t2, $t3   # data hazard here with $t3 --> Load-use hazard
lw $t5, 0($s0)      
and $t4, $t4, $t5   # data hazard here with $t5 --> Load-use hazard

# Case 5:
lw $t3, 0($s0)      
sw $t3 0($s0)       # data hazard here with $t3
lw $t5, 0($s0)      
sw $t5 0($s0)       # data hazard here with $t3

Exit:
halt
