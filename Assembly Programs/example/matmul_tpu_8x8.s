; This program runs a 4x4 matmul with the tpu to compare speeds to a 
; mat mul done by hand on a 4x4 matrix in another program

xor $r1, $r1, $r1       ;
xor $r2, $r2, $r2       ;
xor $r10, $r10, $r10    ;
addi $r2, $r2, 3        ; value for A matrix to be stored in mem
addi $r10, $r10, 4      ; value for B matrix to be stored in mem

lui $r3, 4              ; 16384 base mem addr

xor $r4, $r4, $r4       ;
addi $r4, $r4, 64       ; 64 loads to memory for a 8x8

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
; 0-16
lui $r1, 4              ; start addr of A
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
lam $r6, 0, 4
lam $r7, 0, 5
lam $r8, 0, 6
lam $r9, 0, 7
lam $r10, 1, 0
lam $r11, 1, 1
lam $r12, 1, 2
lam $r13, 1, 3
lam $r14, 1, 4
lam $r15, 1, 5
lam $r16, 1, 6
lam $r17, 1, 7

; a Pt 2

lw $r2, $r1, 64          
lw $r3, $r1, 68
lw $r4, $r1, 72
lw $r5, $r1, 76      
lw $r6, $r1, 80      
lw $r7, $r1, 84                 
lw $r8, $r1, 88      
lw $r9, $r1, 92      
lw $r10, $r1, 96      
lw $r11, $r1, 100      
lw $r12, $r1, 104      
lw $r13, $r1, 108      
lw $r14, $r1, 112
lw $r15, $r1, 116      
lw $r16, $r1, 120
lw $r17, $r1, 124

; load values into A matrix 
lam $r2, 2, 0
lam $r3, 2, 1
lam $r4, 2, 2
lam $r5, 2, 3
lam $r6, 2, 4
lam $r7, 2, 5
lam $r8, 2, 6
lam $r9, 2, 7
lam $r10, 3, 0
lam $r11, 3, 1
lam $r12, 3, 2
lam $r13, 3, 3
lam $r14, 3, 4
lam $r15, 3, 5
lam $r16, 3, 6
lam $r17, 3, 7

;A pt 3

lw $r2, $r1, 128          
lw $r3, $r1, 132
lw $r4, $r1, 136
lw $r5, $r1, 140     
lw $r6, $r1, 144     
lw $r7, $r1, 148                 
lw $r8, $r1, 152      
lw $r9, $r1, 156      
lw $r10, $r1, 160      
lw $r11, $r1, 164      
lw $r12, $r1, 168      
lw $r13, $r1, 172      
lw $r14, $r1, 176
lw $r15, $r1, 180      
lw $r16, $r1, 184
lw $r17, $r1, 188

; load values into A matrix 
lam $r2, 4, 0
lam $r3, 4, 1
lam $r4, 4, 2
lam $r5, 4, 3
lam $r6, 4, 4
lam $r7, 4, 5
lam $r8, 4, 6
lam $r9, 4, 7
lam $r10, 5, 0
lam $r11, 5, 1
lam $r12, 5, 2
lam $r13, 5, 3
lam $r14, 5, 4
lam $r15, 5, 5
lam $r16, 5, 6
lam $r17, 5, 7

; A pt 4

lw $r2, $r1, 192          
lw $r3, $r1, 196
lw $r4, $r1, 200
lw $r5, $r1, 204      
lw $r6, $r1, 208      
lw $r7, $r1, 212                 
lw $r8, $r1, 216      
lw $r9, $r1, 220      
lw $r10, $r1, 224      
lw $r11, $r1, 228      
lw $r12, $r1, 232      
lw $r13, $r1, 236      
lw $r14, $r1, 240
lw $r15, $r1, 244      
lw $r16, $r1, 248
lw $r17, $r1, 252

