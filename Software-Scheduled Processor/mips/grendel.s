#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
	#li $sp, 0x10011000 expand this instruction out so we can install NOPs
        lui $1, 0x1001
        nop # avoid data hazard with $1
        nop
        nop
        ori $2, $1, 0x1000 # $2 = 0x10011000
	li $fp, 0
	
	#la $ra pump
	lasw  $ra pump # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
	j main # jump to the starting location
	nop # avoid control hazard
        nop
        nop
        nop
pump:
	nop
	nop
	nop
	halt

main:
	li $sp, 0xEFFC
	lui $sp, 0x7FFF
	nop
	nop
	nop
        addiu   $sp,$sp,-40 # MAIN
        nop # avoid data hazard with $sp
	nop
	nop
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add    	$fp,$sp,$zero
        nop # avoid data hazard with $fp
	nop
	nop
        sw      $0,24($fp)
        j       main_loop_control
        nop # avoid control hazard
        nop
        nop
        nop

main_loop_body:
        lw      $4,24($fp)
        #la 	$ra, trucks
        lasw    $ra, trucks # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j     is_visited
        nop # avoid control hazard
        nop
        nop
        nop
        
trucks:
        xori    $2,$2,0x1
        nop # avoid data hazard with $2
        nop
        nop
        andi    $2,$2,0x00ff
        nop # avoid data hazard with $2
        nop
        nop
        beq     $2,$0,kick
        nop # avoid control hazard
        nop
        nop
        nop

        lw      $4,24($fp)
        # addi 	$k0, $k0,1# breakpoint
        #la 	$ra, billowy
        lasw    $ra, billowy # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j     	topsort
        nop # avoid control hazard
        nop
        nop
        nop

billowy:

kick:
        lw      $2,24($fp)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,24($fp)
        
main_loop_control:
        lw      $2,24($fp)
        nop # avoid data hazard with $2
        nop
        nop
        slti     $2,$2, 4
        nop # avoid data hazard with $2
        nop
        nop
        beq	$2, $zero, hew # beq, j to simulate bne 
        nop # avoid control hazard
        nop
        nop
        nop
        j       main_loop_body
        nop # avoid control hazard
        nop
        nop
        nop
        
hew:
        sw      $0,28($fp)
        j       welcome
        nop # avoid control hazard
        nop
        nop
        nop

wave:
        lw      $2,28($fp)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,28($fp)
        
welcome:
        lw      $2,28($fp)
        nop # avoid data hazard with $2
        nop
        nop
        slti    $2,$2,4
        nop # avoid data hazard with $2
        nop
        nop
        xori	$2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop # avoid data hazard with $2
        nop
        nop
        beq     $2,$0,wave
        nop # avoid control hazard
        nop
        nop
        nop

        move    $2,$0
        move    $sp,$fp
        nop # avoid data hazard with $sp
        nop
        nop
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        nop # avoid data hazard with $fp when it returns
        nop
        jr       $ra
        nop
        nop
        nop
        
interest:
        lw      $4,24($fp)
        #la	$ra, new
        lasw    $ra, new # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j	is_visited
        nop # avoid control hazard
        nop
        nop
        
new:
        xori    $2,$2,0x1
        nop # avoid data hazard with $2
        nop
        nop
        andi    $2,$2,0x00ff
        nop # avoid data hazard with $2
        nop
        nop
        beq     $2,$0,tasteful
        nop # avoid control hazard
        nop
        nop
        nop

        lw      $4,24($fp)
        #la	$ra, partner
        lasw  $ra, partner # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j     	topsort
        nop # avoid control hazard
        nop
        nop
        nop
        
partner:

tasteful:
        addiu   $2,$fp,28
        nop # avoid data hazard with $2
        nop
        nop
        move    $4,$2
        #la	$ra, badge
        lasw    $ra, badge# MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j     next_edge
        nop # avoid control hazard
        nop
        nop
        nop
        
badge:
        sw      $2,24($fp)
        
turkey:
        lw      $3,24($fp)
        # li      $2,-1 expand this instruction out so we can install NOPs
        lui $1, 0xFFFF
        nop # avoid data hazard with $1
        nop
        nop
        ori $2, $1, 0xFFFF # $2 = 0xFFFFFFFF, which is -1 in two's complement
        nop # avoid data hazard with $2
        nop
        nop
        beq	$3,$2,telling # beq, j to simulate bne
        nop # avoid control hazard
        nop
        nop
        nop
        j	interest
        nop # avoid control hazard
        nop
        nop
        nop
        
