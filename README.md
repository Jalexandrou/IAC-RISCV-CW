# Team 1 (RISCy Business) ✨

> [Project Brief Repo](https://github.com/EIE2-IAC-Labs/Project_Brief)

___
## Joint Statement

Our team has completed the design and verification of a single-cycle RV32I processor and pipelined version. The pipelined version of the processor can be found in the *pipelining* branch & an incomplete version with data memory cache can also be found in the *cache* branch.

The rtl folder on the **main** and **pipelining** branches contains everything required to run the reference program on each version of the cpu. Please edit line 17 of `DataMem.sv` to change which memory file is being loaded and the `vbuddy.cfg` may also need to be changed for your device. Following this just run the `pdf.sh` script. Expected results can be seen [here](/Personal%20Statements/JAlexandrouStatement.md/#Results)

The `test` folder on both branches contains the version of pdf.s being used.

To run the f1 program, please run the `f1.sh` script in the `CPU` folder on the branches **f1** and **f1pipelined**

To complete this project, each member of the team was assigned and contributed to their own areas of the development and testing process. This is best summarised in the table below. Personal Statements are in the `Personal Statements` folder.

*Thanks to Peter Cheung & all of the GTAs & UTAs who helped to put this project together.*

___

## Table for Individual Contributions

| Module | James Donald | Jacob Peake | Jacob Lucas Alexandrou | Derin Ak |
| --- | --- | --- | --- | --- |
| ALU.sv |  | * | x |  |
| ALUDecoder.sv | * |  | x |  |
| ControlUnit.sv | * |  | x |  |
| ControlUnitDecoder.sv | * | x | x |  |
| DataMem.sv |  | * | * |  |
| InstructionMem.sv |  |  | * |  |
| PC_Next.sv |  |  | x | * |
| PC_Register.sv | x |  |  | * |
| RegFile.sv |  | * | x |  |
| SignExtend.sv |  |  | * |  |
| cpu.sv | x | * | x |  |
| f1.s | x |  | * |  |
| f1Test.cpp | * |  |  |  |
| pdf.s changes|  |  | * |  |
| pdfTest.cpp |  |  | * |  |
| Pipelining changes | x |  | x | * |
| Cache |  | * |  |  |
| General testing | x | x | * | x |

Principle Contributor: *

Also Helped: x


