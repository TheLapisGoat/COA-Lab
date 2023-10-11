`timescale 1ns/1ps

module testbench_ALU;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] funct;

    wire [31:0] out;
    wire flagZ;
    wire flagS;

    ALU my_ALU (
      .A(A),
      .B(B),
      .funct(funct),
      .out(out),
      .flagZ(flagZ)
      .flagS(flagS)
    );

    reg clock = 0;
    always begin
      #5 clock = ~clock;
    end

    initial begin
        // Test case 1: ADD operation
        $display("Test case 1: ADD operation (A = 5, B = 7)");
        A = 5;
        B = 7;
        funct = 4'b0000; // ADD
        #10;
        $display("out = %d", out);

        // Test case 2: XOR operation
        $display("Test case 2: XOR operation (A = 12, B = 7)");
        A = 12;
        B = 7;
        funct = 4'b0100; // XOR
        #10;
        $display("out = %d", out);

        // Test case 3: Shift Left Arithmetic (SLA)
      $display("Test case 3: Shift Left Arithmetic (SLA) (A = 16, B = 1)");
        A = 16;
        B = 1;
        funct = 4'b0110; // SLA
        #10;
        $display("out = %d", out);

        // Test case 4: Subtract operation with negative result
        $display("Test case 4: Subtract operation with negative result (A = -10, B = 5)");
        A = -10;
        B = 5;
        funct = 4'b0001; // SUB
        #10;
        $display("out = %b", out);

        // Test case 5: Logical AND operation
        $display("Test case 5: Logical AND operation (A = 0'b10101010101010101010101010101010, B = 0'b11001100110011001100110011001100)");
        A = 0'b10101010101010101010101010101010;
        B = 0'b11001100110011001100110011001100;
        funct = 4'b0010; // AND
        #10;
        $display("out = %b", out);

        // Test case 6: Logical OR operation
        $display("Test case 6: Logical OR operation (A = 0'b10101010101010101010101010101010, B = 0'b11001100110011001100110011001100)");
        A = 0'b10101010101010101010101010101010;
        B = 0'b11001100110011001100110011001100;
        funct = 4'b0011; // OR
        #10;
        $display("out = %b", out);

        // Test case 7: Arithmetic right shift (SRA) with sign extension
        $display("Test case 7: Arithmetic right shift (SRA) with sign extension (A = -12, B = 1)");
        A = -12;
        B = 1;
        funct = 4'b0111; // SRA
        #10;
        $display("out = %b", out);

        // Test case 8: Logical right shift (SRL) with zero fill
        $display("Test case 8: Logical right shift (SRL) with zero fill (A = 0'b10101010101010101010101010101010, B = 1)");
        A = 0'b10101010101010101010101010101010;
        B = 1;
        funct = 4'b1000; // SRL
        #10;
        $display("out = %b", out);

        // Test case 9: Zero result
        $display("Test case 9: Zero result using XOR (A = 15, B = 15)");
        A = 15;
        B = 15;
        funct = 4'b0100; // XOR
        #10;
        $display("out = %d, flagZ = %d, flagS = %d", out, flagZ, flagS);

        $finish;
    end

    always begin
        #2 clock = ~clock;
    end
endmodule