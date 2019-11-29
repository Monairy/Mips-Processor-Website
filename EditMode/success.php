<html>
<head>
<title>MIPS Processor</title>
</head>
<?php 
$myfile = fopen("project2.txt", "w") or die("Unable to open file!");
fwrite($myfile, $_POST["verilog"]);
fclose($myfile); 
?>
<body>
<pre>
<div align="center">
<font color="red"><h1>Mips Processor Verilog Code</h1></font>
<font color="red"><h1>Project Updated Successfully!</h1></font>
<form action="edit.php" method="get">
<input type="submit" value="Back To Edit Mode" style="height:50px;width:228px;">
</form>
<?php
exec('python SyntaxHighlighter.py');
?>
<div id="first" align="center">
<?php echo file_get_contents("highlightedproject.txt"); ?>
</div>
</p>
<style>
#first{
  text-align: left;
  font-size:20;
}
#second{
float:right;
}
</style>

</body>
</html>