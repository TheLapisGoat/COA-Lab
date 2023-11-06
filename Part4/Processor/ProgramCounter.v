module program_counter (
    input [1:0] PCControl,
    input [31:0] PCinput,
    input rst,
    output reg [31:0] PCoutput
);
    reg [31:0] PC;

    initial begin
        PC = 0;
        PCoutput = 0;
    end

    always @(*) begin
        if (rst) begin
            PC = 0;
            PCoutput = 0;
        end
    end
    
    always @(*) begin
        case (PCControl)
            2'b01: begin
                PCoutput = PC;
            end
            2'b10: begin
                PC = PCinput;
            end
            default: begin
                //Do nothing
            end
        endcase
    end
endmodule