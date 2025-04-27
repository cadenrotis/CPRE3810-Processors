# MIPS file to test all arithmetic and logical instructions with our processor design
.data
.text
.globl main

main:
li $sp, 0xEFFC
lui $sp, 0x7FFF

nop
nop
nop
jal Beginning
nop # avoid control hazard
nop
nop
nop
j Exit
nop # avoid control hazard
nop
nop
nop

Beginning:
addiu $sp,$sp, -24 # allocate an activatino record
nop # avoid data hazard with $sp
nop
nop
sw $ra, 20($sp) # save the return address

# Addition instructions
addiu $t0, $zero, 1     # $t0 = 1 = 0x1
addiu $t1, $zero, 4     # $t1 = 4 = 0x4
nop # avoid data hazard with $t0 and $t1
nop
nop
add $t2, $t0, $t1       # $t2 = 1 + 4 = 5 = 0x5
nop # avoid data hazard with $t2
nop
nop  
addu $t3, $t2, $t2      # $t3 = 5 + 5 = 10 = 0xA
addi $t4, $t1, 9        # $t4 = 4 + 9 = 13 = 0xD     

# Subtraction instructions
nop # avoid data hazard with $t3
nop
sub $t5, $t3, $t2       # $t5 = 10 - 5 = 5 = 0x5
nop # avoid data hazard with $t5
nop
nop
subu $t6, $t5, $t0      # $t6 = 5 - 1 = 4 = 0x4

# Shift instructions
sll $t0, $t0, 2         # $t0 = 1 * 2^2 = 1 * 4 = 4 = 0x4
srl $t1, $t1, 2         # $t1 = 4 / 2^2 = 4 / 4 = 1 = 0x1
lui $t7, 0xFF00         # $t7 = 0xFF000000
nop # avoid data hazard with $t7
nop
nop
sra $t7, $t7, 16        # $t7 = 0xFFFFFF00

sllv $t2, $t2, $t1      # $t2 = 5 * 1^2 = 5 * 2 = 10 = 0xA
addiu $t3, $zero, 16    # $t3 = 0 + 16 = 16 = 0x10
nop # avoid data hazard with $t3
nop
nop
srlv $t3, $t3, $t1      # $t3 = 16 / 1^2 = 16 / 2 = 6 = 0x8
nop # avoid data hazard with $t3
nop
nop
srav $t7, $t7, $t3      # $t7 = 0xFFFFFFFF

# Set less than instructions
slt $s0, $t1, $t0       # $s0 = 1 = 0x1
slti $s1, $t3, 4        # $s1 = 0 = 0x0

addiu $t0, $zero, 0x1001  # $t0 = 0x00001001
addiu $t1, $zero, 0x1111  # $t1 = 0x00001111

# Bitwise instructions
nop # avoid data hazard with $t0 and $t1
nop
nop
and $t2, $t0, $t1       # $t2 = 0x00001001
andi $t3, $t0, 0x0000   # $t3 = 0x0

nor $t4, $t0, $t1       # $t4 = 0xFFFFEEEE
xor $t5, $t0, $t1       # $t5 = 0x00000110
xori $t4, $t2, 0x1010   # $t5 = 0x00000011

or $t6, $t2, $t3        # $t6 = 0x00001001
nop # avoid data hazard with $t5
ori $t7, $t5, 0x11      # $t7 = 0x00000111

# conditional flow
li $t0, 2
li $t1, 2
nop # avoid data hazard with $t0 and $t1
nop
nop
beq $t0, $t1, Cond1 # branch to Cond1 if $t0 and $t1 are equal
nop # avoid control hazard
nop
nop
nop
j Deallocate
nop # avoid control hazard
nop
nop
nop

Deallocate:
lw $ra, 20($sp) # get the return address
addiu $sp,$sp, 24 # deallocate the activatino record
nop # # avoid data hazard with $ra
nop
jr $ra
nop # avoid control hazard
nop
nop
nop

Cond1:
addiu $t1, $t1, 2 
nop # avoid data hazard with $t1
nop
nop
bne $t0, $t1, Cond2 # branch to Cond2 if $t0 and $t1 aren't equal
nop # avoid control hazard
nop
nop
nop
j Deallocate
nop # avoid control hazard
nop
nop
nop

Cond2:
lui $s0, 0x1001
nop # avoid data hazard with $s0
nop
nop
sw $t0, 0($s0)
lb $t1, 0($s0)
lbu $t2, 0($s0)

addiu $s0, $s0, 4
addiu $t0, $t0, 0xF0
nop # avoid data hazard with $s0 and $t0
nop
nop
sw $t0, 0($s0)
lh $t3, 0($s0)
lhu $t4, 0($s0)
j Deallocate
nop # avoid control hazard
nop
nop
nop

Exit:
halt
