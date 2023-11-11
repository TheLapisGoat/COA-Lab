module mux_2to1_32bit (
    input [31:0] in1,
    input [31:0] in2,
    input sel,
    output [31:0] out
);
    assign out = (sel == 1'b0) ? in1 : in2;
endmodule