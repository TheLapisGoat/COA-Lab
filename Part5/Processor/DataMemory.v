module data_memory (
    input [31:0] address,
    input [31:0] writeData,
    input clk,
    input rst,
    input MemWrite,
    output reg [31:0] readData
);

    reg [7:0] mem [15:0];

    initial begin
        $readmemb("data_mem.b", mem, 0, 15);
        readData <= 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            readData <= 0;
        end else begin 
            if (MemWrite) begin
                mem[address[31:0]] <= writeData[31:24];
                mem[address[31:0]+1] <= writeData[23:16];
                mem[address[31:0]+2] <= writeData[15:8];
                mem[address[31:0]+3] <= writeData[7:0];
            end
            readData[31:24] <= mem[address[31:0]];
            readData[23:16] <= mem[address[31:0]+1];
            readData[15:8] <= mem[address[31:0]+2];
            readData[7:0] <= mem[address[31:0]+3];
        end
    end
endmodule