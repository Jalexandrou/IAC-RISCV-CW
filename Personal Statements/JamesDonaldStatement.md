<center>

## RISC-V RV32I Processor Coursework

## **_James Donald Statement_**

</center>
<br>

Due to there being two Jacobs in my group, I will be referring to my team as *Jake* (Jacob Alexandrou), *Derin* (Derin Ak) and *Jacob* (Jacob Peake)

___
## Testbench
___

I wrote the original Testbench for [Lab 4](https://github.com/Jalexandrou/IAC-labs) ([Commit](https://github.com/Jalexandrou/IAC-labs/commit/4176d9654d16378a0b752d1bcb33a8334685a910)). This had to be changed very little for most of the Group Project, I mainly just added the use of `vbdCycle()` so I could reset and interrupt the program at set points in the runtime.
___
## F1 Light Sequence Testing
___
I wrote the program, testbench and did the testing for the `F1 Light Sequence` program both for the regular and the pipelined CPU. These are held on different branches since the addition of the `trg` pin to the whole CPU and inside `PC_Register`, while it would not affect the running of the regular CPU, since the target of the interrupt instruction would change for either program I decided it was best to keep them on other branches.

> [Simple F1 Branch](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/tree/f1)
<br>
> [Pipelined F1 Branch](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/tree/f1pipelined)

### Interrupt Implementation
[`Modified PC_Register.sv`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/f1/CPU/PC_Register.sv) | [`Modified CPU.sv`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/f1/CPU/cpu.sv)
<br>
I did originally toy with the idea of a set interrupt location that I could implement into the main CPU and the sequence of instructions would be able to be changed in the program. In the initialisation function of the program register `s8` would be set to the location of the `interrupt` subroutine. However, I had difficulties with this as by modifying the value in `PC_Register` I would not be able to save the current value of the `PC` in the `ra` register without adding extra registers and cycles that would possibly tamper with the instruction running when the interrupt was called.
<br>
<br>
So I instead decided to simply implement it as a trigger function. I added the `trg` pin to the CPU and it feeds into `PC_Register` in much the similar way as `rst` does. If `trg` is high when `posedge clk` hits, the `PC_o` is set to the location of the start of the `shift` subroutine. I determined this location by making the program immediately branch to the `shift` subroutine while making sure not to change the number of instructions before it so I could then read the correct location of the `instr` from the `PC_Register` in the Waveform.

These implementation commits can be viewed here: [Simple F1](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/3395efbe585abdff81f453d74bfc59ca96e8211e) | [Pipelined F1](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/3111d0b856f9cef51eeba316780b74a41157cbb3). The two are different since the `shift` program starts at different locations due to the inclusion of `NOP`s.

*Jake* wrote the original program for the F1 Sequence, and *Derin* added the `control hazards` during the **pipelining** stretch goal, but I modified them to loop infinitely and await the `trg` signal when implemented.

[Simple F1 Program](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/f1/src/myprog/f1.s)

[Pipelined F1 Program](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/f1pipelined/src/myprog/f1.s)

___
## Control Unit
___
[`ControlUnit.sv`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/ControlUnit.sv) | [`ControlUnitDecoder.sv`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/ControlUnitDecoder.sv) | [`ALUDecoder.sv`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/ALUDecoder.sv)
<br>
Originally in [Lab 4](https://github.com/Jalexandrou/IAC-labs), we only implemented a few instructions for the CPU, so the `ControlUnit` simply took in the `opcode`, and if it matched, sent out the correct control signals, so I rewrote most of the `ControlUnit` for this project.<br>
I split the `ControlUnit` up into two parts, `ControlUnitDecoder` and `ALUDecoder`, with a single input, `instr_i`. The internal signals `opcode`, `func3` and `func7` were then assigned from this via selecting the right bits.
```SystemVerilog
    assign opcode = instr_i[6:0];
    assign func3 = instr_i[14:12];
    assign func7 = instr_i[31:25];
```
These values were then fed into the `ALUDecoder` and `ControlUnitDecoder`, which would then determine the control signals for the `ALU` and `ControlUnit` respectively.
<br>
I added a `case` and blank values for all of the signals coming out of the `ControlUnitDecoder`, as well as filling in some values for `MemWrite` and `RegWrite`, but *Jake* filled in the rest of the control signals later on while I was ill.
<br>
During the **pipelining** stretch goal, *Derin* and *Jake* added more control signals to the `ControlUnit`, since we need extra signals to allow for `JAL` and `RET` instructions.

### Relevant Commits
- [`Signals setup for ControlUnitDecoder`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/387bc82c953609c20c0e9a0940cab78ac2da5c84)
- [`Signals Setup for ALUDecoder`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/1415a19a4438c05eb392f7a6109389f20a5f82a6)
- [`Implementation of PCSrc_o`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/e3244bca392fc278ef747d4f6bcb6d3455c08e15)
- [`ALUDecoder Logic`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/e94e8f9b559716640a8a046daa0b3164f578eddc)
- [`ControlUnitDecoder enum and case`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/aca65de865044a731ad40af3da8bf099e68b9d6c)
- [`Template Logic for ControlUnitDecoder`](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/commit/0178f2087646141bf34dad3882d80be118723c45)