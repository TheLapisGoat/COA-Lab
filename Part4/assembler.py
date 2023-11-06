import argparse
from numpy import binary_repr
import regex as re

opcodes = {
    "ADD": "000000",
    "SUB": "000000",
    "AND": "000000",
    "OR": "000000",
    "XOR": "000000",
    "NOT": "000000",
    "SLA": "000000",
    "SRL": "000000",
    "SRA": "000000",
    "ADDI": "000001",
    "SUBI": "000010",
    "ANDI": "000011",
    "ORI": "000100",
    "XORI": "000101",
    "NOTI": "000110",
    "SLLI": "000111",
    "SRLI": "001000",
    "SRAI": "001001",
    "LD": "001010",
    "ST": "001011",
    "LDSP": "001100",
    "STSP": "001101",
    "BR": "001110",
    "BMI": "001111",
    "BPL": "010000",
    "BZ": "010001",
    "PUSH": "010010",
    "POP": "010011",
    "CALL": "010100",
    "RET": "010101",
    "MOVE": "010110",
    "HALT": "100000",
    "NOP": "100001",
}

funct_codes = {
    "ADD": "100000",
    "SUB": "100010",
    "AND": "100100",
    "OR": "100101",
    "XOR": "100110",
    "NOT": "100111",
    "SLA": "000000",
    "SRL": "000010",
    "SRA": "000011",
}

registers = {
    "$R0": "00000",
    "$R1": "00001",
    "$R2": "00010",
    "$R3": "00011",
    "$R4": "00100",
    "$R5": "00101",
    "$R6": "00110",
    "$R7": "00111",
    "$R8": "01000",
    "$R9": "01001",
    "$R10": "01010",
    "$R11": "01011",
    "$R12": "01100",
    "$R13": "01101",
    "$R14": "01110",
    "$R15": "01111",
    "$R16": "10000",
    "$SP": "10000",
}

label_table = {}
data_table = {}

def generate_code_lines (input_file):
    processed_lines = []
    with open(input_file, 'r') as f:
        lines = f.readlines()
        lines = [line.strip() for line in lines]
        lines = [line for line in lines if line != '']
        for line in lines:
            if line[-1] == ':':
                processed_lines.append(line)
                continue
            else:
                args = line.split()
                op = args[0]
                if op == "LA":
                    processed_lines.append('MOVE' + ' ' + args[1] + ' ' + '$R0')
                    processed_lines.append('ADDI' + ' ' + args[1] + ' ' + str(data_table[args[2]]))
                else:
                    processed_lines.append(line)
    return processed_lines

def generate_label_table (lines):
    line_counter = 0
    for line in lines:
        if line[-1] == ':':
            label_table[line[:-1]] = line_counter
        else:
            line_counter += 1

def generate_data_file (input_file, output_file):
    data_memory = []
    byte_counter = 0
    with open(input_file, 'r') as f:
        lines = f.readlines()
        lines = [line.strip() for line in lines]
        lines = [line for line in lines if line != '']
        for line in lines:
            parts = line.split(":")
            data_table[parts[0]] = byte_counter
            data = parts[1].strip().split()
            data_type = data[0]
            if data_type == '.word':
                data = data[1:]
                for i in range(len(data) - 1):
                    data_memory.append(binary_repr(int(data[i][:-1]), 32))
                    byte_counter += 4
                data_memory.append(binary_repr(int(data[-1]), 32))
                byte_counter += 4
        
    with open(output_file, 'w') as f:
        for data in data_memory:
            f.write(data[0:8] + ' ' + data[8:16] + ' ' + data[16:24] + ' ' + data[24:32] + '\n')

