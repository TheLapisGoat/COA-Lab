# Computer Organization Laboratory (CS39001), Autumn 2023
Design and implementation of a 32-bit processor using Verilog

- The Assembler folder contains the assembler for the ISA.
- The Processor folder contains the Verilog and binary memory files for the processor.
- The TestCases folder contains 2 test cases for the processor, which are Boothes and GCD for inputs 12 and 28.
- Details about the processor control path, datapath and ISA can be found in the [Report](./Report.pdf) 
## Group Information
Group 20
1. Sourodeep Datta (21CS10064)
2. Mihir Mallick (21CS30031)

## How to run the code
To run both the testcases, run `make`

To run boothes, run `make boothe`

To run gcd, run `make gcd`

To clean the directory, run `make clean`

To run your own programs, use the assembler to generate an instruction_mem.b and a data_mem.b file, and place them in the [Processor](./Processor) directory.

## Using the assembler
Install all dependencies using `pip install -r requirements.txt`.

The assembler requires four arguments, which are:
- **-t** : Path to the file containing the text section of the assembly code
- **-d** : Path to the file containing the data section of the assembly code
- **-oi** : Path to the file where the instruction memory binary should be written
- **-od** : Path to the file where the data memory binary should be written

An example command is:
```
python assembler.py -t "instructions.txt" -d "data.txt" -oi "Processor/instruction_mem.b" -od "Processor/data_mem.b"
```
