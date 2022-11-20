from Instruction import *
import random

def writeFile(filePath, str):
    with open(filePath, "w") as f:
        f.write(str)

def readFile(filePath):
    with open(filePath, "r") as f:
        return f.readlines()

def writeCode(instrList):
    codeText = "\n".join([f"{instr:0>8x}" for instr in instrList])
    print(codeText)

def randReg(regs):
    return regs[random.randint(0, len(regs) - 1)]

def randRam(rams):
    return rams[random.randint(0, len(rams) - 1)]

def randImm16():
    return random.randint(0, (1 << 16) - 1)

def randAdd(regs):
    return add(randReg(regs), randReg(regs), randReg(regs))

def randSub(regs):
    return sub(randReg(regs), randReg(regs), randReg(regs))

def randOri(regs):
    return ori(randReg(regs), randReg(regs), randImm16())

def randLui(regs):
    return lui(randReg(regs), randImm16())

def fullReg(reg):
    instrList = []
    instrList += [lui(reg, randImm16())]
    instrList += [ori(reg, reg, randImm16())]
    return instrList
    
def fullRegs(regs):
    instrList = []
    for reg in regs:
        instrList += fullReg(reg)
    return instrList

def clearRegs(regs):
    instrList = []
    for reg in regs:
        instrList += [ori(reg, 0, 0)]
    return instrList

def fullRam(reg, ram):
    instrList = []
    instrList += fullReg(reg)
    instrList += [sw(reg, ram, 0)]
    return instrList

def fullRams(regs, rams):
    instrList = []
    for ram in rams:
        instrList += fullRam(randReg(regs), ram)
    return instrList

def clearRams(rams):
    instrList = []
    for ram in rams:
        instrList += fullRam(0, ram)
    return instrList

def makeRegEqual(reg1, reg2):
    instrList = []
    opt = random.randint(0, 1)
    if(opt == 0):
        instrList.append(ori(reg2, reg1, 0))
    else:
        high = randImm16()
        low  = randImm16()
        instrList += [lui(reg1, high)]
        instrList += [ori(reg1, 0, low)]
        instrList += [lui(reg2, high)]
        instrList += [ori(reg2, 0, low)]
    return instrList

def randBranchDelayInstr(regs):
    # add, sub, lui, ori, nop
    instrList = []
    opt = random.randint(0, 5)
    if(opt == 0):
        instrList += [randAdd(regs)]
    elif(opt == 1):
        instrList += [randSub(regs)]
    elif(opt == 2):
        instrList += [randLui(regs)]
    elif(opt == 3):
        instrList += [randOri(regs)]
    else:
        instrList += [nop()]
    return instrList

def testALU(regs):
    # add, sub, ori, lui
    instrList = []
    instrList += fullRegs(regs)
    testTimes = 20
    for _ in range(testTimes):
        opt = random.randint(0, 3)
        if(opt == 0):
            instrList += [randAdd(regs)]
        elif(opt == 1):
            instrList += [randSub(regs)]
        elif(opt == 2):
            instrList += [randOri(regs)]
        else:
            instrList += [randLui(regs)]
    return instrList

def testSaveAndLoad(regs, rams):
    # sw, lw
    instrList = []
    instrList += fullRegs(regs)
    instrList += fullRams(regs, rams)
    testTimes = 20
    for _ in range(testTimes):
        opt = random.randint(0, 1)
        if(opt == 0):
            instrList += [lw(randReg(regs), randRam(rams), 0)]
        else:
            instrList += [sw(randReg(regs), randRam(rams), 0)]
    return instrList

