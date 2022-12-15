.text
.globl main
main:
    addi    t1, zero, 0xff      # load t1 with 255
    NOP
    NOP
    addi    a0, zero, 0x0       # a0 is used for output
    NOP
    NOP
mloop:    
    NOP
    NOP
    addi    a1, zero, 0x0       # a1 is the counter, init to 0
    NOP
    NOP
iloop:
    addi    a0, a1, 0           # load a0 with a1
    NOP
    NOP
    addi    a1, a1, 1           # increment a1
    NOP
    NOP
    bne     a1, t1, iloop       # if a1 != 255, branch to iloop
    NOP
    NOP
    addi    a0, a1, 0           # load a0 with a1
    NOP
    NOP
    bne     t1, zero, mloop     #  ... else always brand to mloop
