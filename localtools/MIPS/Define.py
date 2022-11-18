
def reverse_dict(d):
    return {v: k for k, v in d.items()}


index_to_reg = {
    "00000" : "$0",  # 0
    "00001" : "$at",  # 由编译器生成的复合指令使用
    "00010" : "$v0",  # 计算结果和表达式求值
    "00011" : "$v1",
    "00100" : "$a0",  # 参数
    "00101" : "$a1",
    "00110" : "$a2",
    "00111" : "$a3",
    "01000" : "$t0",  # 临时变量
    "01001" : "$t1",
    "01010" : "$t2",
    "01011" : "$t3",
    "01100" : "$t4",
    "01101" : "$t5",
    "01110" : "$t6",
    "01111" : "$t7",
    "10000" : "$s0",  # 保留寄存器
    "10001" : "$s1",
    "10010" : "$s2",
    "10011" : "$s3",
    "10100" : "$s4",
    "10101" : "$s5",
    "10110" : "$s6",
    "10111" : "$s7",  # 更多临时变量
    "11000" : "$t8",
    "11001" : "$t9",
    "11010" : "$k0",
    "11011" : "$k1",
    "11100" : "$gp",  # 全局指针
    "11101" : "$sp",  # 栈指针
    "11110" : "$fp",  # 帧指针
    "11111" : "$ra",  # 返回地址
}

reg_to_index = reverse_dict(index_to_reg)

R_index_to_inst = {
    "100000" : "add",
    "100010" : "sub",
    "100100" : "and",
    "100101" : "or",
    "100111" : "nor",
    "101010" : "slt",
    "101011" : "sltu",
    "000000" : "sll",
    "000010" : "srl",
    "001000" : "jr",
    "000000" : "nop",
}

R_inst_to_index = reverse_dict(R_index_to_inst)

#signal registers that used
R_format = {
    "add"   : 0b111,
    "sub"   : 0b111,
    "and"   : 0b111,
    "or"    : 0b111,
    "nor"   : 0b111,
    "slt"   : 0b111,
    "sltu"  : 0b111,
    "sll"   : 0b011,
    "srl"   : 0b011,
    "jr"    : 0b100,
    "nop"   : 0b000,
}


I_index_to_inst = {
    "001000" : "addi",
    "100011" : "lw",
    "101011" : "sw",
    "000100" : "beq",
    "000101" : "bne",
    "001010" : "slti",
    "001011" : "sltiu",
    "001111" : "lui",
    "001101" : "ori",
}

I_inst_to_index = reverse_dict(I_index_to_inst)

I_format = {
    "addi"  : "cal" ,
    "lw"    : "load" ,
    "sw"    : "store" ,
    "beq"   : "branch" ,
    "bne"   : "branch" ,
    "slti"  : "cal" ,
    "sltiu" : "cal" ,
    "lui"   : "imm" ,
    "ori"   : "cal",
}

J_index_to_inst = {"000010" : "j", "000011" : "jal"}

J_inst_to_index = reverse_dict(J_index_to_inst)


def zeroEXTnum(binstrnum) :
    return int(binstrnum,2)

def sigEXTnum(binstrnum,orilength="",exlength=32) :
    if orilength == "":
        differ = exlength - len(binstrnum)
    else :
        temp = exlength -len(binstrnum)
        differ = exlength - orilength
        differ = temp if temp < differ else differ 
    if differ < 0 :
        raise SystemError ("the length of num"+binstrnum+f"beyond {exlength:d}")
    else :
        sign = "1" if binstrnum[0] == 1 and (orilength=="" or len(binstrnum)>=orilength) else "0"
        return int((binstrnum[0]*differ)+binstrnum,2)

def zeroEXTnum_hex(hexstrnum) :
    return int(hexstrnum,16)

def sigEXTnum_hex(hexstrnum:str,orilength="",exlength=8) :
    if hexstrnum[:2] == "0x" :
        hexstrnum = hexstrnum[2:]
    if orilength == "":
        differ = exlength - len(hexstrnum)
    else :
        temp = exlength -len(hexstrnum)
        differ = exlength - orilength
        differ = temp if temp < differ else differ
    if differ < 0:
        raise SystemError("the length of num"+hexstrnum+f"beyond {exlength:d}")
    else :
        sign = "f" if hexstrnum[0] >= "8" and (orilength=="" or len(hexstrnum)>=orilength) else "0"
        return int(sign*differ+hexstrnum,16)

def signed(num:int):
    if num&0x800000000!=0 :
        return ~num+1
    else:
        return num

def arithmetic_right_shift(num:int,shift:int):
    shift %= 32
    sign =0x100000000 if num & 0x80000000 != 0 else 0
    return (num>>shift)|((sign-1)^((sign>>shift)-1))
