; Core Instructions
; -
; This test tests each arithmetic (i.e. all except loads, stores, branches or jumps)
; instruction in the MACRO CRU core instruction set

; nop instr
nop

; R Format (add, sub, xor, or, and, sll, srl, sra, slt, mul)
; first get some vals in regs though
addi $zero, $zero, 1 ; $zero = 1
addi $r1, $r1, 2 ; $r1 = 2
add $r2, $zero, $r1 ; $r2 = $zero + $r1 (3)
sub $r3, $r2, $r1 ; $r2 = $r2 - $r1 (1)
xor $r4, $r3, $r3 ; $r4 = $r3 ^ $r3 (0)
or  $r5, $r4, $r1 ; $r5 = $r4 | $r1 (2)
and $r6, $r5, $r5 ; $r6 = $r5 & $r5 (2)
sll $r7, $zero, $r2 ; $r7 = $zero << $r2 (8)
srl $r8, $r7, $r3 ; $r8 = $r7 << $r3 (4)
sra $r9, $r6, $r5 ; $r9 = $r6 >> $r5 (0)
slt $r10, $zero, $r1 ; $r10 = ($zero < $r1) ? 1 : 0 (1)
mul $r11, $r2, $r5 ; $r11 = $r2 * $r5 (6)

; I Format(similar to R Format Ops but now have lui)
addi $r12, $r1, 10 ; $r12 = 12
xori $r13, $r12, 8 ; $r13 = 4
ori  $r14, $r13, 2 ; $r14 = 6
andi $r15, $r13, 4 ; $r15 = 2
slli $r16, $r15, 3 ; $r16 = 16
srli $r17, $r16, 0 ; $r17 = 16
srai $r18, $r17, 1 ; $r18 = 8
slti $r19, $r18, 10 ; $r19 = 1
lui $r20, 1 ; $r20 = 1 << 12 (2048)

; Stores
sw $r20, $r1, 2 ; M[$r20 + 2] = $r1

; Loads
lw $zero, $r20, 2; $zero = M[$r20 + 2]

beq $zero, $zero, SKIP_1
ori $r21, $zero, -1 ; error condition

SKIP_1:
bne $zero, $r1, SKIP_2
ori $r22, $zero, -1

TMP:
jr $zero
ori $r24, $zero, -1

SKIP_2:
jmp SKIP_3
ori $r23, $zero, -1

SKIP_3:
jmp TMP
slli $zero, $zero, 0 ; No-op
nop 
nop
nop
jmp 4

blt $zero, $r1, COOL

NICE:
lam $r25, 0, 0
lbm $r26 0, 0
lacc $r27, 0, 0
racc $r28, 0, 0
matmul

COOL:
bgt $r1, $zero, NICE


