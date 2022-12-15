.text
#memory needs to be mapped correctly
main:
    jal     ra, init           # execute init subroutine
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
loop:
    jal     ra, reset          # execute reset subroutine
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
    jal     ra, shift          # execute shift subroutine
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
    j       loop               # loop forever
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
init:
    addi    t1, zero, 0xFF     # load t1 with 255
    ret
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
reset:
    addi    a0, zero, 0x0      # a0 used for output
    addi    a1, zero, 0x1      # set a1 to 1
    ret
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
shift:
    addi    a0, a1, 0          # load a0 with a1 
    slli    a1, a1, 1          # shift a1 left by 1 bit
    addi    a1, a1, 1          # increment a1 by 1
    bne     a1, t1, shift      # if a1 !=255, branch to shift
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
    addi    a0, a1, 0          # load a0 with a1 
    ret   
    addi    zero, zero, 0x0    # control hazard
    addi    zero, zero, 0x0    # control hazard