telling:
	#la 	$v0, res_idx
	lasw    $v0, res_idx # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
	nop # avoid data hazard with $v0
        nop
        nop
	lw	$v0, 0($v0)
        nop # avoid data hazard with $v0
        nop
        nop
        addiu   $4,$2,-1
        #la 	$3, res_idx
        lasw    $3, res_idx # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        nop # avoid data hazard with $3
        nop
        nop
        sw 	$4, 0($3)
        #la	$4, res
        lasw    $4, res  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        #lui     $3,%hi(res_idx)
        #sw      $4,%lo(res_idx)($3)
        #lui     $4,%hi(res)
        sll     $3,$2,2
        nop # avoid data hazard with $2
        nop
        nop
        srl	$3,$3,1
        nop # avoid data hazard with $2
        nop
        nop
        sra	$3,$3,1
        nop # avoid data hazard with $2
        nop
        nop
        sll     $3,$3,2
       
       	xor	$at, $ra, $2 # does nothing 
        nor	$at, $ra, $2 # does nothing 
        
        #la	$2, res
        lasw    $2, res # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        nop # avoid data hazard with $2
        nop
        nop
        andi	$at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        nop # avoid data hazard with $at
        nop
        nop
        addu 	$2, $4, $at
        nop # avoid data hazard with $2
        nop
        nop
        addu    $2,$3,$2
        lw      $3,48($fp)
        nop # avoid data hazard with $3
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop # avoid data hazard with $sp
        nop
        nop
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        nop # avoid data hazard with $fp when returned
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop
   
topsort:
        addiu   $sp,$sp,-48
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        nop # avoid data hazard with $fp
        nop
        nop
        sw      $4,48($fp)
        lw      $4,48($fp)
        #la	$ra, verse
        lasw    $ra, verse  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j	mark_visited
        nop # avoid control hazard
        nop
        nop
        nop
        
verse:
        addiu   $2,$fp,28
        lw      $5,48($fp)
        nop
        nop
        move    $4,$2
        #la 	$ra, joyous
        lasw    $ra, joyous  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j	iterate_edges
        nop # avoid control hazard
        nop
        nop
        nop
        
joyous:
        addiu   $2,$fp,28
        nop # avoid data hazard with $2
        nop
        nop
        move    $4,$2
        #la	$ra, whispering
        lasw    $ra, whispering  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j     	next_edge
        nop # avoid control hazard
        nop
        nop
        nop
        
whispering:
        sw      $2,24($fp)
        j       turkey
        nop # avoid control hazard
        nop
        nop
        nop

iterate_edges:
        addiu   $sp,$sp,-24
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $fp,20($sp)
        move    $fp,$sp
        nop # avoid data hazard with $sp
        nop
        nop
        subu	$at, $fp, $sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        lw      $2,28($fp)
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        lw      $2,24($fp)
        lw      $4,8($fp)
        lw      $3,12($fp)
        nop # avoid data hazard with $4
        nop
        sw      $4,0($2)
        sw      $3,4($2)
        lw      $2,24($fp)
        move    $sp,$fp
        nop # avoid data hazard with $sp
        nop
        nop
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop
        
next_edge:
        addiu   $sp,$sp,-32
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $31,28($sp)
        sw      $fp,24($sp)
        add	$fp,$zero,$sp
        nop # avoid data hazard with $fp
        nop
        nop
        sw      $4,32($fp)
        j       waggish
        nop # avoid control hazard
        nop
        nop
        nop

snail:
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,4($2)
        nop # avoid data hazard with $2
        nop
        nop
        move    $5,$2
        move    $4,$3
        #la	$ra,induce
        lasw    $ra,induce # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        j       has_edge
        nop # avoid control hazard
        nop
        nop
        nop
        
induce:
        beq     $2,$0,quarter
        nop # avoid control hazard
        nop
        nop
        nop
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,4($2)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $4,$2,1
        lw      $3,32($fp)
        nop # avoid data hazard with $3
        nop
        nop
        sw      $4,4($3)
        j       cynical
        nop # avoid control hazard
        nop
        nop
        nop

quarter:
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,4($2)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $3,$2,1
        lw      $2,32($fp)
        nop # avoid data hazard with $3
        nop
        nop
        sw      $3,4($2)

waggish:
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,4($2)
        nop # avoid data hazard with $2
        nop
        nop
        slti    $2,$2,4
        nop # avoid data hazard with $2
        nop
        nop
        beq	$2,$zero,mark # beq, j to simulate bne 
        nop # avoid control hazard
        nop
        nop
        nop
        j	snail
        nop # avoid control hazard
        nop
        nop
        nop
        
