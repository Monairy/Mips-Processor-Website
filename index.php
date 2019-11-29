<html>
<head>
<title>MIPS Processor</title>
</head>
<body>
<div id="first">
<form action="EditMode/edit.php" method="get">
<input type="submit" value="Edit Verilog Code" style="height:50px;width:228px;">
</form>
</div>
<form action="AutomatedTesting.php" method="get">
<input type="submit" value="Automated Testing" style="height:50px;width:228px;">
</form>
<pre>
<div align="center">
<font color="red"><h1>Welcome To Mips Processor</h1></font>
<font color="Blue"><b>Enter Your Assembly here:<b></font>
<form action="index.php" method="post">
<textarea name="assembly" rows="10" cols="30"></textarea><br>
<input type="submit" value="Assemble & Run Please" style="height:50px;width:228px;">
</form>
<font color="Blue"><h1>Your input is:</h1></font>
<?php echo $_POST["assembly"];
$myfile = fopen("assembly.txt", "w") or die("Unable to open file!");
fwrite($myfile, $_POST["assembly"]);
fclose($myfile);
?>
<font color="Blue"><h1>Machine Code is:</h1></font>
<?php 
$output=exec('python assembler.py');
echo file_get_contents("binary.txt");
?>
<div id="first">
<font color="Blue"><h1>Register File Contents:</h1></font>
<?php
exec('Modelsim.bat');
echo file_get_contents("_FromRegFile.txt");
?>
</div>
<div id="second">
<font color="Blue"><h1>DataMemory Contents:</h1></font>
<?php echo file_get_contents("_FromDataMem.txt"); ?>
</div>
<font color="Blue"><b>PC Final Value:</b>
<h1><?php echo file_get_contents("PC.txt"); ?></h1>


<style>
#first{
float:left;
}
#second{
float:right;
left:35%;

}
#third{
left:35%;
position:absolute;
}
</style>

</p>
</body>
</html>
