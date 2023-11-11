module branch_controller (
    input [5:0] opcode,
    input flagZ,
    input flagS,
    output reg Branch           //1 for Branch, 0 othw
);
    initial begin
        Branch = 0;
    end

    always @(*) begin
        case (opcode)
            6'b001110: begin 
                Branch <= 1;     //BR
            end
            6'b001111: begin
                Branch <= flagS; //BMI
            end
            6'b010000: begin
                Branch <= ~flagS & ~flagZ; //BPL
            end
            6'b010001: begin
                Branch <= flagZ; //BZ
            end
            default:
                Branch <= 0;     //Default Value: Do nothing
        endcase
    end
endmodule
