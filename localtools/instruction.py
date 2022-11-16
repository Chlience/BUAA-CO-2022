def nop():
    binString = f"{0:0>32b}"
    return int(binString, 2)

def ori(rt, rs, immdiate):
    OPTION1 = 0b001101
    binString = f"{OPTION1:0>6b}{rs:0>5b}{rt:0>5b}{immdiate:0>16b}"
    return int(binString, 2)

def add(rd, rs, rt):
    OPTION1 = 0b000000
    OPTION2 = 0b100000
    binString = f"{OPTION1:0>6b}{rs:0>5b}{rt:0>5b}{rd:0>5b}{0:0>5b}{OPTION2:0>6b}"
    return int(binString, 2)

def sub(rd, rs, rt):
    OPTION1 = 0b000000
    OPTION2 = 0b100010
    binString = f"{OPTION1:0>6b}{rs:0>5b}{rt:0>5b}{rd:0>5b}{0:0>5b}{OPTION2:0>6b}"
    return int(binString, 2)

def lw(rt, offset, base):
    OPTION1 = 0b100011
    binString = f"{OPTION1:0>6b}{base:0>5b}{rt:0>5b}{offset:0>16b}"
    return int(binString, 2)

def sw(rt, offset, base):
    OPTION1 = 0b101011
    binString = f"{OPTION1:0>6b}{base:0>5b}{rt:0>5b}{offset:0>16b}"
    return int(binString, 2)

def beq(rs, rt, offset):
    OPTION1 = 0b000100
    binString = f"{OPTION1:0>6b}{rs:0>5b}{rt:0>5b}{offset:0>16b}"
    return int(binString, 2)

def jal(instr_index):
    OPTION1 = 0b000011
    binString = f"{OPTION1:0>6b}{instr_index:0>26b}"
    return int(binString, 2)

def jr(rs):
    OPTION1 = 0b000000
    OPTION2 = 0b001000
    binString = f"{OPTION1:0>6b}{rs:0>5b}{0:0>15b}{OPTION2:0>6b}"
    return int(binString, 2)

def lui(rt, immediate):
    OPTION1 = 0b001111
    binString = f"{OPTION1:0>6b}{0:0>5b}{rt:0>5b}{immediate:0>16b}"
    return int(binString, 2)