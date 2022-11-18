from PC import PC
from Define import *
class RegFile:

    __reg = [0]*32

    def __init__(self) -> None:
        raise SystemError("it's static class!!!")

    #ToDo:保留，用来初始化一些mars中有值的寄存器
    @classmethod
    def mipsInitial(cls):
        pass

    @classmethod
    def write(cls,addr_list,data_list):
        if(type(addr_list)!=list):
            addr = zeroEXTnum(reg_to_index[addr_list])
            if addr>0 and addr<32:
                cls.__reg[addr] = data_list&0xffffffff
                print(f"@{PC._value:0>8x}: ${addr:2d} <= {cls.__reg[addr]:0>8x}",end="")
            elif addr != 0 :
                raise SystemError(f"reg file Waddr {addr:2d} out of 0-31")
        else :
            for addrstr,data in zip(addr_list,data_list):
                addr = zeroEXTnum(reg_to_index[addrstr])
                if addr>0 and addr<32:
                    cls.__reg[addr] = data&0xffffffff
                    print(f"@{PC._value:0>8x}: ${addr:2d} <= {cls.__reg[addr]:0>8x}",end="")
                elif addr != 0 :
                    raise SystemError(f"reg file Waddr {addr:2d} out of 0-31")
        
        PC.next()
    
    @classmethod
    def read(cls,addr_list):
        if type(addr_list) is str:
            return cls.__reg[zeroEXTnum(reg_to_index[addr_list])]
        elif type(addr_list) is list:
            return (cls.__reg[zeroEXTnum(reg_to_index[addrstr])] for addrstr in addr_list)