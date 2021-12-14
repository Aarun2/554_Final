jmp P1  ;0              (So this one works because PC is 0, it jumps to 16) 
nop     ;4
nop     ;8
nop     ;12
P1:     ;               TARGET 1 
jmp P3  ;16             (However this one jumps to 16 + 48 = 64 instead of 48)
nop     ;20
nop     ;24
nop     ;28
P2:     ;               TARGET 3 
jmp END ;32             
nop     ;36
nop     ;40
nop     ;44
P3:     ;               TARGET 2
jmp P2  ;48
nop     ;52
nop     ;56
nop     ;60
END:    ;               TARGET 4
nop     ;64
