module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] funct,
    output reg [31:0] out,
    output reg flagZ
);
    wire [31:0] add_out;
    wire [31:0] sub_out;
    wire [31:0] and_out;
    wire [31:0] or_out;
    wire [31:0] xor_out;
    wire [31:0] not_out;
    wire [31:0] sla_out;
    wire [31:0] sra_out;
    wire [31:0] srl_out;

    ADD add_module(A, B, add_out);
    SUB sub_module(A, B, sub_out);
    AND and_module(A, B, and_out);
    OR or_module(A, B, or_out);
    XOR xor_module(A, B, xor_out);
    NOT not_module(A, not_out);
    SLA sla_module(A, B, sla_out);
    SRA sra_module(A, B, sra_out);
    SRL srl_module(A, B, srl_out);

    always @(*) begin
        case(funct)
            4'b0000: out = add_out;
            4'b0001: out = sub_out;
            4'b0010: out = and_out;
            4'b0011: out = or_out;
            4'b0100: out = xor_out;
            4'b0101: out = not_out;
            4'b0110: out = sla_out;
            4'b0111: out = sra_out;
            4'b1000: out = srl_out;
            default: out = 0;
        endcase
    end

    always @(*) begin
        if(out == 0) begin
            flagZ = 1;
        end else begin
            flagZ = 0;
        end
    end
endmodule

module ADD (
    input signed [31:0] A,
    input signed [31:0] B,
    output wire [31:0] S
);

    assign S = A + B;
endmodule

module SUB (
    input signed [31:0] A,
    input signed [31:0] B,
    output wire [31:0] S
);

    assign S = A - B;
endmodule

module AND (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A & B;
endmodule

module OR (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A | B;
endmodule

module XOR (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A ^ B;
endmodule

module NOT (
    input wire [31:0] A,
    output wire [31:0] S
);

    assign S = ~A;
endmodule

module SLA (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A << B;
endmodule

module SRA (
    input signed [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A >>> B;
endmodule

module SRL (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A >> B;
endmodule