R_Instuctions=['add','sub','slt','and','or','sll','jr']
R_Funct={'add':'100000','sub':'100010','and':'100100','slt':'101010','or':'100101','sll':'000000','jr':'001000'}
I_Instuctions=['lw','sw','beq','addi','ori']
I_Op={'lw':'100011','sw':'101011','beq':'000100','addi':'001000','ori':'001101'}
Registers = {'$zero':'00000','$at':'00001','$v0':'00010','$v1':'00011','$a0':'00100','$a1':'00101','$a2':'00110','$a3':'00111',
             '$t0':'01000','$t1':'01001','$t2':'01010','$t3':'01011','$t4':'01100','$t5':'01101','$t6':'01110','$t7':'01111',
             '$s0':'10000','$s1':'10001','$s2':'10010','$s3':'10011','$s4':'10100','$s5':'10101','$s6':'10110','$s7':'10111',
             '$t8':'11000','$t9':'11001','$k0':'11010','$k1':'11011','$gp':'11100','$sp':'11101','$fp':'11110','$ra':'11111'}

def is_Rtype(instruction):
   for i in R_Instuctions: 
    if (i==instruction.split(' ')[0]):
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
    instParts=instruction.replace(',',' ').split()
    if (instParts[0]=='sll'): #sll
            op='000000'
            rs='00000'
            rt=Registers[instParts[2]]
            rd=Registers[instParts[1]]
            shamt=decimalToBinary(int(instParts[3]))
            funct=R_Funct[instParts[0]]
            return  op + rs + rt + rd + shamt + funct
    elif (instParts[0]=='jr'): #jr
            op='000000'
            rs=Registers[instParts[1]]
            rt='00000'
            rd='00000'
            shamt='00000'
            funct=R_Funct[instParts[0]]
            return  op + rs + rt + rd + shamt + funct
    else: ## add sub slt and or
         op='000000'
         rs=Registers[instParts[2]]
         rt=Registers[instParts[3]]
         rd=Registers[instParts[1]]
         shamt='00000'
         funct=R_Funct[instParts[0]]
         return  op + rs + rt + rd + shamt + funct


def decimalToBinarySignExtend(n):
        if (n[0]=='-'): #negative numbers
              binary=bin(int(n) & 0b1111111111111111) #bitwise and to get positive decimal whose binary equals the negative num
              binary=binary.replace('0b','')
        else: #positive numbers
              binary=bin(int(n))
              binary=binary.replace('0b','')
              for i in range(16-len(binary)):
                  binary = '0' + binary
        return binary

def is_Itype(instruction):
   for i in I_Instuctions: 
    if (i==instruction.split(' ')[0]):        
        return 1
    
def I_Type_Conversion(instuction):
    instParts=instuction.replace(',',' ').replace('(',' ').replace(')',' ').split()
    if(instParts[0]=='addi' or instParts[0]=='ori'): #addi ori
        op=I_Op[instParts[0]]
        rs=Registers[instParts[2]]
        rt=Registers[instParts[1]]
        immediate=decimalToBinarySignExtend(instParts[3])
        return op + rs + rt +immediate
    if(instParts[0]=='lw' or instParts[0]=='sw'):
        op=I_Op[instParts[0]]
        rs=Registers[instParts[3]]
        rt=Registers[instParts[1]]
        immediate=decimalToBinarySignExtend(instParts[2])
        return op + rs + rt +immediate

def main():
    assemblyfile = 'assembly.txt'
    binaryfile= 'binary.txt'
    binary=[]

    with open(assemblyfile,'r') as A:
        lines=A.readlines()
        for i in range(len(lines)):
            lines[i]=lines[i].replace('\n',' ') #list of assembly lines
            if (is_Rtype(lines[i])):
               binary.append(R_Type_Conversion(lines[i]))
            elif (is_Itype(lines[i])):  
               binary.append(I_Type_Conversion(lines[i]))

            
    with open(binaryfile,'w') as B:
       for i in range(len(binary)):
          B.write(binary[i] + '\n')

    
main()
    

