## Personal Statement
___
**_Derin Ak_**
___
## Overview
* [PC Register](#PC-Register)
* [PC Next](#PC-Next)
* [Pipelining](#Pipelining)
    - [PC Next](#PC-Next)
    - [Control Unit](#Control-Unit)
    - [CPU](#CPU)
    - [f1](#f1)

___
### PC Register
___

[Link to module](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/PC_Register.sv)

I made the original version of the PC register for Lab 4 and we did not need to change that for the final version. It is simply just a register that outputs the PC.

___
### PC Next
___
[Link to module](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/PC_Next.sv)

I made the original version of the PC next file which did not include the jump and link instructions. It selected either PC+4 or immext depending on the PCsrc signal. 
___
### Pipelining
___

#### CPU

[Link to module](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/pipelining/CPU/cpu.sv)

I added registers between the fetch, decode, execute, memory, and writeback stages and created necessary interconnecting wires. Keeping the pipelining registers in the CPU file made it easier for me to see how the wires were connected and followed stages.  I connected them as shown in the diagram (although some of the control unit signals are different from the diagram). 

I removed PCsrc from Control unit because it depends on the Zero signal which happens in the execute stage whereas the control unit is in the decode stage.

    assign PCsrcE= branchE & !ZeroE | JlinkE;

Relevant Commit: [Added CPU for the pipelined version](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/2f3222e1021bb1d561a8fb759e1df01def2328f8)
___

#### PC Next

[Link to module](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/pipelining/CPU/PC_Next.sv)

I changed the PC next file for pipelining because PC+4 was determined in the fetch stage whereas PC+imm was determined in the execute stage. Although they are in different stages I kept them in the same file so that it would be easier to follow. I added a second PC input in the PC next file which is connected to the PC signal in execute stage. 

Relevant Commit: [Added PC Next for pipelined version](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/bb5cf03f070a0b56bed9991aaabd8ca1abcdb3b5)
___
#### Control Hazards
[Link to module]()

In order to prevent pipeline hazards, I added nop instruction (addi zero, zero, 0) in the f1 program. 

Relevant Commit: [Added Control Hazards](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/63de4b4d7d5f6b7ee30f89661105dfa00921bb3d)
