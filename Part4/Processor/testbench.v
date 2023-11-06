`include "RISC.v"
`timescale 1ps/1ps

module tb_ControlUnit;
reg clk;
reg INT;
reg rst;
wire[15:0] finalout;

RISC processor (
    .clk(clk),
    .INT(INT),
    .rst(rst)
);

localparam CLK_PERIOD = 4;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_ControlUnit.vcd");
    $dumpvars(5, tb_ControlUnit);
end

initial begin
    clk = 1; INT = 0; rst = 0;
    #100000
    rst = 1;
    #10
    rst = 0;
    #100000
    $finish;
end
endmodule