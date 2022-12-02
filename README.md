# Team 1 (RISCy Business) ✨

## Table for Control Unit Signals

| Opcode | Branch_o | ResultSrc_o | MemWrite_o | ALUSrc_o | ImmSrc_o | RegWrite_o |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | 0 | 0 | 0 | 0 | xx | 1 |
| Load Mem | 0 | 1 | 0 | 1 | 000 | 1 |
| I-Type | 0 | 0 | 0 | 1 | 000 | 1 |
| Store Mem | 0 | x | 1 | 1 | 001 | 0 |
| Branch | 1 | x | 0 | 0 | 010 | 0 |
| rd = uppimm + PC | ? | ? | ? | ? | 100 | ? |
| rd = uppimm | ? | ? | ? | ? | 100 | ? |
| Jump and Link Reg | ? | ? | ? | ? | 011 | ? |
| Jump and Link | ? | ? | ? | ? | 011 | ? |
| default? | ? | ? | ? | ? | ? | ? |

| Signal | 0 | 1 |
| --- | --- | --- |
| Branch_o | Adds with 0 so PCSrc == 1? PCNext increments by SignExtend | PCNext increments by 4 |
| ResultSrc_o | Register saves data from ALUResult | Register saves data from Memory->ReadData |
| MemWrite_o | Memory does not write | Memory saves WD in A |
| ALUSrc_o | ALU->SrcB reads from Reg->RD2 | ALU->SrcB reads from SignExtend |
| RegWrite_o | Register does not write | Register saves WD in A |

| Signal | 000 | 001 | 010 | 011 | 100 |
| --- | --- | --- | --- | --- |
| ImmSrc_o | Imm | Store | Branch | Jump | UppImm |

![image](https://user-images.githubusercontent.com/59978422/205101131-365f9510-62d7-4854-b699-884c128b761f.png)

