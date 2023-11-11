module mux_subtract4_vs_add4 (
    input sel,                      //0 for subtract 4, 1 for add 4
    output [31:0] out
);
    assign out = sel ? 4 : -4;
endmodule