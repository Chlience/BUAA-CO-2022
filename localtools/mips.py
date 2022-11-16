
def writeFile(filePath, str):
    with open(filePath, "w") as f:
        f.write(str)


def readFile(filePath):
    with open(filePath, "r") as f:
        return f.readlines()

codePath = "../P5/data/code.txt"
codeText = readFile(codePath)
