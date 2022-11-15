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