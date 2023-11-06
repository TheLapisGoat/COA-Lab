module register_bank ( 
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,          //Address of Register to write to
    input [31:0] WriteData,
    input [31:0] WriteDataSP,
    input RegWrite,                 //CS to write to register
    input SPWrite,                  //CS to write to SP
    input rst,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    output [31:0] ReadDataSP
);

    reg [31:0] registers [16:0];
	
	always @(*) begin
        //Only update register if RegWrite is 1 and Write Register is not 0
        if (RegWrite && WriteRegister != 0) begin
            registers[WriteRegister] = WriteData;
        end
        if (SPWrite) begin
            registers[16] = WriteDataSP;
        end
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
        $dumpvars(0, registers[0], registers[1], registers[2], registers[3], registers[4], registers[5], registers[6], registers[7], registers[8], registers[9], registers[10], registers[11], registers[12], registers[13], registers[14], registers[15], registers[16]);
    end

    always @(*) begin
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
        end
    end

    assign ReadData1 = registers[ReadRegister1];
    assign ReadData2 = registers[ReadRegister2];
	assign ReadDataSP = registers[16];
endmodule