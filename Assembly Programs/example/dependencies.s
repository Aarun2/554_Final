; This program is to showcase our processor can handle data hazards
; 

xor $r1, $r1, $r1
xor $r2, $r2, $r2
xor $r3, $r3, $r3
xor $r4, $r4, $r4
xor $r5, $r5, $r5
xor $r6, $r6, $r6
xor $r7, $r7, $r7

; showcase dependencies
or $r1, $r2, $r2        ;
or $r2, $r3, $r1
nop
nop
nop
nop
or $r1, $r2, $r2
or $r2, $r1, $r3
nop
nop
nop
nop
or $r1, $r2, $r2
nop
or $r2, $r3, $r1
nop
nop
nop
nop
or $r1, $r2, $r2
nop
or $r2, $r1, $r3
nop
nop
nop
nop
or $r1, $r2, $r2
nop
nop
or $r2, $r3, $r1
nop
nop
nop
nop
or $r1, $r2, $r2
nop
nop
or $r2, $r1, $r3
nop
nop
nop
nop

