module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [7:0] mem [200:0];

    initial begin
        $readmemb("instruction_mem.b", mem, 0, 200);
    end

    assign instruction[31:24] = mem[address[9:0]];
    assign instruction[23:16] = mem[address[9:0]+1];
    assign instruction[15:8] = mem[address[9:0]+2];
    assign instruction[7:0] = mem[address[9:0]+3];
endmodule