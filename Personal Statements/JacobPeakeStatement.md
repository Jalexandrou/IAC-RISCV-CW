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


___
### Data Memory
___


___
### Register File
___


___
### CPU
___


___
### Cache
___

*[Link to module](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-1/blob/cache/CPU/DataMem.sv)*

The additional stretch goal of this project was to add Data Memory Cache to the pipelined processor. Even though this may negatively impact performance in the case of our processor, due to it already being single-cycle memory which is very fast, implementing this into the CPU taught me further details about how cache memory works and the challenges that can occur when implementing it into a real design.

In my design I have used direct mapped cache as it is simple to implement into the existing processor- and only requires a small amount of extra hardware which can be put inside the Data Memory module itself. As the limit given by the stretch goal is 256 bytes of data cache- I had to implement the cache as having a capacity of 64 words, with a width of 57 bits, 32 for the data, 24 for the tag and 1 for the V bit.

This allowed me to define a 1-D cache array with 64 sets:

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


            


___

