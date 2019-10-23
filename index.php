<html>
<head>
<title>MipsAssemblerByMonairy</title>
</head>
<body>
<pre>
<div align="center">
<font color="red"><h1>Welcome To Mips Assembler</h1></font>
<font color="Blue"><b>Enter Your Assembly here:<b></font>
<form action="index.php" method="post">
<textarea name="assembly" rows="10" cols="30"></textarea><br>
<input type="submit" value="Assemble Please" style="height:50px;width:228px;">
</form>
<font color="Blue"><h1>Your input is:</h1></font>
<?php echo $_POST["assembly"];
$myfile = fopen("assembly.txt", "w") or die("Unable to open file!");
fwrite($myfile, $_POST["assembly"]);
fclose($myfile);
?>
<font color="Blue"><h1>Machine Code is:</h1></font>
<?php 
$output=exec('C:\Python27\python.exe assembler.py');
echo file_get_contents("binary.txt");
?>
</p>
</body>
</html>
