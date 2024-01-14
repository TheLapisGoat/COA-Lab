module mux_3to1 (
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [1:0] sel,
    output reg [4:0] out
);
    always @(*) begin
        case(sel)
            2'b00: out = rs;
            2'b01: out = rt;
            2'b10: out = rd;
            default: out = rs;
        endcase
    end
endmodule