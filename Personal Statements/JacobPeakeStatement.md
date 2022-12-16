<center>

## RV32I Pipelined CPU Coursework

 **Personal Statement of Contributions**
 
 *Jacob Peake*

---

</center>

## Overview

* [ALU](#ALU)
* [Data Memory](#Data-Memory)
* [Register File](#Register-File)
* [CPU](#CPU)
* [Cache](#Cache)
___
### ALU
___

*[ALU.sv](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/ALU.sv)*

The ALU.sv module was copied from Laboratory 4 with some changes. Implementing the ALU taught me how to use enumeration, specifying an enumerated type `func` which characterised all of the ALU operations as numbers corresponding to the value of `ALUctrl` that determines that operation. 

We then could define these operations in an `always_comb` statement- giving the operation performed in each case. This requires a default case to also be specified. After defining all operations, all that was need was to set the `zero_o` valeue to 1 if the output of the ALU was 0, and 0 otherwise.

*Thanks to Jake for contributing with the LSHIFT and PASSOP2 operations.*
___
### Data Memory
___

*[DataMem.sv](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/DataMem.sv)*

For the DataMem.sv module, we must define the memory with respect to the memory map given to us in the project brief- requiring the Data Memory to be defined by address values h'0001FFFF & h'00000000. On the positive edge of the clock, if `we = 1`, then data is written into memory at the specified address. This is done with byte addressing if the value of `ByteOp` is 0.

Then, defined in combinational logic, data can be written at any time into memory at the address specified, using byte or word addressing methods.

*Thanks to Jake for contributing with Byte Addressing.*

___
### Register File
___

*[RegFile.sv](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/RegFile.sv)*

Implementing the RegFile.sv module was straightforward, it has the functionality to simply pass the values at address `ad1` & `ad2` to outputs `rd1` & `rd2` to read data from the registers- and if `we=1` it must write the value `wd3` to the register at address `ad3`. 

The only specific decision that must be made for this RegFile is to also output the value `a0`- which is the register located at address x10 of the RegFile in a RV32I RISC-V processor.
___
### CPU
___

*[cpu.sv](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/main/CPU/cpu.sv)*

This is a structural module for the sigle cycle processor that connects each of the RTL components together. It defines the intput/output logic, interconnecting wires and instances of the behavioural modules that have been previously defined.

This is later expanded to allow for pipelining of the processor.

___
### Cache
___

*[DataMem.sv with Cache](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/cache/CPU/DataMem.sv)*

The additional stretch goal of this project was to add Data Memory Cache to the pipelined processor. Even though this may negatively impact performance in the case of our processor, due to it already being single-cycle memory which is very fast, implementing this into the CPU taught me further details about how cache memory works and the challenges that can occur when implementing it into a real design.

In my design I have used direct mapped cache as it is simple to implement into the existing processor- and only requires a small amount of extra hardware which can be put inside the Data Memory module itself. As the limit given by the stretch goal is 256 bytes of data cache- I had to implement the cache as having a capacity of 64 words, with a width of 57 bits, 32 for the data, 24 for the tag and 1 for the V bit.

This allowed me to define a one dimensional cache array with 64 sets:

`logic [CACHE_WIDTH-1:0] cache_array [2**SET_WIDTH-1:0];`

When reading data from memory, the cache should be checked first, before checking the data memory itself. To implement this is SV, we use an if statement to compare value in Cache with the corresponding Tag of the address- and check if the V bit is 1. If true, read data from Cache, otherwise go to the data memory address to read data and also copy that data into cache.

```
if((cache_array[55:32] == Address [31:8]) && cache_array[56] == 1) begin    // Check cache first
    ReadData = cache_array[Address[8:2]];
end
else begin
    ReadData = ram_array[Address];
                
    cache_array[Address[8:2]] <= ram_array[Address];    // Put Accessed Data into Cache, Temporal Locality
 end
```

A problem is encountered is when writing data to cache memory. If cache misses, the cache block is fetched from main memory and the word is written to the cache block. If cache hits, the word is simply written to the cache block. Once a word is written, the cache contains different data from the main memory (cache coherency). To solve this, I implemented the cache as write through- so that data is written to cache and the main memory simultaneously. Whenever write enable is 1- any data written to main memory is also written to the corresponding set in cache.

If I had more time, I would have implemented set associative cache which is designed to take advantage of spatial locality in order to maximise the reduction in miss rate. I also would have added multiple levels of cache as an expansion of memory heirarchy.         
___

