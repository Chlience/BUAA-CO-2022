import sys
import re

def readFileLine(file,linenum):
    while True:
        linenum += 1
        line = file.readline()
        if line == "" :
            return False,"",""
        else :
            searchans = re.search(r"@\s*([0-9a-f]*)\s*:\s*([*$])\s*([0-9a-f]*)\s*<=\s*([0-9a-f]*)",line,re.I)
            if searchans != None :
                parts = searchans.groups()
                if all(i!="" for i in parts) :
                    return line,linenum,parts

if __name__=='__main__':
    if len(sys.argv)<3 :
        print("we need two files!!!")
        exit()
    stdandpath = sys.argv[1]
    checkpath = sys.argv[2]


    with open(stdandpath,"r") as stdand :
        with open(checkpath,"r") as check :
            stdline = 0
            checkline = 0
            while True:
                stdori,stdline,stdans = readFileLine(stdand,stdline)
                cheori,checkline,cheans = readFileLine(check,checkline)
                if cheori == False and stdori == False :
                    print ("stadandard file read over")
                    print ("sample file read over")
                    break
                elif cheori == False :
                    print ("sample file read over")
                    print ("[Waring]:\n\t\tthe sample file output too few")
                    break
                elif stdori == False :
                    print ("stadandard file read over")
                    print ("[Warning]:\n\t\tthe sample file output too much")
                    break
                if stdans != cheans :
                    if stdans[1] != cheans[1]:
                        tempstdori,tempstdline,tempstd = readFileLine(stdand,stdline)
                        if tempstdori == False:
                            print (f"[Error  stdandredLine={stdline} sampleLine={checkline}]\nstdans:{stdori}\nsample\t{cheori}")
                            exit()
                        tempcheori,tempcheline,tempche = readFileLine(check,checkline)
                        if tempcheori == False:
                            print (f"[Error  stdandredLine={stdline} sampleLine={checkline}]\nstdans:{stdori}\nsample\t{cheori}")
                            exit()
                        if stdans==tempche and tempstd==cheans :
                            stdline = tempstdline
                            checkline = tempcheline
                        else :
                            print (f"[Error  stdandredLine={stdline} sampleLine={tempcheline}]\nstdans:\t{stdori}\nsample\t{tempcheori}")
                            exit()
                    else:
                        print (f"[Error  stdandredLine={stdline} sampleLine={checkline}]\nstdans:{stdori}\nsample\t{cheori}")
                        exit()

    print("\t\t>>>the same<<<")
