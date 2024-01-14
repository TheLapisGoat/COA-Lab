all: boothe gcd

boothe: 
	@echo -e "\nRunning Boothe's algorithm for inputs 12 and 28:\n"
	cp "TestCases/Boothe/data_mem.b" "Processor/data_mem.b"
	cp "TestCases/Boothe/instruction_mem.b" "Processor/instruction_mem.b"
	cd Processor && iverilog "testbench.v"
	cd Processor && vvp "a.out"

gcd:
	@echo -e "\nRunning GCD algorithm for inputs 12 and 28:\n"
	cp "TestCases/GCD/data_mem.b" "Processor/data_mem.b"
	cp "TestCases/GCD/instruction_mem.b" "Processor/instruction_mem.b"
	cd Processor && iverilog "testbench.v"
	cd Processor && vvp "a.out"

clean:
	rm -f Processor/data_mem.b Processor/instruction_mem.b Processor/a.out