`include "ProgramCounter.v"
`include "InstructionMemory.v"
`include "InstructionDecoder.v"
`include "RegBank.v"
`include "Mux_3to1.v"
`include "Mux_2to1_32bit.v"
`include "ALU.v"
`include "ALUController.v"
`include "ZRegister.v"
`include "SignExtend.v"
`include "Adder.v"
`include "Mux_4_vs_in2.v"
`include "DataMemory.v"
`include "BranchController.v"
`include "Mux_subtract4_vs_add4.v"

module datapath (
    input rst,
    input clk,
    input [5:0] ALUop,
    input [1:0] PCControl,
    input Call,
    input [1:0] RegDst,                 //0 for rs, 1 for rt, 2 for rd
    input ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    input ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    input RegWrite,                     //1 for Writing to Register, 0 othw
    input SPWrite,                      //1 for Writing to SP, 0 othw
    input [1:0] ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    input MemToOut,                     //0 for ReadDataMem, 1 for ALUResult
    input PCUpdate,                     //0 for PC = PC + 4, 1 for address from data memory
    input MemWrite,                     //1 for Writing to Data Memory, 0 othw
    input WriteDataSrc,                 //0 for ReadData2, 1 for Updated PC Value
    input SPUpdate,                     //0 for SP = SP - 4, 1 for SP = SP + 4
    input [1:0] ZControlSP,             //Left Bit is for ZSPin and Right Bit is for ZSPout
    output [5:0] opcode,
    output [31:0] answer_out
);

wire [31:0] PCoutput;
wire [31:0] instruction;
wire [5:0] funct;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [15:0] immediate;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] readDataSP;
wire [4:0] writeRegister;
wire [31:0] ALUinput1;
wire [31:0] ALUinput2;
wire [5:0] ALUfunct;
wire [31:0] ALUResult;
wire [31:0] ZOutput;
wire [31:0] mux3output;
wire [31:0] sign_extended_immediate;
wire [31:0] adder_input;
wire [31:0] adder_output;
wire [31:0] PCinput;
wire [31:0] readDataMem;
wire [31:0] writeDataMem;
wire flagZ; wire flagS;
wire Branch;
wire doBranch;
wire [31:0] adderSPin1;
wire [31:0] adderSPout;
wire [31:0] ZSPout;

assign doBranch = Call | Branch;            //Branch if Call is 1 or Branch is 1

program_counter pc_module (
    .PCControl(PCControl),
    .PCinput(PCinput),
    .PCoutput(PCoutput),
    .rst(rst),
    .clk(clk)
);

instruction_memory imem_module (
    .address(PCoutput),
    .instruction(instruction),
    .rst(rst),
    .clk(clk)
);

instruction_decoder idec_module (
    instruction,
    opcode,
    rs,
    rt,
    rd,
    funct,
    immediate
);

mux_3to1 mux3to1_module (
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .sel(RegDst),
    .out(writeRegister)
);

register_bank reg_module (
    .ReadRegister1(rs),
    .ReadRegister2(rt),
    .WriteRegister(writeRegister),          //Address of Register to write to
    .WriteData(mux3output),
    .WriteDataSP(ZSPout),
    .RegWrite(RegWrite),                 //CS to write to register
    .SPWrite(SPWrite),                  //CS to write to SP
    .ReadData1(readData1),
    .ReadData2(readData2),
    .ReadDataSP(readDataSP),
    .rst(rst),
    .clk(clk),
    .answer_out(answer_out)
);

sign_extend sign_extend_module (
    .in(immediate),
    .out(sign_extended_immediate)
);

mux_2to1_32bit mux2to1_32bit_module_1 (         //Mux for ALU input 1
    .in1(readData1),
    .in2(readDataSP),
    .sel(ALUSrc1),
    .out(ALUinput1)
);

mux_2to1_32bit mux2to1_32bit_module_2 (         //Mux for ALU input 2
    .in1(readData2),
    .in2(sign_extended_immediate),
    .sel(ALUSrc2),
    .out(ALUinput2)
);

alu_controller alucon_module (
    .ALUop(ALUop),
    .funct(funct),
    .ALUfunct(ALUfunct)           //Funct Performed By the ALU
);

alu alu_module (
    .A(ALUinput1),
    .B(ALUinput2),
    .ALUfunct(ALUfunct),
    .out(ALUResult),
    .flagZ(flagZ),
    .flagS(flagS)
);

z_register z_module (
    .ZControl(ZControl),
    .ZInput(ALUResult),
    .ZOutput(ZOutput),
    .rst(rst),
    .clk(clk)
);

mux_2to1_32bit mux2to1_32bit_module_3 (         //Mux to choose between ReadDataMem and ALUResult
    .in1(readDataMem),
    .in2(ZOutput),
    .sel(MemToOut),
    .out(mux3output)
);

mux_4_vs_in2 mux4vsin2_module (
    .in2(sign_extended_immediate),
    .sel(doBranch),                                 
    .out(adder_input)
);

adder adder_module (
    .in1(PCoutput),
    .in2(adder_input),
    .out(adder_output)
);

mux_2to1_32bit mux2to1_32bit_module_4 (         //Mux to choose between adder_output and mux3output
    .in1(adder_output),
    .in2(mux3output),
    .sel(PCUpdate),
    .out(PCinput)
);

mux_2to1_32bit mux2to1_32bit_module_5 (         //Mux to choose between ReadData2 and NewPC value
    .in1(readData2),
    .in2(adder_output),
    .sel(WriteDataSrc),
    .out(writeDataMem)
);

data_memory dmem_module (
    .address(ZOutput),
    .writeData(writeDataMem),                          //Temporarily using 0 as writeData
    .MemWrite(MemWrite),                           //Temporarily using 0 as MemWrite
    .readData(readDataMem),
    .rst(rst),
    .clk(clk)
);

branch_controller bcon_module (
    .opcode(opcode),
    .flagZ(flagZ),
    .flagS(flagS),
    .Branch(Branch)
);

mux_subtract4_vs_add4 muxsubadd_module (
    .sel(SPUpdate),
    .out(adderSPin1)
);

adder adder_module_SP (
    .in1(adderSPin1),
    .in2(readDataSP),
    .out(adderSPout)
);

z_register z_module_SP (
    .ZControl(ZControlSP),
    .ZInput(adderSPout),
    .ZOutput(ZSPout),
    .rst(rst),
    .clk(clk)
);

endmodule