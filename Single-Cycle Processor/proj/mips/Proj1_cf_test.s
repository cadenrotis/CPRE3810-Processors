# MIPS file to test all control flow instructions
.data
.text
.globl main


#set stack pointer to be correct
li $sp, 0x7fffeffc

main:
li $a0, 10  # set argument n = 10 = 0xA --> result in a call depth of 9, 8 activation records allocated on the stack
jal Fact    # call the fact procedure for the first time
j Exit

Fact:
# base case 1
slti $t0, $a0, 1       # check if n < 1
bne $t0, $zero, Base1  # enter the first base case if n < 1

# base case 2
addiu $t1, $zero, 2    # $t1 = 2 = 0x2
beq $a0, $t1, Base2    # enter the second base case if n = 2

# recursive case
addiu $sp, $sp, -24   # allocate an activation record
sw $ra, 20($sp)       # save the return address
sw $s0, 16($sp)       # save $s0, which holds n

addu $s0, $zero, $a0  # $s0 = n

addiu $a0, $a0, -1    # change argument to n - 1
jal Fact              # recursively call fact(n - 1)

addu $t2, $zero, $s0  # $t2 = n
addu $t3, $zero, $v0  # $t3 = fact(n-1)
sll $t2, $t2, 1       # $t2 = n * 1^2 = n * 2
sll $t3, $t3, 1       # $t3 = fact(n-1) * 1^2 = fact(n-1) * 2 
add $v0, $t2, $t3     # $v0 = n * fact(n-1) --> final value of $v0 = 0x000009e8

lw $ra, 20($sp)       # restore the return address
lw $s0, 16($sp)       # restore the current value of n
addiu $sp, $sp, 24    # deallocate the activation record
jr $ra                

Base1:
addiu $v0, $zero, 1   # return 1
jr $ra           

Base2:
addiu $v0, $zero, 2   # return 2
jr $ra

Exit:                 # end the program
halt 
