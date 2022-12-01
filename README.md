# Team 1 (RISCy Business) ✨

## Table for Control Unit Signals

| Opcode | Branch_o | ResultSrc_o | MemWrite_o | ALUSrc_o | ImmSrc_o | RegWrite_o |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | ? | ? | ? | ? | ? | ? |
| Load Mem | ? | ? | ? | ? | ? | ? |
| I-Type | ? | ? | ? | ? | ? | ? |
| Store Mem | ? | ? | ? | ? | ? | ? |
| Branch | ? | ? | ? | ? | ? | ? |
| rd = uppimm + PC | ? | ? | ? | ? | ? | ? |
| rd = uppimm | ? | ? | ? | ? | ? | ? |
| Jump and Link Reg | ? | ? | ? | ? | ? | ? |
| Jump and Link | ? | ? | ? | ? | ? | ? |
| default? | ? | ? | ? | ? | ? | ? |

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

![image](https://user-images.githubusercontent.com/59978422/205101131-365f9510-62d7-4854-b699-884c128b761f.png)

