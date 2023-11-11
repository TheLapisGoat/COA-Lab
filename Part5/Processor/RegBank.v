module register_bank ( 
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,          //Address of Register to write to
    input [31:0] WriteData,
    input [31:0] WriteDataSP,
    input RegWrite,                 //CS to write to register
    input SPWrite,                  //CS to write to SP
    input clk,
    input rst,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2,
    output reg [31:0] ReadDataSP,
    output reg [31:0] answer_out
);

    reg [31:0] registers [16:0];
	
	always @(posedge clk) begin
        if (rst) begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            registers[3] <= 0;
            registers[4] <= 0;
            registers[5] <= 0;
            registers[6] <= 0;
            registers[7] <= 0;
            registers[8] <= 0;
            registers[9] <= 0;
            registers[10] <= 0;
            registers[11] <= 0;
            registers[12] <= 0;
            registers[13] <= 0;
            registers[14] <= 0;
            registers[15] <= 0;
            registers[16] <= 16;
            ReadData1 = 0;
            ReadData2 = 0;
            ReadDataSP = 0;
        end else begin
            //Only update register if RegWrite is 1 and Write Register is not 0
            if (RegWrite && WriteRegister != 0) begin
                registers[WriteRegister] = WriteData;
            end
            if (SPWrite) begin
                registers[16] = WriteDataSP;
            end
            ReadData1 = registers[ReadRegister1];
            ReadData2 = registers[ReadRegister2];
            ReadDataSP = registers[16];
        end
        answer_out <= registers[15];
    end

    initial begin
        registers[0] <= 0;
        registers[1] <= 0;
        registers[2] <= 0;
        registers[3] <= 0;
        registers[4] <= 0;
        registers[5] <= 0;
        registers[6] <= 0;
        registers[7] <= 0;
        registers[8] <= 0;
        registers[9] <= 0;
        registers[10] <= 0;
        registers[11] <= 0;
        registers[12] <= 0;
        registers[13] <= 0;
        registers[14] <= 0;
        registers[15] <= 0;
        registers[16] <= 16;
        ReadData1 = 0;
        ReadData2 = 0;
        ReadDataSP = 0;
    end
endmodule