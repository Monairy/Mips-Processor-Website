R_Instuctions=['add','sub','and','or','sll','jr']
R_Funct={'add':'100000','sub':'100010','and':'100100','or':'100101','sll':'000000','jr':'001000'}
Registers = {'$zero':'00000','$at':'00001','$v0':'00010','$v1':'00011','$a0':'00100','$a1':'00101','$a2':'00110','$a3':'00111',
             '$t0':'01000','$t1':'01001','$t2':'01010','$t3':'01011','$t4':'01100','$t5':'01101','$t6':'01110','$t7':'01111',
             '$s0':'10000','$s1':'10001','$s2':'10010','$s3':'10011','$s4':'10100','$s5':'10101','$s6':'10110','$s7':'10111',
             '$t8':'11000','$t9':'11001','$k0':'11010','$k1':'11011','$gp':'11100','$sp':'11101','$fp':'11110','$ra':'11111'}

def is_Rtype(instruction):
   for i in R_Instuctions: 
    if (i==instruction.split(' ')[0]):
      if (i=='sll' or i=='jr'):
        return 'extremes'
      else:
        return 1

def decimalToBinary(n): 
    binary=bin(n).replace("0b", "")
    if (len(binary)==1):
       binary = '0000'+ binary
    if (len(binary)==2):
        binary = '000'+ binary
    if (len(binary)==3):
        binary = '00'+ binary
    if (len(binary)==4):
        binary = '0'+ binary
    return binary #type:string
    
def R_Type_Conversion(instruction):
    if (is_Rtype(instruction)==1): ## add sub and or
         instParts=instruction.replace(',','').split()
         op='000000'
         rs=Registers[instParts[2]]
         rt=Registers[instParts[3]]
         rd=Registers[instParts[1]]
         shamt='00000'
         funct=R_Funct[instParts[0]]
         return  op + rs + rt + rd + shamt + funct
    if (is_Rtype(instruction)=='extremes'):
         instParts=instruction.replace(',','').split()
         if (instParts[0]=='sll'): #sll
            op='000000'
            rs='00000'
            rt=Registers[instParts[2]]
            rd=Registers[instParts[1]]
            shamt=decimalToBinary(int(instParts[3]))
            funct=R_Funct[instParts[0]]
            return  op + rs + rt + rd + shamt + funct
         if (instParts[0]=='jr'): #jr
            op='000000'
            rs=Registers[instParts[1]]
            rt='00000'
            rd='00000'
            shamt='00000'
            funct=R_Funct[instParts[0]]
            return  op + rs + rt + rd + shamt + funct

print("""
##################################################################
@@       @@   @@@@  @@    @@  @@@@@@   @@   @@@@@@@    @@    @@
@@ @   @ @@   @  @  @@ @  @@  @    @   @@   @@   @@    @@    @@
@@   @   @@   @  @  @@  @ @@  @@@@@@   @@   @@@@@@        @@
@@       @@   @@@@  @@    @@  @    @   @@   @@    @@      @@
##################################################################

MIPS ASSEMBLER
All Rights Reserved to @AhmedElmonairy
-------------------------------------------------------------------------------------------------------
""")



while True:
    a = raw_input("Enter Instuction \n")
    print R_Type_Conversion(a)
    if a == "quit":
        break
    

