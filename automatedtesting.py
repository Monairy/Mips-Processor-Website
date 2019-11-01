from os import listdir,path,system
import os
import subprocess
import filecmp
from termcolor import colored


testcases='testcases/'
InputToAssembler='assembly.txt'

for filename in listdir(testcases): #get all contents of testcases folder
    allpaths = path.join(testcases, filename)
    if path.isdir(allpaths): #skip folders in testcases folder
        continue

    with open (testcases + filename,'r') as testcase: #read each testcase 
        contents=testcase.read()
        with open (InputToAssembler,'w') as assembly: #make testcase as input to assembler
             assembly.write(contents)
        system('python assembler.py > null.txt') #run assembler for current testcase
        os.system("script.bat > null.txt") #run processor
        
        reg_compare=filecmp.cmp('_FromRegFile.txt','testcases/Register_Output/'+filename) #compare reg files
        if (str(reg_compare)=="True"):
            print "[+] testcase " + filename + colored(" RegFile",'yellow')+ " contents" + colored(' succeeded','green')
        else:
            print "[+] testcase " + filename + colored(" RegFile",'yellow')+ " contents"+ colored(' failed','red')
            
        mem_compare=filecmp.cmp('_FromRegFile.txt','testcases/DataMem_Output/'+filename) # compare datamemory files
        if (str(mem_compare)=="True"):
            print "[-] testcase " + filename + colored(" DataMem",'cyan')+ " contents" + colored(' succeeded','green')
        else:
            print "[-] testcase " + filename + colored(" DataMem",'cyan')+ " contents"+ colored(' failed','red')