def testBranch(regs):
    # beq
    instrList = []
    testTimes = 20
    for _ in range(testTimes):
        opt = random.randint(0, 1)
        if(opt == 0):
            reg1 = randReg(regs)
            reg2 = randReg(regs)
            offset = random.randint(1, 5)
            instrList += [beq(reg1, reg2, offset)]
            instrList += [ori(reg1, 0, 1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
        else:
            reg1 = randReg(regs)
            reg2 = randReg(regs)
            offset = random.randint(1, 5)
            instrList += makeRegEqual(reg1, reg2)
            instrList += [beq(reg1, reg2, offset)]
            instrList += [ori(reg1, 0, 1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
            instrList += [add(reg1, reg1, reg1)]
    return instrList

def testJal(regs, offsetBefore):
    instrList = []
    reg  = randReg(regs)
    reg1 = randReg(regs)
    offsetnow = offsetBefore + len(instrList) + 1
    offset = offsetnow + random.randint(1, 5)
    instrList += [jal(0x3000 // 4 + offset)]
    instrList += randBranchDelayInstr(regs)
    instrList += [ori(reg1, 0, 1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    return instrList

def testJr(regs, offsetBefore, reg=-1):
    instrList = []
    if(reg == - 1):
        reg  = randReg(regs)
        offsetnow = offsetBefore + len(instrList) + 1 + 2
        offset = offsetnow + random.randint(1, 5)
        pc = 0x3000 + (offset << 2)
        instrList += [lui(reg, pc >> 16)]
        instrList += [ori(reg, 0, pc % (1 << 16))]
    reg1 = randReg(regs)
    instrList += [jr(reg)]
    instrList += randBranchDelayInstr(regs)
    instrList += [ori(reg1, 0, 1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    instrList += [add(reg1, reg1, reg1)]
    return instrList

def testJump(regs, offsetBefore):
    # jal, jr
    instrList = []
    testTimes = 20
    for _ in range(testTimes):
        opt = random.randint(0, 1)
        if(opt == 0):
            instrList += testJal(regs, offsetBefore + len(instrList))
        else:
            instrList += testJr(regs, offsetBefore + len(instrList))
    return instrList

def instrNew0(regs, rams, offsetBefore, reg):
    # lui, jal
    instrList = []
    opt = random.randint(0, 2)
    if(opt == 0):
        instrList += [lui(reg, randImm16())]
    else:
        offset = offsetBefore + len(instrList) + 1 + 1
        instrList += [jal(0x3000 // 4 + offset)]
    return instrList

def instrNew1(regs, rams, offsetBefore, reg):
    instrList = []
    opt = random.randint(0, 3)
    if(opt == 0):
        instrList += [add(reg, randReg(regs), randReg(regs))]
    elif(opt == 1):
        instrList += [sub(reg, randReg(regs), randReg(regs))]
    else:
        instrList += [ori(reg, randReg(regs), randImm16())]
    return instrList

def instrNew2(regs, rams, offsetBefore, reg):
    # lw
    instrList = []
    instrList += [lw(reg, randRam(rams), 0)]
    return instrList

def testForward(regs, rams, offsetBefore):
    instrList = []
    # tUse = 0: beq, jr
    # tUse = 1: add, sub, lw, sw
    # tUse = 2: sw
    # noUse   : ori, lui
    testTimes = 5
    for _ in range(testTimes):
        reg = 31
        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(31, randRam(rams), 0)]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(31, randRam(rams), 0)]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(31, randRam(rams), 0)]

        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), reg, randReg(regs))]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), reg, randReg(regs))]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), reg, randReg(regs))]
        
        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), randReg(regs), reg)]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), randReg(regs), reg)]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [add(randReg(regs), randReg(regs), reg)]

        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), reg, randReg(regs))]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), reg, randReg(regs))]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), reg, randReg(regs))]
        
        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), randReg(regs), reg)]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), randReg(regs), reg)]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sub(randReg(regs), randReg(regs), reg)]
        
        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [ori(randReg(regs), reg, randImm16())]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [ori(randReg(regs), reg, randImm16())]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [ori(randReg(regs), reg, randImm16())]

        instrList += instrNew0(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(reg, randRam(rams), 0)]
        instrList += instrNew1(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(reg, randRam(rams), 0)]
        instrList += instrNew2(regs, rams, offsetBefore + len(instrList), 31)
        instrList += [sw(reg, randRam(rams), 0)]

    return instrList

def makeCode():
    instrList = []
    regs = list(range(8, 28))
    rams = [4 * addr for addr in range(16)]
    
    instrList += testALU(regs)
    
    instrList += fullRegs(regs)
    instrList += fullRams(regs, rams)
    instrList += testSaveAndLoad(regs, rams)
     


    instrList += fullRegs(regs)
    instrList += testBranch(regs)
    instrList += clearRams(rams)

    instrList += testJump(regs, len(instrList))
    instrList += testForward(regs, rams, len(instrList))

    return instrList

if __name__ == "__main__":
    code = makeCode()
    writeCode(code)