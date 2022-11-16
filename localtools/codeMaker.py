from instruction import *
import random

def writeFile(filePath, str):
    with open(filePath, "w") as f:
        f.write(str)


def readFile(filePath):
    with open(filePath, "r") as f:
        return f.readlines()


def writeCode(codePath, instrList):
    codeText = "\n".join([f"{instr:0>8x}" for instr in instrList])
    writeFile(codePath, codeText)
    print(codeText)


def randReg(regs):
    return regs[random.randint(0, len(regs) - 1)]


def randRam(rams):
    return rams[random.randint(0, len(rams) - 1)]


def randImm16():
    return random.randint(0, (1 << 16) - 1)


def fullReg(reg):
    instrList = []
    instrList.append(lui(reg, randImm16()))
    instrList.append(ori(reg, 0, randImm16()))
    return instrList
    

def fullRegs(regs):
    instrList = []
    for reg in regs:
        instrList.append(fullReg(reg))
    return instrList


def clearRegs(regs):
    instrList = []
    for reg in regs:
        instrList.append(ori(reg, 0, 0))
    return instrList


def fullRam(reg, ram):
    instrList = []
    instrList.append(fullReg(reg))
    instrList.append(sw(reg, ram, 0))
    return instrList


def fullRams(reg, rams):
    instrList = []
    for ram in rams:
        instrList.append(fullRam(reg, ram))
    return instrList

def clearRams(rams):
    instrList = []
    for ram in rams:
        instrList.append(fullRam(0, ram))
    return instrList


def randAdd(regs):
    return add(randReg(regs), randReg(regs), randReg(regs))


def randSub(regs):
    return sub(randReg(regs), randReg(regs), randReg(regs))


def testALU(regs):
    instrList = []
    len = 20
    for _ in range(len):
        if(random.randint(0, 1)):
            instrList.append(randAdd(regs))
        else:
            instrList.append(randSub(regs))


def testSaveAndLoad(regs, rams):
    instrList = []
    len = 20
    for _ in range(len):
        if(random.randint(0, 1)):
            instrList.append(lw(randReg(regs), randRam(rams), 0))
        else:
            instrList.append(sw(randReg(regs), randRam(rams), 0))
    return instrList


def testBranch():
    instrList = []
    return instrList


def testJump():
    instrList = []
    return instrList


def testForward(regs):
    instrList = []
    # tUse = 0: beq, jr
    # tUse = 1: add, sub, lw, sw
    # tUse = 2: sw
    # noUse   : ori, lui

    # tNew = 0: lui, jal
    # tNew = 1: add, sub, ori
    # tNew = 2: lw
    # noNew   : beq, jr
    return instrList



def makeCode():
    instrList = []
    regs = list(range(8, 28))
    rams = [4 * addr for addr in range(16)]
    
    instrList += fullRegs(regs)
    instrList += testALU(regs)
    instrList += clearRegs(regs)


    
    instrList += fullRegs(regs)
    instrList += fullRams(8, rams)
    instrList += testSaveAndLoad(regs, rams)
    instrList += clearRegs(regs)
    instrList += clearRams(rams)


code = makeCode()
codePath = "../P5/data/code.txt"
writeCode(codePath, code)
