# PC值除了跳转外不用特意维护
from PC import PC
from DM import DM
from RegFile import RegFile
from Define import zeroEXTnum,sigEXTnum,zeroEXTnum_hex,sigEXTnum_hex,signed
import re

class ExCute:
    def __init__(self) -> None:
        raise SystemError("it's static class!!!")
    
    __begin = True
    
    @staticmethod
    def __slipt_code(code:str):
        return (i for i in re.split("[\s,()]",code) if i!="")
    @staticmethod
    def __delaying(enalble=True,link=False):
        if __name__=='__main__' : print("")
        if __name__!='__main__' and enalble :
            if link == False : PC.next()
            ExCute.run(PC.getInstruct())

    @staticmethod
    def __add(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        RegFile.write(rd,A+B)
    @staticmethod
    def __sub(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        RegFile.write(rd,A-B)
    @staticmethod
    def __and(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        RegFile.write(rd,A&B)
    @staticmethod
    def __or(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        RegFile.write(rd,A|B)
    @staticmethod
    def __nor(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        RegFile.write(rd,0xffffffff^(A|B))
    @staticmethod
    def __slt(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        ans = 1 if signed(A)<signed(B) else 0
        RegFile.write(rd,ans)
    @staticmethod
    def __sltu(source:str):
        rd,rs,rt=ExCute.__slipt_code(source)
        A,B=RegFile.read([rs,rt])
        ans = 1 if A<B else 0
        RegFile.write(rd,ans)
    @staticmethod
    def __sll(source:str):
        rd,rt,shamet=ExCute.__slipt_code(source)
        B=RegFile.read(rt)
        A=zeroEXTnum_hex(shamet)%32
        RegFile.write(rd,B<<A)
    @staticmethod
    def __srl(source:str):
        rd,rt,shamet=ExCute.__slipt_code(source)
        B=RegFile.read(rt)
        A=zeroEXTnum_hex(shamet)%32
        RegFile.write(rd,B>>A)
    @staticmethod
    def __jr(source:str):
        rs = source.strip()
        nPC = RegFile.read(rs)
        # 延迟槽
        ExCute.__delaying()

        PC.next(nPC)
    
    @staticmethod
    def __addi(source:str):
        rt,rs,imm=ExCute.__slipt_code(source)
        A=RegFile.read(rs)
        B=sigEXTnum_hex(imm,4)
        RegFile.write(rt,A+B)
    @staticmethod
    def __slti(source:str):
        rt,rs,imm=ExCute.__slipt_code(source)
        A=RegFile.read(rs)
        B=sigEXTnum_hex(imm,4)
        ans = 1 if signed(A)<signed(B) else 0
        RegFile.write(rt,ans)
    @staticmethod
    def __sltiu(source:str):
        rt,rs,imm=ExCute.__slipt_code(source)
        A=RegFile.read(rs)
        B=sigEXTnum_hex(imm,4)
        ans = 1 if A<B else 0
        RegFile.write(rt,ans)
    @staticmethod
    def __ori(source:str):
        rt,rs,imm=ExCute.__slipt_code(source)
        A=RegFile.read(rs)
        B=zeroEXTnum_hex(imm)
        RegFile.write(rt,A|B)
    @staticmethod
    def __lw(source:str):
        rt,imm,rs=ExCute.__slipt_code(source)
        addr=RegFile.read(rs)+sigEXTnum_hex(imm,4)
        RegFile.write(rt,DM.read(addr))
    @staticmethod
    def __sw(source:str):
        rt,imm,rs=ExCute.__slipt_code(source)
        addr=RegFile.read(rs)+sigEXTnum_hex(imm,4)
        DM.write(addr,RegFile.read(rt))
    @staticmethod
    def __beq(source:str):
        rt,rs,offset=ExCute.__slipt_code(source)
        offset = sigEXTnum_hex(offset,4)<<2
        nPC = PC._value+4+offset
        if RegFile.read(rs) == RegFile.read(rt):
            # 延迟槽
            ExCute.__delaying()
            
            PC.next(nPC)
        else :
            PC.next()
    @staticmethod
    def __bne(source:str):
        rt,rs,offset=ExCute.__slipt_code(source)
        offset = sigEXTnum_hex(offset,4)<<2
        nPC = PC._value+4+offset
        if RegFile.read(rs) != RegFile.read(rt):
            # 延迟槽
            ExCute.__delaying()
            
            PC.next(nPC)
        else :
            PC.next() 
    @staticmethod
    def __lui(source:str):
        rt,imm=ExCute.__slipt_code(source)
        imm = zeroEXTnum_hex(imm)<<16
        RegFile.write(rt,imm)
    
    @staticmethod
    def __j(source:str):
        instr_index = source.strip()
        instr_index = zeroEXTnum_hex(instr_index)<<2
        instr_index |= (PC._value&0xc0000000)
        # 延迟槽
        ExCute.__delaying()
            
        PC.next(instr_index)
    @staticmethod
    def __jal(source:str):
        instr_index = source.strip()
        instr_index = zeroEXTnum_hex(instr_index)<<2
        instr_index |= (PC._value&0xc0000000)
        RegFile.write("$ra",PC._value+8)
        # 延迟槽
        ExCute.__delaying(link=True)
            
        PC.next(instr_index)

    __OP_TO_FUNCTION = {
        "add"   : __add ,
        "sub"   : __sub ,
        "and"   : __and ,
        "or"    : __or ,
        "nor"   : __nor ,
        "slt"   : __slt ,
        "sltu"  : __sltu ,
        "sll"   : __sll ,
        "srl"   : __srl ,
        "jr"    : __jr ,
        "addi"  : __addi ,
        "lw"    : __lw ,
        "sw"    : __sw ,
        "beq"   : __beq ,
        "bne"   : __bne ,
        "slti"  : __slti ,
        "sltiu" : __sltiu ,
        "lui"   : __lui ,
        "ori"   : __ori,
        "j"     : __j ,
        "jal"   : __jal,
    } 


    @staticmethod
    def run(codes:str|list):
        if type(codes) is list:
            for code in codes:
                debuginf = PC.getMachineCOde()+"\t"+PC.getInstruct()
                print(format(debuginf,"<40"),end='')
                if code == "nop" :
                    PC.next()
                    continue
                op,source = re.split("\s",code,1)
                ExCute.__OP_TO_FUNCTION[op](source)
        elif type(codes) is str:
            debuginf = PC.getMachineCOde()+"\t"+PC.getInstruct()
            print(format(debuginf,"<40"),end="")
            if codes == "nop":
                PC.next()
            else:
                op,source = re.split("\s",codes,1)
                ExCute.__OP_TO_FUNCTION[op](source)


if __name__ == "__main__" :
    while True:
        cin=input()
        if cin == "":
            continue
        if cin.find("exit") != -1:
            break
        PC.loadInstruct(cin)
        ExCute.run(PC.getInstruct())
        while PC._endsignal != True :
            ExCute.run(PC.getInstruct())