mark:
        #li      $2,-1 expand this instruction out so we can install NOPs
        lui $1, 0xFFFF
        nop # avoid data hazard with $1
        nop
        nop
        ori $2, $1, 0xFFFF # $2 = 0xFFFFFFFF, which is -1 in two's complement

cynical:
        move    $sp,$fp
        nop # avoid data hazard with $sp
        nop
        nop
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        nop # avoid data hazard with $sp
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop
        
has_edge:
        addiu   $sp,$sp,-32
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop # avoid data hazard with $fp
        nop
        nop
        sw      $4,32($fp)
        sw      $5,36($fp)
        #la      $2,adjacencymatrix
        lasw    $2,adjacencymatrix  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        lw      $3,32($fp)
        nop # avoid data hazard with $3
        nop
        nop
        sll     $3,$3,2
        nop # avoid data hazard with $3
        nop
        nop
        addu    $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,0($2)
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,16($fp)
        li      $2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       measley
        nop # avoid control hazard
        nop
        nop
        nop

look:
        lw      $2,8($fp)
        nop # avoid data hazard with $2
        nop
        nop
        sll     $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop # avoid data hazard with $s
        nop
        nop
        addiu   $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,12($fp)
        
measley:
        lw      $3,12($fp)
        lw      $2,36($fp)
        nop # avoid data hazard with $2
        nop
        nop
        slt     $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        beq     $2,$0,experience # beq, j to simulate bne 
        nop # avoid control hazard
        nop
        nop
        nop
        j 	look
        nop # avoid control hazard
        nop
        nop
        nop

experience:
        lw      $3,8($fp)
        lw      $2,16($fp)
        nop # avoid data hazard with $2
        nop
        nop
        and     $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        slt     $2,$0,$2
        nop # avoid data hazard with $2
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop # avoid data hazard with $fp
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop
        
mark_visited:
        addiu   $sp,$sp,-32
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop # avoid data hazard with $fp
        nop
        nop
        sw      $4,32($fp)
        li      $2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       recast
        nop # avoid control hazard
        nop
        nop
        nop

example:
        lw      $2,8($fp)
        nop # avoid data hazard with $2
        nop
        nop
        sll     $2,$2,8
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,12($fp)
recast:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        slt     $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        beq	$2,$zero,pat # beq, j to simulate bne
        nop # avoid control hazard
        nop
        nop
        nop
        j	example
        nop # avoid control hazard
        nop
        nop
        nop

pat:
       	#la	$2, visited
       	lasw    $2, visited # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
       	nop # avoid data hazard with $2
        nop
        nop
        sw      $2,16($fp)
        lw      $2,16($fp)
        nop # avoid data hazard with $2
        nop
        nop
        lw      $3,0($2)
        lw      $2,8($fp)
        nop # avoid data hazard with $2 and $3
        nop
        nop
        or      $3,$3,$2
        lw      $2,16($fp)
        nop # avoid data hazard with $3
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop # avoid data hazard with $fp
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop
        
is_visited:
        addiu   $sp,$sp,-32
        nop # avoid data hazard with $sp
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop # avoid data hazard with $fp
        nop
        nop
        sw      $4,32($fp)
        ori     $2,$zero,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       evasive
        nop # avoid control hazard
        nop
        nop
        nop

justify:
        lw      $2,8($fp)
        nop # avoid data hazard with $2
        nop
        nop
        sll     $2,$2,8
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop # avoid data hazard with $2
        nop
        nop
        addiu   $2,$2,1
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,12($fp)
        
evasive:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop # avoid data hazard with $2
        nop
        nop
        slt     $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        beq	$2,$0,representitive # beq, j to simulate bne
        nop # avoid control hazard
        nop
        nop
        nop
        j     	justify
        nop # avoid control hazard
        nop
        nop
        nop
        
representitive:
        #la	$2,visited
        lasw    $2,visited  # MIPs special pseudoinstruction to insert three NOPs between lui and ori for the la expansion
        nop # avoid data hazard with $2
        nop
        nop
        lw      $2,0($2)
        nop # avoid data hazard with $2
        nop
        nop
        sw      $2,16($fp)
        lw      $3,16($fp)
        nop
        lw      $2,8($fp)
        nop # avoid data hazard with $2 and $3
        nop
        nop
        and     $2,$3,$2
        nop # avoid data hazard with $2
        nop
        nop
        slt     $2,$0,$2
        nop # avoid data hazard with $2
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop # avoid data hazard with $fp
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop # avoid control hazard
        nop
        nop
        nop

