module ALU_FPGA_test(
    input wire [15:0] switch,
    input wire btn,
    input wire rst,
    input wire clk,
    output reg [15:0] out
);
    reg [3:0] state;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] funct;
    reg btnlock;
    wire [31:0] S;
    wire flagZ;

    initial begin
        state = 0;
        A = 0;
        B = 0;
        funct = 0;
        out = 0;
        btnlock = 0;
    end

    ALU alu_inst(
        A,
        B,
        funct,
        S,
        flagZ
    );

    always @(posedge clk) begin
        if (btn & !btnlock) begin
            btnlock = 1;
            case (state)
                0: A[15:0] = switch;
                1: A[31:16] = switch;
                2: B[15:0] = switch;
                3: B[31:16] = switch;
                4: funct[3:0] = switch[3:0];
                5: out = S[15:0];
                6: out = S[31:16];
                7: out = flagZ;
            endcase
            state = state + 1;
            if (state == 8) begin
                state = 0;
            end 
        end else begin
            btnlock = 0;
        end
    end
endmodule