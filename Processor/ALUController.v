module alu_controller (
    input [5:0] ALUop,
    input [5:0] funct,
    output reg [5:0] ALUfunct           //Funct Performed By the ALU
);

    initial begin
        ALUfunct = 6'b111111;           //Default Value: Do nothing
    end

    always @(*) begin
        case (ALUop)
            6'b000001: 
                ALUfunct <= 6'b100000;   //ADDI
            6'b000010:
                ALUfunct <= 6'b100010;   //SUBI
            6'b000011:
                ALUfunct <= 6'b100100;   //ANDI
            6'b000100:
                ALUfunct <= 6'b100101;   //ORI
            6'b000101:
                ALUfunct <= 6'b100110;   //XORI
            6'b000110:
                ALUfunct <= 6'b100111;   //NOTI
            6'b000111:
                ALUfunct <= 6'b000000;   //SLLI
            6'b001000:
                ALUfunct <= 6'b000010;   //SRLI
            6'b001001:
                ALUfunct <= 6'b000011;   //SRAI
            6'b000000:
                ALUfunct <= funct;       //R-Type
            6'b001010:
                ALUfunct <= 6'b100000;   //LD
            6'b001011:
                ALUfunct <= 6'b100000;   //ST
            6'b001100:
                ALUfunct <= 6'b100000;   //LDSP
            6'b001101:
                ALUfunct <= 6'b100000;   //STSP
            6'b001110:
                ALUfunct <= 6'b100000;   //BR
            6'b001111:
                ALUfunct <= 6'b111111;   //BMI
            6'b010000:
                ALUfunct <= 6'b111111;   //BPL
            6'b010001:
                ALUfunct <= 6'b111111;   //BZ
            6'b010010:
                ALUfunct <= 6'b111111;   //PUSH
            6'b010011:
                ALUfunct <= 6'b111111;   //POP
            6'b010100:
                ALUfunct <= 6'b111111;   //CALL
            6'b010101:
                ALUfunct <= 6'b111111;   //RET
            6'b010110:
                ALUfunct <= 6'b111111;   //MOVE
            6'b100000:
                ALUfunct <= 6'b111111;   //HALT
            default:
                ALUfunct <= 6'b111111;   //Default Value: Do nothing
        endcase
    end
endmodule