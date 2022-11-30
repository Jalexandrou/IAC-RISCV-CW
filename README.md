# iac-riscv-cw-1

## Table for Control Unit Signals

| Opcode | Branch_o | ResultSrc_o | MemWrite_o | ALUSrc_o | ImmSrc_o | RegWrite_o |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | x | x | x | x | x | x |
| Load Mem | x | x | x | x | x | x |
| I-Type | x | x | x | x | x | x |
| Store Mem | x | x | x | x | x | x |
| Branch | x | x | x | x | x | x |
| rd = uppimm + PC | x | x | x | x | x | x |
| rd = uppimm | x | x | x | x | x | x |
| Jump and Link Reg | x | x | x | x | x | x |
| Jump and Link | x | x | x | x | x | x |
| default? | x | x | x | x | x | x |

| Signal | 0 | 1 |
| --- | --- | --- |
| Branch_o | Adds with 0 so PCSrc == 1? PCNext increments by SignExtend | PCNext increments by 4 |
| ResultSrc_o | Register saves data from ALUResult | Register saves data from Memory->ReadData |
| MemWrite_o | Memory does not write | Memory saves WD in A |
| ALUSrc_o | ALU->SrcB reads from Reg->RD2 | ALU->SrcB reads from SignExtend |
| RegWrite_o | Register does not write | Register saves WD in A |

| Signal | 00 | 01 | 11 | 10 |
| --- | --- | --- | --- | --- |
| ImmSrc_o | Something | Something | Something | Something |