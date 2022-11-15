from instruction import *

def writeFile(filePath, str):
    with open(filePath, "w") as f:
        f.write(str)


def readFile(filePath):
    with open(filePath, "r") as f:
        return f.readlines()

instrList = []
instrList.append(ori(1, 0, 0b1))
instrList.append(beq(1, 0, 2))
instrList.append(nop())
instrList.append(nop())
instrList.append(nop())
instrList.append(nop())
instrList.append(beq(0, 0, 4))
instrList.append(nop())
instrList.append(nop())
instrList.append(nop())
instrList.append(nop())

codePath = "../P5/data/code.txt"
codeText = "\n".join([f"{instr:0>8x}" for instr in instrList])
writeFile(codePath, codeText)
print(codeText)