def assemble (lines, output_file):
    line_counter = 0
    instructions = []
    for line in lines:
        if line[-1] == ':':
            continue
        else:
            args = line.split()
            op = args[0]
            
            if op in funct_codes.keys():
                funct = funct_codes[op]
                rd = registers[args[1][:-1]]
                rs = registers[args[2][:-1]]
                rt = registers[args[3]]
                instructions.append(opcodes[op] + rs + rt + rd + '00000' + funct)
            
            elif op in opcodes.keys():
                opcode = opcodes[op]
                if op == "ADDI" or op == "SUBI" or op == "ANDI" or op == "ORI" or op == "XORI" or op == "NOTI" or op == "SLLI" or op == "SRLI" or op == "SRAI":
                    rs = registers[args[1][:-1]]
                    imm = binary_repr(int(args[2]), 16)
                    instructions.append(opcode + rs + '00000' + imm)
                elif op == "LD" or op == "ST":
                    rt = registers[args[1][:-1]]
                    if re.match(r'[a-zA-Z]', args[2]):              #LD $Rx, label
                        rs = registers['$R0']
                        imm = binary_repr(data_table[args[2]], 16)
                    elif args[2][0] == '$':
                        rs = registers[args[2]]
                        imm = binary_repr(0, 16)
                    else:
                        imm = args[2].split('(')[0]
                        imm = binary_repr(int(imm), 16)
                        rs = registers[args[2].split('(')[1][:-1]]
                    instructions.append(opcode + rs + rt + imm)
                elif op == "LDSP" or op == "STSP":
                    rt = '10000'
                    if re.match(r'[a-zA-Z]', args[2]):              #LDSP $Rx, label
                        rs = registers['$R0']
                        imm = binary_repr(data_table[args[2]], 16)
                    elif args[2][0] == '$':
                        rs = registers[args[2]]
                        imm = binary_repr(0, 16)
                    else:
                        imm = args[2].split('(')[0]
                        imm = binary_repr(int(imm), 16)
                        rs = registers[args[2].split('(')[1][:-1]]
                    instructions.append(opcode + rs + rt + imm)
                elif op == "BR":
                    label_line = label_table[args[1]]
                    imm = binary_repr((label_line - line_counter) * 4, 16)
                    instructions.append(opcode + '00000' + '00000' + imm)
                elif op == "BMI" or op == "BPL" or op == "BZ":
                    rs = registers[args[1][:-1]]
                    label_line = label_table[args[2]]
                    imm = binary_repr((label_line - line_counter) * 4, 16)
                    instructions.append(opcode + rs + '00000' + imm)
                elif op == "PUSH" or op == "POP":
                    rt = registers[args[1]]
                    instructions.append(opcode + '00000' + rt + '0000000000000000')
                elif op == "CALL":
                    label_line = label_table[args[1]]
                    imm = binary_repr((label_line - line_counter) * 4, 16)
                    instructions.append(opcode + '00000' + '00000' + imm)
                elif op == "RET":
                    instructions.append(opcode + '00000' + '00000' + '0000000000000000')
                elif op == "MOVE":
                    rt = registers[args[1][:-1]]
                    rs = registers[args[2]]
                    instructions.append(opcode + rs + rt + '0000000000000000')
                elif op == "HALT":
                    instructions.append(opcode + '00000' + '00000' + '0000000000000000')
                else:
                    op = "NOP"
                    opcode = opcodes[op]
                    instructions.append(opcode + '00000' + '00000' + '0000000000000000')

            line_counter += 1

    with open(output_file, 'w') as f:
        for instruction in instructions:
            f.write(instruction[0:8] + ' ' + instruction[8:16] + ' ' + instruction[16:24] + ' ' + instruction[24:32] + '\n')


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--text', help='text segment file',
                        required=True, type=str)
    parser.add_argument('-d', '--data', help='data segment file',
                        required=True, type=str)
    parser.add_argument('-oi', '--output_i', help='output instruction file',
                        default='instruction_mem.b', type=str)
    parser.add_argument('-od', '--output_d', help='output data file',
                        default='data_mem.b', type=str)
    args = parser.parse_args()

    generate_data_file(args.data, args.output_d)
    lines = generate_code_lines(args.text)
    generate_label_table(lines)
    assemble(lines, args.output_i)