`include "RISC.v"
`timescale 1ps/1ps

module tb_ControlUnit;
reg clk;
reg INT;
reg rst;
wire[31:0] finalout;

RISC processor (
    .clk(clk),
    .INT(INT),
    .rst(rst),
    .finalout(finalout)
);

localparam CLK_PERIOD = 4;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    clk = 0; INT = 0; rst = 0;
    #500000
    $display("Final output is %d", finalout);
    $finish;
end
endmodule