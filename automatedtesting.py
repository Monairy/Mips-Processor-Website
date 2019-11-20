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
            with open('_FromRegFile.txt','r') as regfile:
             regcontent=regfile.readlines()
             with open('testcases/Register_Output/'+filename) as testcaseregfile:
                CorrectReg=testcaseregfile.readlines()
                for i in range (0,len(regcontent)):
                     if (regcontent[i]!=CorrectReg[i]):
                         print "[*]"+colored("Error in line # "+str(i),'white',"on_red")
                         print  colored(regcontent[i].split('\n')[0],'red')
                         print "vs"
                         print colored(CorrectReg[i].split('\n')[0],'green')
        mem_compare=filecmp.cmp('_FromDataMem.txt','testcases/DataMem_Output/'+filename) # compare datamemory files
        if (str(mem_compare)=="True"):
            print "[-] testcase " + filename + colored(" DataMem",'cyan')+ " contents" + colored(' succeeded','green')
        else:
            print "[-] testcase " + filename + colored(" DataMem",'cyan')+ " contents"+ colored(' failed','red')
            with open('_FromDataMem.txt','r') as datamemfile:
               datacontent=datamemfile.readlines()
               with open('testcases/DataMem_Output/'+filename) as testcasedatafile:
                  CorrectData=testcasedatafile.readlines()
                  for x in range (0,len(CorrectData)):
                     if (datacontent[x]!=CorrectData[x]):
                         print "[*]"+colored("Error in line # "+str(x),'white',"on_red")
                         print  colored(datacontent[x].split('\n')[0],'red')
                         print "vs"
                         print colored(CorrectData[x].split('\n')[0],'green')

        print colored("=========================================================",'white','on_yellow')                 
