module mux_4_vs_in2 (
    input [31:0] in2,
    input sel,
    output [31:0] out
);
    assign out = (sel == 1'b0) ? 4 : in2;
endmodule