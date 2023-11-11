module control_unit (
    input rst,
    input [5:0] opcode,
    input clk,
    input INT,                              //Interrupt
    output reg [1:0] PCControl,             //Left Bit is for PCin and Right Bit is for PCout
    output reg Call,                        //Call is 1 for call and 0 otherwise
    output reg [5:0] ALUop,
    output reg [1:0] RegDst,                 //0 for rs, 1 for rt, 2 for rd
    output reg RegWrite,                     //1 for Writing to Register, 0 othw
    output reg ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    output reg ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    output reg SPWrite,                      //1 for Writing to SP, 0 othw
    output reg [1:0] ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    output reg MemToOut,                      //0 for ReadDataMem, 1 for ALUResult
    output reg PCUpdate,                      //0 for PC = PC + 4, 1 for address from data memory
    output reg MemWrite,                      //1 for Writing to Data Memory, 0 othw
    output reg WriteDataSrc,                  //0 for ReadData2, 1 for Updated PC Value
    output reg SPUpdate,                      //0 for SP = SP - 4, 1 for SP = SP + 4
    output reg [1:0] ZControlSP               //Left Bit is for Zin and Right Bit is for Zout
);
    reg [1:0] cu_state;
    reg [1:0] j_state;
    reg [4:0] instr_state;

    initial begin
        cu_state = 0;
        instr_state = 0;
        PCControl = 0;
        Call = 0;
        ALUop = 0;
        RegDst = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
        SPWrite = 0;
        ZControl = 0;
        MemToOut = 0;
        PCUpdate = 0;
        MemWrite = 0;
        WriteDataSrc = 0;
        SPUpdate = 0;
        ZControlSP = 0;
        j_state = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            cu_state <= 0;
            instr_state <= 0;
            PCControl <= 0;
            Call <= 0;
            ALUop <= 0;
            RegDst <= 0;
            ALUSrc1 <= 0;
            ALUSrc2 <= 0;
            RegWrite <= 0;
            SPWrite <= 0;
            ZControl <= 0;
            MemToOut <= 0;
            PCUpdate <= 0;
            MemWrite <= 0;
            WriteDataSrc <= 0;
            SPUpdate <= 0;
            ZControlSP <= 0;
            j_state <= 0;
        end else if (j_state == 1) begin
            j_state <= 2;
        end else if (j_state == 2) begin
            j_state <= 0;
        end else begin
            j_state <= 1;
            case (cu_state)
            0: begin
                PCControl <= 2'b01;
                cu_state <= 1;
            end
            1: begin
                case (opcode)
                    6'b000000: begin                    //R-type
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 2;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 0;
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000001: begin                //ADDI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000010: begin                    //SUBI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end                                 
                    6'b000011: begin                        //ANDI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000100: begin                    //ORI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000101: begin                        //XORI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000110: begin                        //NOTI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b000111: begin                        //SLLI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001000: begin                    //SRLI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001001: begin                        //SRAI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001010: begin                        //LD
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 1;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 0;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001011: begin                        //ST
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                WriteDataSrc <= 0;
                                MemWrite <= 1;               //Write to Data Memory
                                instr_state <= 2;
                            end
                            2: begin
                                MemWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001100: begin                        //LDSP
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 1;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 0;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001101: begin                        //STSP
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ALUSrc2 <= 1;                //Input Immediate32bit to ALU
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                WriteDataSrc <= 0;
                                MemWrite <= 1;               //Write to Data Memory
                                instr_state <= 2;
                            end
                            2: begin
                                MemWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001110: begin                        //BR
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUop <= opcode;
                                instr_state <= 1;
                            end
                            1: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b001111: begin                        //BMI
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUSrc1 <= 0;
                                ALUop <= opcode;
                                instr_state <= 1;
                            end
                            1: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010000: begin                        //BPL
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUSrc1 <= 0;
                                ALUop <= opcode;
                                instr_state <= 1;
                            end
                            1: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010001: begin                        //BZ
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0; 
                                ALUSrc1 <= 0;
                                ALUop <= opcode;
                                instr_state <= 1;
                            end
                            1: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010010: begin                        //PUSH
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUop <= opcode;
                                SPUpdate <= 0;
                                ZControlSP <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControlSP <= 2'b01;
                                SPWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                SPWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControlSP <= 2'b00;
                                ALUSrc1 <= 1;
                                ZControl <= 2'b10;
                                WriteDataSrc <= 0;
                                instr_state <= 4;
                            end
                            4: begin
                                ZControl <= 2'b01;
                                MemWrite <= 1;
                                instr_state <= 5;
                            end
                            5: begin
                                MemWrite <= 0;
                                instr_state <= 6;
                            end
                            6: begin
                                ZControl <= 2'b00;
                                instr_state <= 7;
                            end
                            7: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010011: begin                        //POP
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0; 
                                ALUop <= opcode;
                                ALUSrc1 <= 1;
                                ZControl <= 2'b10;
                                RegDst <= 1;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 0;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                SPUpdate <= 1;
                                ZControlSP <= 2'b10;
                                instr_state <= 4;
                            end
                            4: begin
                                ZControlSP <= 2'b01;
                                SPWrite <= 1;
                                instr_state <= 4;
                            end
                            5: begin
                                SPWrite <= 0;
                                instr_state <= 5;
                            end
                            6: begin
                                ZControlSP <= 2'b00;
                                instr_state <= 7;
                            end
                            7: begin
                                PCControl <= 2'b10;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                instr_state <= 0;
                                cu_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010100: begin                        //CALL
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                ALUop <= opcode;
                                SPUpdate <= 0;
                                ZControlSP <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControlSP <= 2'b01;
                                SPWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                SPWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControlSP <= 2'b00;
                                ALUSrc1 <= 1;
                                ZControl <= 2'b10;
                                WriteDataSrc <= 1;
                                instr_state <= 4;
                            end
                            4: begin
                                ZControl <= 2'b01;
                                MemWrite <= 1;
                                instr_state <= 5;
                            end
                            5: begin
                                MemWrite <= 0;
                                instr_state <= 6;
                            end
                            6: begin
                                ZControl <= 2'b00;
                                WriteDataSrc <= 0;
                                Call <= 1;
                                instr_state <= 7;
                            end
                            8: begin
                                PCControl <= 2'b10;
                                instr_state <= 9;
                            end
                            9: begin
                                PCControl <= 2'b00;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                instr_state <= 0;
                                cu_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010101: begin                        //RET
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 1;
                                Call <= 0; 
                                ALUop <= opcode;
                                ALUSrc1 <= 1;
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 0;
                                PCControl <= 2'b10;
                                instr_state <= 2;
                            end
                            2: begin
                                PCControl <= 2'b00;
                                instr_state <= 3;
                            end
                            3: begin
                                ZControl <= 2'b00;
                                PCUpdate <= 0;
                                SPUpdate <= 1;
                                ZControlSP <= 2'b10;
                                instr_state <= 4;
                            end
                            4: begin
                                ZControlSP <= 2'b01;
                                SPWrite <= 1;
                                instr_state <= 5;
                            end
                            5: begin
                                SPWrite <= 0;
                                instr_state <= 6;
                            end
                            6: begin
                                ZControlSP <= 2'b00;
                                cu_state <= 0;
                                instr_state <= 0;
                            end
                            default: begin
                                instr_state <= 0;
                                cu_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b010110: begin                        //MOVE
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0;
                                RegDst <= 1;
                                ALUop <= opcode;
                                ALUSrc1 <= 0;
                                ZControl <= 2'b10;
                                instr_state <= 1;
                            end
                            1: begin
                                ZControl <= 2'b01;
                                MemToOut <= 1;
                                RegWrite <= 1;
                                instr_state <= 2;
                            end
                            2: begin
                                RegWrite <= 0;
                                instr_state <= 3;
                            end
                            3: begin
                                MemToOut <= 0;
                                ZControl <= 2'b00;
                                instr_state <= 4;
                            end
                            4: begin
                                cu_state <= 0;
                                instr_state <= 0;
                                PCControl <= 2'b10;
                            end
                            default: begin
                                instr_state <= 0;
                                cu_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b100000: begin                        //HALT: Stay in this state till INT is pressed
                        case (instr_state)
                            0: begin
                                PCControl <= 2'b00;
                                PCUpdate <= 0;
                                Call <= 0; 
                                ALUop <= opcode;
                                instr_state <= 1;
                            end
                            1: begin
                                if (INT == 1) begin
                                    PCControl <= 2'b10;
                                    cu_state <= 0;
                                    instr_state <= 0;
                                end
                            end
                            default: begin
                                instr_state <= 0;
                                cu_state <= 0;
                                PCControl <= 2'b10;
                            end
                        endcase
                    end
                    6'b100001: begin                        //NOP
                        PCUpdate <= 0;
                        Call <= 0;
                        cu_state <= 0;
                        instr_state <= 0;
                        PCControl <= 2'b10;
                    end
                    default: begin
                        PCControl <= 2'b00;
                    end
                endcase
            end
            default: begin
                cu_state <= 0;
            end
            endcase
        end
    end
endmodule