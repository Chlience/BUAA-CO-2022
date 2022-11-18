import sys
from PC import PC
from DisAssembler import DisAssembler
from Excute import ExCute
from RegOrder import RegOrder

def readFile(filepath):
    with open(filepath, "r") as f:
        return f.readlines()

if __name__ == '__main__':
    codePath = sys.argv[1]
    code = readFile(codePath)
    PC.loadInstruct(code)
    while PC._endsignal!=True :
        ExCute.run(PC.getInstruct())