; load values into A matrix 
lam $r2, 6, 0
lam $r3, 6, 1
lam $r4, 6, 2
lam $r5, 6, 3
lam $r6, 6, 4
lam $r7, 6, 5
lam $r8, 6, 6
lam $r9, 6, 7
lam $r10, 7, 0
lam $r11, 7, 1
lam $r12, 7, 2
lam $r13, 7, 3
lam $r14, 7, 4
lam $r15, 7, 5
lam $r16, 7, 6
lam $r17, 7, 7

; now get B values from mem
addi $r1, $r1, 256 ; start addr of B
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
lbm $r6, 0, 4
lbm $r7, 0, 5
lbm $r8, 0, 6
lbm $r9, 0, 7
lbm $r10, 1, 0
lbm $r11, 1, 1
lbm $r12, 1, 2
lbm $r13, 1, 3
lbm $r14, 1, 4
lbm $r15, 1, 5
lbm $r16, 1, 6
lbm $r17, 1, 7

lw $r2, $r1, 64          
lw $r3, $r1, 68
lw $r4, $r1, 72
lw $r5, $r1, 76      
lw $r6, $r1, 80      
lw $r7, $r1, 84                 
lw $r8, $r1, 88      
lw $r9, $r1, 92      
lw $r10, $r1, 96      
lw $r11, $r1, 100      
lw $r12, $r1, 104      
lw $r13, $r1, 108      
lw $r14, $r1, 112
lw $r15, $r1, 116      
lw $r16, $r1, 120
lw $r17, $r1, 124

; load values into B matrix 
lbm $r2, 2, 0
lbm $r3, 2, 1
lbm $r4, 2, 2
lbm $r5, 2, 3
lbm $r6, 2, 4
lbm $r7, 2, 5
lbm $r8, 2, 6
lbm $r9, 2, 7
lbm $r10, 3, 0
lbm $r11, 3, 1
lbm $r12, 3, 2
lbm $r13, 3, 3
lbm $r14, 3, 4
lbm $r15, 3, 5
lbm $r16, 3, 6
lbm $r17, 3, 7

lw $r2, $r1, 128          
lw $r3, $r1, 132
lw $r4, $r1, 136
lw $r5, $r1, 140      
lw $r6, $r1, 144      
lw $r7, $r1, 148                 
lw $r8, $r1, 152      
lw $r9, $r1, 156      
lw $r10, $r1, 160      
lw $r11, $r1, 164      
lw $r12, $r1, 168      
lw $r13, $r1, 172      
lw $r14, $r1, 176
lw $r15, $r1, 180      
lw $r16, $r1, 184
lw $r17, $r1, 188

; load values into B matrix 
lbm $r2, 4, 0
lbm $r3, 4, 1
lbm $r4, 4, 2
lbm $r5, 4, 3
lbm $r6, 4, 4
lbm $r7, 4, 5
lbm $r8, 4, 6
lbm $r9, 4, 7
lbm $r10, 5, 0
lbm $r11, 5, 1
lbm $r12, 5, 2
lbm $r13, 5, 3
lbm $r14, 5, 4
lbm $r15, 5, 5
lbm $r16, 5, 6
lbm $r17, 5, 7

lw $r2, $r1, 192          
lw $r3, $r1, 196
lw $r4, $r1, 200
lw $r5, $r1, 204      
lw $r6, $r1, 208      
lw $r7, $r1, 212                 
lw $r8, $r1, 216      
lw $r9, $r1, 220      
lw $r10, $r1, 224      
lw $r11, $r1, 228      
lw $r12, $r1, 232      
lw $r13, $r1, 236     
lw $r14, $r1, 240
lw $r15, $r1, 244     
lw $r16, $r1, 248
lw $r17, $r1, 252

; load values into B matrix 
lbm $r2, 6, 0
lbm $r3, 6, 1
lbm $r4, 6, 2
lbm $r5, 6, 3
lbm $r6, 6, 4
lbm $r7, 6, 5
lbm $r8, 6, 6
lbm $r9, 6, 7
lbm $r10, 7, 0
lbm $r11, 7, 1
lbm $r12, 7, 2
lbm $r13, 7, 3
lbm $r14, 7, 4
lbm $r15, 7, 5
lbm $r16, 7, 6
lbm $r17, 7, 7

