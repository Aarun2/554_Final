; This test is for running a 4x4 matrix multiply by hand to compare to 
; running a 4x4 matmul on our processor with the tpu in the pipeline

xor $r1, $r1, $r1;
xor $r2, $r2, $r2;
addi $r2, $r2, 3; // value to be stored in mem
lui $r3, 16384; // base mem addr

xor $r4, $r4, $r4;
addi $r4, $r4, 16; // 16 loads to memory for a 4x4

; store vals to memory
sw $r3,  $r2, 0; // store 3 to mem 
addi $r3, $r3, 4; // inc mem offset by 4
addi $r1, $r1, 1;  // i++
blt $r1, $r4, -12; // while i < 16

; read vals from memory, perform matrix multiply by hand
xor $r1, $r1, $r1; // row
xor $r2, $r2, $r2; // col 
xor $r4, $r4, $r4 
lui $r3, 16384; // base mem addr
addi $r4, $r4, 4 // row/col length

    xor $r2, $r2, $r2; // reset col inner loop
    lw $r5, $r3, 0
    lam $r5, $r1, $r2 ; load a matrix (same vals for now)
    lbm $r5, $r1, $r2 ; load b matrix
    addi $r3, $r3, 4; // inc mem by 4 
    addi $r2, $r2, 1 ; // col++
    blt $r2, $r4, -24 ; // end col loop
    addi $r1, $r1, 1; // row ++
    blt $r1, $r4, -32 ; // end row loop

; kick off the matmul!
matmul

; read out the vals at end? 

nop


