; This program runs a 4x4 matmul with the tpu to compare speeds to a 
; mat mul done by hand on a 4x4 matrix in another program

xor $r1, $r1, $r1       ;
xor $r2, $r2, $r2       ;
xor $r10, $r10, $r10    ;
addi $r2, $r2, 3        ; value for A matrix to be stored in mem
addi $r10, $r10, 4      ; value for B matrix to be stored in mem

lui $r3, 4              ; 16384 base mem addr

xor $r4, $r4, $r4       ;
addi $r4, $r4, 16       ;16 loads to memory for a 4x4

; store vals to memory for A matrix
STORE_A:
sw $r3,  $r2, 0         ; store 3 to mem 
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, STORE_A   ; while i < 16 // OLD OFFSET -12

; store B matrix vals to memory
xor $r1, $r1, $r1       ; clear i
STORE_B:
sw $r3, $r10, 0         ; store 4 to mem
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, STORE_B   ; while i < 16 // OLD OFFSET -12


; read vals from memory and load into matrix c!
; load A values from mem
lui $r1, 4              ; 16384 start addr of A
lw $r2, $r1, 0          
lw $r3, $r1, 4
lw $r4, $r1, 8
lw $r5, $r1, 12      
lw $r6, $r1, 16      
lw $r7, $r1, 20                 
lw $r8, $r1, 24      
lw $r9, $r1, 28      
lw $r10, $r1, 32      
lw $r11, $r1, 36      
lw $r12, $r1, 40      
lw $r13, $r1, 44      
lw $r14, $r1, 48
lw $r15, $r1, 52      
lw $r16, $r1, 56
lw $r17, $r1, 60

; load values into A matrix 
lam $r2, 0, 0
lam $r3, 0, 1
lam $r4, 0, 2
lam $r5, 0, 3
lam $r6, 1, 0
lam $r7, 1, 1
lam $r8, 1, 2
lam $r9, 1, 3
lam $r10, 2, 0
lam $r11, 2, 1
lam $r12, 2, 2
lam $r13, 2, 3
lam $r14, 3, 0
lam $r15, 3, 1
lam $r16, 3, 2
lam $r17, 3, 3

; now get B values from mem
addi $r1, $r1, 64 ; start addr of B
lw $r2, $r1, 0          
lw $r3, $r1, 4
lw $r4, $r1, 8
lw $r5, $r1, 12      
lw $r6, $r1, 16      
lw $r7, $r1, 20                 
lw $r8, $r1, 24      
lw $r9, $r1, 28      
lw $r10, $r1, 32      
lw $r11, $r1, 36      
lw $r12, $r1, 40      
lw $r13, $r1, 44      
lw $r14, $r1, 48
lw $r15, $r1, 52      
lw $r16, $r1, 56
lw $r17, $r1, 60

; load values into B matrix 
lbm $r2, 0, 0
lbm $r3, 0, 1
lbm $r4, 0, 2
lbm $r5, 0, 3
lbm $r6, 1, 0
lbm $r7, 1, 1
lbm $r8, 1, 2
lbm $r9, 1, 3
lbm $r10, 2, 0
lbm $r11, 2, 1
lbm $r12, 2, 2
lbm $r13, 2, 3
lbm $r14, 3, 0
lbm $r15, 3, 1
lbm $r16, 3, 2
lbm $r17, 3, 3

; kick off the matmul!
matmul

; read vals back to mem
; first get values from matrix C
racc $r1, 0, 0
racc $r2, 0, 1
racc $r3, 0, 2
racc $r4, 0, 3
racc $r5, 1, 0
racc $r6, 1, 1
racc $r7, 1, 2
racc $r8, 1, 3
racc $r9, 2, 0
racc $r10, 2, 1
racc $r11, 2, 2
racc $r12, 2, 3
racc $r13, 3, 0
racc $r14, 3, 1
racc $r15, 3, 2
racc $r16, 3, 3

; now can write C values to memory
lui $r20, 8                 ; start addr for C (Dec 32768)
sw $r20, $r1, 0          
sw $r20, $r2, 4
sw $r20, $r3, 8
sw $r20, $r4, 12      
sw $r20, $r5, 16      
sw $r20, $r6, 20                 
sw $r20, $r7, 24      
sw $r20, $r8, 28      
sw $r20, $r9, 32      
sw $r20, $r10, 36      
sw $r20, $r11, 40      
sw $r20, $r12, 44      
sw $r20, $r13, 48
sw $r20, $r14, 52      
sw $r20, $r15, 56
sw $r20, $r16, 60

; Done!
nop

