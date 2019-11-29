module PC(Out,In,clk,endexecution);
input clk;
input [31:0]In;
output reg [31:0]Out;
output reg endexecution; ///////////////
initial
begin
Out[31:0]=0;
end

/////////////////// know number of instuctions
integer Ay7aga;
integer lines=-1;
integer file1;
integer cycles=0;
initial
begin
file1=$fopen("C:/localhost/_ToInstMem.txt","r");
while (! $feof(file1))
begin
$fscanf(file1,"%d",Ay7aga);
lines = lines+1; //////// number of lines in code
end
$fclose(file1);
end

always@(posedge clk)
begin
Out <= In;
cycles=cycles+1; ///////////// 
if ((In>>2)>lines)
endexecution=1;
end

endmodule

module DataMemory(ReadData,Address,WriteData,MemRead,MemWrite,clk,endofexec);

input clk;
input MemRead;
input MemWrite;
input[15:0]Address;
input[31:0]WriteData;
output reg[31:0]ReadData;
input endofexec; ///////////////////////////////////flaggggggg
reg[31:0]datamem[0:8191];
integer file;
integer i;

always @(ReadData,Address,MemRead,WriteData,MemWrite)
begin
 ReadData <= datamem[Address>>2];
end

always @(posedge clk)
begin
if(MemWrite)
begin
datamem[Address>>2] <= WriteData;
end
end

always @(posedge endofexec) /////////////to monitor DataMemory contents in a file///////////////////
begin
file=$fopen("C:/localhost/_FromDataMem.txt");
$fmonitor(file,"%b  //%d",datamem[i],i*4);
for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end
end

endmodule



module InstructionMemory(Instruction,ReadAdd,clk,);
input clk;                   //the instruction is constant within the cycle
input [31:0]ReadAdd;         //4 hexadicimal digits from pc
output reg [31:0]Instruction;
reg[31:0]instmem[0:8191];
integer file1,file2;
integer i;

always @(negedge clk)        //at rising edge the instruction is read
begin
 Instruction <= instmem[ReadAdd>>2];
end

initial                //to fill the instruction memory from a file
begin
$readmemb("C:/localhost/_ToInstMem.txt",instmem);
end

initial                //to monitor memory contents in a file
begin
i=0;
file2=$fopen("C:/localhost/_FromInstMem.txt");
$fmonitor(file2,"%b // %h ",instmem[i],i );
for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end
end

endmodule

module MIPSALU (ctl, readData1, lowerIn, shamt, ALUresult, zero);
// lowerIn is the mux output

input [3:0] ctl;
input [31:0] readData1,lowerIn;
input [4:0] shamt;
output reg [31:0] ALUresult;
output zero;

// Zero flag equals 1. if the output equals zero
assign zero = (ALUresult == 0);

always @ (ctl, readData1, lowerIn)
 case(ctl)
	0:ALUresult <= readData1 & lowerIn;		//and
	1:ALUresult <= readData1 | lowerIn;		//or (ori)
	2:ALUresult <= readData1 + lowerIn;		//add (lw, sw, addi)
	6:ALUresult <= readData1 - lowerIn;		//sub (beq)
	7:ALUresult <= readData1 < lowerIn ? 1:0;	//slt
	//12:ALUresult <= ~ (readData1 | lowerIn);	//nor
	14:ALUresult <= lowerIn << shamt;		//sll
	default:ALUresult <= 0;
 endcase
endmodule
/////////////////////////////////////////////////////////////////////////////////////

module RegFile (ReadData1,ReadData2,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk,endofexec);
input clk;
input RegWrite;		//from control
input [4:0] ReadReg1;   //from instruction bus
input [4:0] ReadReg2;	//from instruction bus
input [4:0] WriteReg;	//from RegDst MUX
input [31:0] WriteData; //from instruction bus
output reg [31:0] ReadData1;
output reg [31:0] ReadData2;
reg [31:0] registers [0:31];
integer i=0 ;
integer file;
input endofexec;

initial begin
registers[0]=32'b00000000000000000000000000000000;
end

always @(ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite)
begin
//RegFile is supposed to read both regs
 ReadData1 <= registers[ReadReg1];
 ReadData2 <= registers[ReadReg2];
