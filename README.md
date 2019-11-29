# Mips Processor Web Interface
**This Project intends to make website as an interface 
for simulating Mips Processor made with verilog**


•First page **index.php** takes assembly code from user

•At backend, **assembler.py** runs, which assembles input into machine code

•modelsim is called, which runs the verilog code, taking instuctions machine code as input

•At the end, RegisterFile contents and DataMemory contents are shown in same page


•Second page **EditMode**
•this page is for editing verilog code for the processor

•then the modified code is shown with syntax highlighted as verliog

•syntax highlighting is done by **SyntaxHighlighter.py**


•Third page **AutomatedTesting.php**
•this takes a folder of test cases and their execution results
•then it keeps calling modelsim and executes those testcases
•At the end, you see if each test case succeeded or failed and the problem within failed testcase.
