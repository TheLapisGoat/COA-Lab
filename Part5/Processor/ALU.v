module alu (
    input signed [31:0] A,
    input signed [31:0] B,
    input wire [5:0] ALUfunct,
    output reg [31:0] out,
    output flagZ,
    output flagS
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
        case(ALUfunct)
            6'b100000: out <= add_out;
            6'b100010: out <= sub_out;
            6'b100100: out <= and_out;
            6'b100101: out <= or_out;
            6'b100110: out <= xor_out;
            6'b100111: out <= not_out;
            6'b000000: out <= sla_out;
            6'b000010: out <= srl_out;
            6'b000011: out <= sra_out;
            6'b111111: out <= A;
            default: out <= A;
        endcase
    end

    assign flagZ = (out == 0);
    assign flagS = out[31];
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

    assign S = A << B[0];
endmodule

module SRA (
    input signed [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A >>> B[0];
endmodule

module SRL (
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A >> B[0];
endmodule