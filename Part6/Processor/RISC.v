`include "ControlUnit.v"
`include "Datapath.v"

module RISC (
    input clk,
    input INT,
    input rst,
    output reg [15:0] finalout
);
wire [5:0] opcode;
wire [1:0] PCControl;
wire Call;
wire [5:0] ALUop;
wire [1:0] RegDst;
wire RegWrite;
wire ALUSrc1;
wire ALUSrc2;
wire SPWrite;
wire [1:0] ZControl;
wire MemToOut;
wire PCUpdate;
wire MemWrite;
wire WriteDataSrc;
wire SPUpdate;
wire [1:0] ZControlSP;
wire [31:0] answer_out;

always @(posedge clk) begin
    if (rst) begin
        finalout <= 12;
    end else begin
        finalout <= answer_out[15:0];
    end
end

control_unit hehe
(
    rst,
    opcode,
    clk,
    INT,
    PCControl,             //Left Bit is for PCin and Right Bit is for PCout
    Call,                        //Call is 1 for call and 0 otherwise
    ALUop,
    RegDst,                 //0 for rs, 1 for rt, 2 for rd
    RegWrite,                     //1 for Writing to Register, 0 othw
    ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    SPWrite,                      //1 for Writing to SP, 0 othw
    ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    MemToOut,                      //0 for ReadDataMem, 1 for ALUResult
    PCUpdate,
    MemWrite,                      //1 for Writing to Data Memory, 0 othw
    WriteDataSrc,                  //0 for ReadData2, 1 for Updated PC Value
    SPUpdate,                     //0 for SP = SP - 4, 1 for SP = SP + 4
    ZControlSP             //Left Bit is for ZSPin and Right Bit is for ZSPout
);

datapath haha
(
    rst,
    clk,
    ALUop,
    PCControl,
    Call,
    RegDst,                 //0 for rs, 1 for rt, 2 for rd
    ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    RegWrite,                     //1 for Writing to Register, 0 othw
    SPWrite,                      //1 for Writing to SP, 0 othw
    ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    MemToOut,                     //0 for ReadDataMem, 1 for ALUResult
    PCUpdate,                     //0 for PC = PC + 4, 1 for address from data memory
    MemWrite,                     //1 for Writing to Data Memory, 0 othw
    WriteDataSrc,                  //0 for ReadData2, 1 for Updated PC Value 
    SPUpdate,                     //0 for SP = SP - 4, 1 for SP = SP + 4
    ZControlSP,             //Left Bit is for ZSPin and Right Bit is for ZSPout  
    opcode,
    answer_out
);
endmodule