main:
    addi t1, zero, 0x8      # load t1 with 8
    addi a0, zero, 0x0      # a0 used for output
mloop:
    addi a1, zero, 0x0      # a1 is counter, init to 0
iloop:
    addi a0, a1, 0          # load a0 with a1
    addi a1, a1, 1          # increment a1
    bne at, t1, iloop       # if a1 !=9, branch to i loop
    bne t1, zero, mloop     # else always branch to mloop
