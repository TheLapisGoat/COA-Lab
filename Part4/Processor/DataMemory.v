module data_memory (
    input [31:0] address,
    input [31:0] writeData,
    input MemWrite,
    output [31:0] readData
);

    reg [7:0] mem [15:0];

    initial begin
        $readmemb("data_mem.b", mem, 0, 15);
    end

    always @(*) begin
        if (MemWrite) begin
            mem[address[31:0]] = writeData[31:24];
            mem[address[31:0]+1] = writeData[23:16];
            mem[address[31:0]+2] = writeData[15:8];
            mem[address[31:0]+3] = writeData[7:0];
        end
    end
    
    assign readData[31:24] = mem[address[31:0]];
    assign readData[23:16] = mem[address[31:0]+1];
    assign readData[15:8] = mem[address[31:0]+2];
    assign readData[7:0] = mem[address[31:0]+3];
endmodule