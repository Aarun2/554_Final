nop
;load registers
lui $r1, 1
srli $r1, $r1, 12
lui $r2, 3
srli $r2, $r2, 12
lui $r3, 7
srli $r3, $r3, 12
lui $r4, 15
srli $r4, $r4, 12
lui $r5, 31
srli $r5, $r5, 12
lui $r6, 63
srli $r6, $r6, 12
lui $r7, 127
srli $r7, $r7, 12
lui $r8, 255
srli $r8, $r8, 12
lui $r9, 1023
srli $r9, $r9, 12
lui $r10, 4095
srli $r10, $r10, 12
lui $r11, 16383
srli $r11, $r11, 12



;test basic arith instructions
add $r12, $r5, $r6
sub $r13, $r6, $r7
xor $r14, $r3, $r8
or $r15, $r4, $r9
and $r16, $r5, $r8
sll $r17, $r9, $r4
srl $r18, $r7, $r3
sra $r19, $r11, $r4
slt $r20, $r1, $r2
mul $r21, $r5, $r6

;test immediates
addi $r22, $r5, 32
xori $r23, $r6, 32
ori $r24, $r7, 32
andi $r25, $r9, 32
slli $r26, $r6, 16
srli $r27, $r9, 16
srai $r28, $r8, 16
slti $r29, $r6, 31
lui $r30, 255


;memory ops
lw $r31, $r3, 16
sw $r10, $r3, 8

;branch and jump eqs
beq $r1, $r1, 3
add $r12, $r1, $r1
bne $r1, $r2, 3
add $r13, $r1, $r1
blt $r1, $r2, 3
add $r14, $r1, $r1
bgt $r2, $r1, 3
add $r15, $r1, $r1
addi $r31, $zero, 12 
jmp 12
add $r16, $r1, $r1
add $r17, $r2, $r2
jr $r31
add $r18, $r3, $r3
add $r19, $r4, $r4
;matmul instructions
; simple 3x3 matmul
lam $r2, 0, 0
lam $r2, 0, 1
lam $r2, 0, 2
lam $r2, 1, 0
lam $r2, 1, 1
lam $r2, 1, 2
lam $r2, 2, 0
lam $r2, 2, 1
lam $r2, 2, 2
lbm $r3, 0, 0
lbm $r3, 0, 1
lbm $r3, 0, 2
lbm $r3, 1, 0
lbm $r3, 1, 1
lbm $r3, 1, 2
lbm $r3, 2, 0
lbm $r3, 2, 1
lbm $r3, 2, 2
andi $r12, $r12, 0
lacc $r12, 0, 0
lacc $r12, 0, 1
lacc $r12, 0, 2
lacc $r12, 1, 0
lacc $r12, 1, 1
lacc $r12, 1, 2
lacc $r12, 2, 0
lacc $r12, 2, 1
lacc $r12, 2, 2
matmul
racc $r13, 0, 0
racc $r14, 0, 1
racc $r15, 0, 2
racc $r16, 1, 0
racc $r17, 1, 1
racc $r18, 1, 2
racc $r19, 2, 0
racc $r20, 2, 1
racc $r21, 2, 2
nop
