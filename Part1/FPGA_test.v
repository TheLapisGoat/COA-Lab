module ALU_FPGA_test(
    input wire [15:0] switch,
    input wire btn,
    input wire rst,
    input clk,
    output reg [15:0] out
);
    reg [3:0] state;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] funct;
    wire [31:0] S;
    wire flagZ;
    wire debounced_btn;

    initial begin
        state = 0;
        A = 0;
        B = 0;
        funct = 0;
        out = 0;
    end

    ALU alu_inst(
        A,
        B,
        funct,
        S,
        flagZ
    );

    ButtonDebouncer btn_debouncer_inst(
        btn,
        clk,
        debounced_btn
    );

    always @(posedge debounced_btn) begin
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
    end

    always @(posedge rst) begin
        state = 0;
        A = 0;
        B = 0;
        funct = 0;
        out = 0;
    end
endmodule

module ButtonDebouncer(
    input wire btn,
    input wire clk,
    output wire out
);
    reg [19:0] ctr_d, ctr_q;        // 20-bit delayed counter
    reg [1:0] sync_d, sync_q;       // 2-bit synchronizer

    initial begin
        ctr_d = 0;
        ctr_q = 0;
        sync_d = 0;
        sync_q = 0;
    end
 
    assign out = (ctr_q == {20{1'b1}});
 
    always @(*) begin
        sync_d[0] = btn;
        sync_d[1] = sync_q[0];
        ctr_d = ctr_q + 1'b1;
 
        if (ctr_q == {20{1'b1}}) begin
            ctr_d = ctr_q;
        end
 
        if (!sync_q[1])
            ctr_d = 20'd0;
    end
 
    always @(posedge clk) begin
        ctr_q <= ctr_d;
        sync_q <= sync_d;
    end
endmodule