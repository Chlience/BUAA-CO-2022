from instruction import *

def writeFile(filePath, str):
    with open(filePath, "w") as f:
        f.write(str)


def readFile(filePath):
    with open(filePath, "r") as f:
        return f.readlines()

instrList = []
instrList.append(ori(1, 0, 0b1))
instrList.append(add(1, 1, 1))
instrList.append(add(1, 1, 1))
instrList.append(add(1, 1, 1))
instrList.append(add(1, 1, 1))

codePath = "../P5/data/code.txt"
codeText = "\n".join([f"{instr:0>8x}" for instr in instrList])
writeFile(codePath, codeText)
print(codeText)