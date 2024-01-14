module instruction_memory (
    input [31:0] address,
    input clk,
    input rst,
    output reg [31:0] instruction
);
    reg [7:0] mem [200:0];

    initial begin
        $readmemb("instruction_mem.b", mem, 0, 200);
        instruction <= 32'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
            instruction <= 0;
        end else begin
            instruction[31:24] <= mem[address[9:0]];
            instruction[23:16] <= mem[address[9:0]+1];
            instruction[15:8] <= mem[address[9:0]+2];
            instruction[7:0] <= mem[address[9:0]+3];
        end
    end
endmodule