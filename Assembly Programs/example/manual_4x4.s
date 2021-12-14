; Uses same setup as TUP 4x4 matmul program


xor $r1, $r1, $r1       ;                                               
xor $r2, $r2, $r2       ;
xor $r10, $r10, $r10    ;
addi $r2, $r2, 3        ; value for A matrix to be stored in mem
addi $r10, $r10, 4      ; value for B matrix to be stored in mem

lui $r3, 4              ; 16384 base mem addr

xor $r4, $r4, $r4       ;
addi $r4, $r4, 16       ;16 loads to memory for a 4x4

; store vals to memory for A matrix
sw $r3,  $r2, 0         ; store 3 to mem 
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, -12       ; while i < 16

; store B matrix vals to memory
xor $r1, $r1, $r1       ;
sw $r3, $r10, 0         ; store 4 to mem
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, -12       ; while i < 16

; A row intermediate for c
xor $r9, $r9, $r9

; b col intermediate for c
xor $r10, $r10, $r10


; start of A
xor $r11, $r11, $r11
lui $r11, 4

; start of B
xor $r12, $r12, $r12
addi $r12, $r11, 64

; size of element (mult by row num)
xor $r13, $r13, $r13
addi $r13, $r13, 4

; size of row (mult by col num)
xor $r14, $r14, $r14
addi $r14, $r14, 16

; outer var
xor $r15, $r15, $r15

; mid var
xor $r16, $r16, $r16

; inner var
xor $r17, $r17, $r17

; loop limit
xor $r18, $r18, $r18
addi $r18, $r18, 4

; matA address
xor $r19, $r19, $r19

; matB address
xor $r20, $r20, $r20

; mat A row value
xor $r21, $r21, $r21

; mat B row value
xor $r22, $r22, $r22

; product
xor $r23, $r23, $r23

; total 
xor $r24, $r24, $r24

; mat A col Value
xor $r25, $r25, $r25

; mat B col value
xor $r26, $r26, $r26

; element from A
xor $r27, $r27, $r27

; element from B
xor $r28, $r28, $r28

; C addr
xor $r29, $r29, $r29

; start of c
xor $r30, $r30, $r30
lui $r30 , 8            ; addr 32768
OUTER_LOOP:
;outer loop
bgt $r15, $r18, OUTER_LOOP_END
beq $r15, $r18, OUTER_LOOP_END

; midd loop
xor $r16, $r16, $r16    ; clear middle loop var
MIDDLE_LOOP:
bgt $r16, $r18, MIDDLE_LOOP_END
beq $r16, $r18, MIDDLE_LOOP_END

;inner loop
xor $r17, $r17, $r17 ; clear inner loop var
INNER_LOOP:   
bgt $r17, $r18, INNER_LOOP_END
beq $r17, $r18, INNER_LOOP_END

; in inner loop
; get address for matrix A component
; outer loop var * row, inner loop var * col
; A row
mul $r21, $r15, $r13
; A col
mul $r25, $r17, $r14

; add all offsets
xor $r19, $r19, $r19
add $r19, $r21, $r25
add $r19, $r19, $r11

lw $r27, $r19, 0

; B row
mul $r22, $r17, $r13

; B col
mul $r26, $r16, $r14

; add all offsets
xor $r20, $r20, $r20
add $r20, $r22, $r26
add $r20, $r20, $r12

lw $r28, $r20, 0

; multiply value from A and B
mul $r23, $r27, $r28

; add it to current total
add $r24, $r24, $r23            ; value to be stored in C

; end of inner loop
addi $r17, $r17, 1
jmp INNER_LOOP

INNER_LOOP_END:

; store total in C
; use A row and B col to index into C
xor $r9, $r9, $r9
xor $r10, $r10, $r10

mul $r9, $r21, $r13
mul $r10, $r26, $r14


xor $r29, $r29, $r29
add $r29, $r9, $r10            ;
add $r29, $r29, $r30            ; 
sw $r29, $r24, 0                ; M[r29 + 0] = r24

; end of mid loop
addi $r16, $r16, 1
jmp MIDDLE_LOOP

MIDDLE_LOOP_END:

; end of outer loop
addi $r15, $r15, 1
jmp  OUTER_LOOP

OUTER_LOOP_END:
nop
nop
nop
nop
nop