; kick off the matmul!
matmul

; read vals back to mem
; first get values from matrix C

lui $r20, 8                 ; start addr for C

racc $r1, 0, 0
racc $r2, 0, 1
racc $r3, 0, 2
racc $r4, 0, 3
racc $r5, 0, 4
racc $r6, 0, 5
racc $r7, 0, 6
racc $r8, 0, 7
racc $r9, 1, 0
racc $r10, 1, 1
racc $r11, 1, 2
racc $r12, 1, 3
racc $r13, 1, 4
racc $r14, 1, 5
racc $r15, 1, 6
racc $r16, 1, 7

; now can write C values to memory

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

;pt 2

racc $r1, 2, 0
racc $r2, 2, 1
racc $r3, 2, 2
racc $r4, 2, 3
racc $r5, 2, 4
racc $r6, 2, 5
racc $r7, 2, 6
racc $r8, 2, 7
racc $r9, 3, 0
racc $r10, 3, 1
racc $r11, 3, 2
racc $r12, 3, 3
racc $r13, 3, 4
racc $r14, 3, 5
racc $r15, 3, 6
racc $r16, 3, 7

; now can write C values to memory

sw $r20, $r1, 64          
sw $r20, $r2, 68
sw $r20, $r3, 72
sw $r20, $r4, 76      
sw $r20, $r5, 80      
sw $r20, $r6, 84                 
sw $r20, $r7, 88      
sw $r20, $r8, 92      
sw $r20, $r9, 96      
sw $r20, $r10, 100      
sw $r20, $r11, 104      
sw $r20, $r12, 108     
sw $r20, $r13, 112
sw $r20, $r14, 116     
sw $r20, $r15, 120
sw $r20, $r16, 124

;pt 3

racc $r1, 4, 0
racc $r2, 4, 1
racc $r3, 4, 2
racc $r4, 4, 3
racc $r5, 4, 4
racc $r6, 4, 5
racc $r7, 4, 6
racc $r8, 4, 7
racc $r9, 5, 0
racc $r10, 5, 1
racc $r11, 5, 2
racc $r12, 5, 3
racc $r13, 5, 4
racc $r14, 5, 5
racc $r15, 5, 6
racc $r16, 5, 7

; now can write C values to memory

sw $r20, $r1, 128          
sw $r20, $r2, 132
sw $r20, $r3, 136
sw $r20, $r4, 140     
sw $r20, $r5, 144     
sw $r20, $r6, 148                
sw $r20, $r7, 152     
sw $r20, $r8, 156     
sw $r20, $r9, 160     
sw $r20, $r10, 164      
sw $r20, $r11, 168     
sw $r20, $r12, 172     
sw $r20, $r13, 176
sw $r20, $r14, 180     
sw $r20, $r15, 184
sw $r20, $r16, 188

;pt 4

racc $r1, 6, 0
racc $r2, 6, 1
racc $r3, 6, 2
racc $r4, 6, 3
racc $r5, 6, 4
racc $r6, 6, 5
racc $r7, 6, 6
racc $r8, 6, 7
racc $r9, 7, 0
racc $r10, 7, 1
racc $r11, 7, 2
racc $r12, 7, 3
racc $r13, 7, 4
racc $r14, 7, 5
racc $r15, 7, 6
racc $r16, 7, 7

; now can write C values to memory

sw $r20, $r1, 192          
sw $r20, $r2, 196
sw $r20, $r3, 200
sw $r20, $r4, 204     
sw $r20, $r5, 208     
sw $r20, $r6, 212                
sw $r20, $r7, 216     
sw $r20, $r8, 220     
sw $r20, $r9, 224     
sw $r20, $r10, 228      
sw $r20, $r11, 232     
sw $r20, $r12, 236     
sw $r20, $r13, 240
sw $r20, $r14, 244     
sw $r20, $r15, 248
sw $r20, $r16, 252
; Done! Results should be 96
nop
nop
nop
nop
nop