end
//write in register
always @(posedge clk)
begin
if(RegWrite && (WriteReg!=5'b00000))
	registers[WriteReg]=WriteData;
end

integer lines = 0;
always @(posedge endofexec) ///////////to monitor registers contents in a file///////////////
begin
for (lines = 0; lines<31; lines=lines+1)
begin
file=$fopen("C:/localhost/_FromRegFile.txt");
$fmonitor(file,"%b // %d",registers[i],i );
end
for(i=0;i<31;i=i+1)
begin
#1
i=i;
end
end

endmodule

module ALUMux (MUXout, readData2, in2, ALUSrc);

output [31:0] MUXout;
input [31:0] readData2, in2;
input ALUSrc;
assign  MUXout = (ALUSrc == 1'b0)? readData2:
		 (ALUSrc == 1'b1)? in2:
		1'bx;
endmodule


module AluCtl(funct,aluop,aluctl,jr);
input [5:0] funct;
input [2:0] aluop;
output reg [3:0] aluctl;
output reg jr;

always @ (aluop,funct)
if (aluop == 3'b000)
 begin aluctl<=2; jr <=0; end
else if (aluop==3'b001)
 begin aluctl<=6; jr <=0; end
else if (aluop==3'b010) //R type
  begin
     case (funct)
        0: begin aluctl <= 14; jr <=0; end
	32:begin aluctl <= 2; jr <=0; end //add R type
	34:begin aluctl <= 6; jr <=0; end //sub R type
	36:begin aluctl <= 0; jr <=0; end //and R type
	37:begin aluctl <= 1; jr <=0; end //or R type
	42:begin aluctl <= 7; jr <=0; end //slt R type
        8: jr <= 1; // jr R type
	default:begin aluctl <= 0; jr<=0; end
      endcase
  end
else if (aluop==3'b011) //addi
 begin aluctl<=2; jr <=0; end
else if (aluop<=3'b100)
  begin aluctl<=1; jr <=0; end //ori
else begin aluctl<=0; jr <=0; end

endmodule


module SignExtend16_32(Exiting,Entering);

input[15:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {{16{Entering[15]}} ,Entering};

endmodule



module ShiftLeft32(Exiting,Entering);

input[31:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {Entering[29:0],2'b00};

endmodule



module ShiftLeft26_28(Exiting,Entering);

input[25:0]Entering;
output wire[27:0]Exiting;

assign Exiting = {Entering,2'b00};

endmodule



module Concatenator(JumpAddress,Instruction,PCplus4);

input[27:0]Instruction;
input[31:28]PCplus4;
output wire[31:0]JumpAddress;

assign JumpAddress = {PCplus4,Instruction};


endmodule


module Mux5(Out,In0,In1,Sel);

input [4:0]In0;
input [4:0]In1;
input Sel;
output reg [4:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=5'bxxxxx;
endcase
end
endmodule



module Mux32(Out,In0,In1,Sel);
input [31:0]In0;
input [31:0]In1;
input Sel;
output reg [31:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=32'd0;
endcase
end
endmodule

module PCAdder(Out,In);

input [31:0]In;
output reg [31:0]Out;
always@(Out,In)
Out<=In+3'b100;

endmodule
module ShiftAdder(Out,In1,In2);
input [31:0]In1;
input [31:0]In2;
output reg [31:0]Out;
always@(Out,In1,In2)
Out<=(In1+In2);
endmodule


module control(regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,opCode);

input[5:0] opCode;
output reg regDst,jump,branch,memRead,memToReg,memWrite,aluSrc,regWrite;
output reg[2:0] aluOp;

always @(opCode)

begin


if(opCode==6'b000000) //R type 
begin
regDst<=1'b1;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b010;
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b1;
end


else if(opCode==6'b000100) //beq
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b1;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b001; //subtract 
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b0;
end

else if(opCode==6'b001000) //addi 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b000;
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b001101) //ori 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b100; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b101011) //sw 
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b000; 
memWrite<=1'b1;
aluSrc<=1'b1;
regWrite<=1'b0;
end

else if(opCode==6'b100011) //lw
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b1;
memToReg<=1'b1;
aluOp<=3'b000; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b000010) //j
begin
regDst<=1'bx;
jump<=1'b1;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end

else if(opCode==6'b000011) //jal
begin
regDst<=1'bx;
jump<=1'b1;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b1;
end

else
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end


end

endmodule



module mips_cpu(clk);
input clk;
wire [31:0] RA,MO2,MO3,MO4,MO5,MO6,MO7,RD1,RD2,aluresult,SignOut,ReadData,Add2in2,Add1out,Add2out,fullJA,IR;
wire [4:0]rs,rt,rd,shift,MO1,MO8;
wire [5:0]opcode,func;
wire [15:0]offset;
wire [25:0]JA;
wire [2:0]aluop;
wire [3:0]aluctl,L4BitsOfNewPC;
wire regdst,jump,branch,memread,memtoreg,memwrite,alusrc,regwrite,zero,jr;
wire [27:0]shiftleft2out;
wire endofexec; ////////////////////flag
PC pc1(RA,MO6,clk,endofexec); //flaggggggg//////////
InstructionMemory IM1(IR,RA,clk);
assign rs=IR[25:21];
assign rt=IR[20:16];
assign rd=IR[15:11];
assign shift=IR[10:6];
assign opcode=IR[31:26];
assign func=IR[5:0];
assign offset=IR[15:0];
assign JA=IR[25:0];
assign L4BitsOfNewPC=Add1out[31:28];
assign fullJA={L4BitsOfNewPC,shiftleft2out};
RegFile RF1(RD1,RD2,rs,rt,MO8,MO7,regwrite&(!jr),clk,endofexec); //flaggggggg/////////
MIPSALU MALU1(aluctl,RD1,MO2,shift,aluresult,zero);
AluCtl AluCtl1(func,aluop,aluctl,jr);
SignExtend16_32 SE1(SignOut,offset);
control Ctl1(regdst,jump,branch,memread,memtoreg,aluop,memwrite,alusrc,regwrite,opcode);
DataMemory DM1(ReadData,aluresult[15:0],RD2,memread,memwrite,clk,endofexec); ////////flaggggggg/////////
ShiftLeft32 SL1(Add2in2,SignOut);
ShiftAdder SA1(Add2out,Add1out,Add2in2);
PCAdder PCADD1(Add1out,RA);
ShiftLeft26_28 SL2(shiftleft2out,JA);
Mux5 MUX1(MO1,rt,rd,regdst);
Mux5 MUX8(MO8,MO1,5'b11111,jump);
Mux32 MUX2(MO2,RD2,SignOut,alusrc);
Mux32 MUX3(MO3,aluresult,ReadData,memtoreg);
Mux32 MUX4(MO4,Add1out,Add2out,(zero&branch)); 
Mux32 MUX5(MO5,MO4,fullJA,jump);
Mux32 MUX6(MO6,MO5,RD1,jr);
Mux32 MUX7(MO7,MO3,Add1out,jump);
endmodule

module tbmips();
reg clock1;
initial
begin
assign clock1=0;
end
always
begin
#5;
assign clock1=~clock1;
#5;
end
mips_cpu MIPS(clock1);

endmodule

