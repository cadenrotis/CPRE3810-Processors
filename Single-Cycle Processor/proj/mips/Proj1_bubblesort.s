
.data
#Array
christopher: 0xF, 0x9, 0x8, 0xD, 0x3, 0x1, 0x6, 0xC, 0x4, 0x2, 0x5, 0x7, 0xA, 0xB, 0x0
length: 15
.text
.globl main
main:

la $a0, christopher #Load our address for christopher to be passed into call
lw $a1, length
jal BubbleSort#Call Bubble Sort
j display#one by one load into a register to show questasim works 


BubbleSort:
addiu $s0, $a1, 0#Get the length
addiu $s1, $zero, 0#Our counter for the outer loop.  
subi $s0, $s0, 1#Sub 1 for array loop purposes


ForLoopOuter:
addi $s4, $a0, 0#Set our array start to S4
addiu $s2, $zero, 0#Each time outer loop is called we would reset the inner loop.
sub $s3, $s0, $s1#Our inner loop stop value changes. 


ForLoopInner:
lw $t0, ($s4)#load array @s2 position in array
lw $t1, 4($s4)#load array @s2+1
#Compare S2 to S2+1
slt $t3, $t1, $t0#if S2 is Greater Perform a swap else move on with loop.
beq $t3, $zero, NoSwap#If 0 we dont need to swap

#Swap out elements
sw $t1, ($s4)
sw $t0, 4($s4)

NoSwap:
#inner loop cond
addiu $s4, $s4, 4#increment array pos
addiu $s2, $s2, 1#incremeout our counter for Inner
slt $t0, $s2, $s3 #if we are less ,this is 1. 
bne $t0, $zero, ForLoopInner#if 1, call the loop.  


#outerloop cond
addiu $s1, $s1, 1#incremeout our counter for Outer
slt $t0, $s1, $s0 #if we are less ,this is 1. 
bne $t0, $zero, ForLoopOuter#if 1, call the loop.  
jr $ra#return

display:
#la $a0, christopher #Load our address for christopher to be passed into call
#lw $a1, length
la $s0, christopher#Load array again
lw $s1, length#Load length again
addiu $s2, $zero, 0#Counter

displayLoop: #$v0 displays final valyes one by one
lw $v0, ($s0) #load array @position in array
addiu $s0, $s0, 4#increment array pos
addiu $s2, $s2, 1#incremeout our counter for Inner
slt $t0, $s2, $s1 #if we are less ,this is 1. 
bne $t0, $zero, displayLoop#if 1, call the loop.  



halt









