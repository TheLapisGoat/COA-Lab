boothe: 
	@echo "Running Boothe's algorithm for inputs 12 and 28"
	cp "TestCases/Boothe/data_mem.b" "Processor/data_mem.b"
	cp "TestCases/Boothe/instruction_mem.b" "Processor/instruction_mem.b"
	cd Processor && iverilog "testbench.v"
	cd Processor && vvp "a.out"

gcd:
	@echo "Running GCD algorithm for inputs 12 and 28"
	cp "TestCases/GCD/data_mem.b" "Processor/data_mem.b"
	cp "TestCases/GCD/instruction_mem.b" "Processor/instruction_mem.b"
	cd Processor && iverilog "testbench.v"
	cd Processor && vvp "a.out"

clean:
	rm -f Processor/data_mem.b Processor/instruction_mem.b Processor/a.out