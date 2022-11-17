import sys


def readFile(filepath):
    with open(filepath, "r") as f:
        return f.readlines()


if __name__ == '__main__':
    codePath = sys.argv[1]
    code = readFile(codePath)