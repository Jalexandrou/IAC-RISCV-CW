.text
#memory needs to be mapped correctly
main:
    jal     ra, init           # execute init subroutine
loop:
    NOP                        # control hazard
    NOP                        # control hazard
    jal     ra, reset          # execute reset subroutine
    NOP                        # control hazard
    NOP                        # control hazard
    jal     ra, shift          # execute shift subroutine
    NOP                        # control hazard
    NOP                        # control hazard
    j       loop               # loop forever
init:
    addi    t1, zero, 0xFF     # load t1 with 255
    NOP                        # control hazard
    NOP                        # control hazard
    ret
reset:
    addi    a0, zero, 0x0      # a0 used for output
    addi    a1, zero, 0x1      # set a1 to 1
    NOP                        # control hazard
    NOP                        # control hazard
    ret
shift:
    addi    a0, a1, 0          # load a0 with a1 
    NOP                        # control hazard
    NOP                        # control hazard
    slli    a1, a1, 1          # shift a1 left by 1 bit
    NOP                        # control hazard
    NOP                        # control hazard
    addi    a1, a1, 1          # increment a1 by 1
    NOP                        # control hazard
    NOP                        # control hazard
    bne     a1, t1, shift      # if a1 !=255, branch to shift
    addi    a0, a1, 0          # load a0 with a1
    NOP                        # control hazard
    NOP                        # control hazard
    ret   
