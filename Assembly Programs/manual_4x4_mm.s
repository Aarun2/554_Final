; This program perfoms and manual 4x4 matrix multiply without the use of the TPU
; Uses same memory setup as TPU 4x4 matmul program

xor $r1, $r1, $r1       ;                                               
xor $r2, $r2, $r2       ;
xor $r5, $r5, $r5       ;
addi $r2, $r2, 3        ; value for A matrix to be stored in mem
addi $r5, $r5, 4        ; value for B matrix to be stored in mem

lui $r3, 4              ; 16384 base mem addr

xor $r4, $r4, $r4       ;
addi $r4, $r4, 16       ;16 loads to memory for a 4x4

; store vals to memory for A matrix in row major order
sw $r3,  $r2, 0         ; store 3 to mem 
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, -12       ; while i < 16

; store B matrix vals to memory 
; assume B values are stored in COLUMN major order for simpicity in offset math

;save B start addr
xor $r6, $r6, $r6
add $r6, $r6, $r3

xor $r1, $r1, $r1       ;
sw $r3, $r10, 0         ; store 4 to mem
addi $r3, $r3, 4        ; inc mem offset by 4
addi $r1, $r1, 1        ; i++
blt $r1, $r4, -12       ; while i < 16

; at this point...
; $r3 = A addr
; $r6 = B addr
; $r7 = C[i][j], $r7 will be our running sum of multiplication of A[i][j] * B[i][j]
; $r8 will hold A[i][j], r9 will hold B[i][j]
; $r10 will hold our temp multiplication of an A and B cell
; $r11 will hold our offset for storing C into memory
; $r13 = A mem offset
; $r14 = B mem offset
; $r15 = partialSum ctr
; $r21 will be the loop bound for total cell traversal (16)
; $r22 will be our loop counter for rows in matrix A
; $r23 will be out loop counter for cols in matrix B 
; $r24 will be out loop bound for rows in A and cols in B (4)

xor $r13, $r13, $r13
xor $r14, $r14, $r14
xor $r15, $r15, $r15
xor $r21, $r21, $r21
xor $r22, $r22, $r22
xor $r23, $r23, $r23
xor $r24, $r24, $r24

addi $r21, $r21, 16     ; loop bound for cells
addi $r24, $r24, 4      ; loop bound for row/col
lui $r11, 8             ; C start addr 

;Think of the process for each C cell as for each row in A, calculate cell iterating over column in B

NEXT_ROW:

xor $r7, $r7, $r7       ; clear running sum of multiplications
xor $r23, $r23, $r23    ; clear column ctr
xor $r3, $r3, $r3       ; set new starting addr of a
addi $r3, $r13, 0       ; A addr for next row
xor  $r14, $r14, $r14,  ; reset B starting addr to original B starting addr
addi $r14, $r6, 0       ; B addr for first column 

NEXT_COL_IN_ROW:
    
    xor $r13, $r13, $r13
    add $r13, $r13, $r3               ; THIS RESETS A OFFSET!!

CALC_CELL:
        
        lw $r8, $r3, 0              ; load A rd = M[rs1+Imm]
        lw $r9, $r6, 0              ; load B
        mul $r10 , $r8, $r9         ; perform A[i][j] * B[i][j]
        add $r7, $r7, $r10          ; add to cumulative sum
        addi $r13, $r13, 4          ; inc A offset
        addi $r14, $r14, 4          ; inc B offset
        addi $r15, $r15, 1          ; partial sum ctr++
        blt $r15, $r24, CALC_CELL   ; go to next cell for partial sum

    ; done with partial sum, STORE C VALUE TO MEM (IN ROW MAJOR ORDER), move to next row and ONLY reset A mem offset
    sw $r11, $r7, 0             ; M[rs1 + Imm] = rs2
    addi $r11, $r11, 4          ; inc C addr by 4
    addi $r23, $r23, 1          ; inc column ctr
    blt $r23, $r24, NEXT_COL_IN_ROW    ; iterating over columns in a row, so just reset A mem offset, continue inc B offset 

; now we have compute all C vals for a given row, so move to next row and repeat column iterationon		
addi $r22, $r22, 1
blt $r22, $r24, NEXT_ROW

; DONE!
nop
nop
nop
nop
nop

    





