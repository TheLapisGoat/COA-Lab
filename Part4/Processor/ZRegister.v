module z_register (
    input [1:0] ZControl,
    input [31:0] ZInput,
    input rst,
    output reg [31:0] ZOutput
);
    reg [31:0] ZInternal;

    initial begin
        ZInternal = 0;
        ZOutput = 0;
    end

    always @(*) begin
        if (rst) begin
            ZInternal = 0;
            ZOutput = 0;
        end
    end

    always @(*) begin
        case (ZControl)
            2'b01: begin
                ZOutput = ZInternal;
            end
            2'b10: begin
                ZInternal = ZInput;
            end
            default: begin
                //Do nothing
            end
        endcase
    end
endmodule