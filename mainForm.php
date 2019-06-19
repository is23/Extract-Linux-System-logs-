
<html>
<body>
<h1>Log Records</h1>
<?php
	include  ( "account.php" ) ;// account.php is where I declared all the private info to access mysql
	$dbh = mysqli_connect ( $hostname, $username, $password, $database) or die ( "Unable to connect" );//connection to mysql
	

		// after connecting to database
		$s = "select * from logs";//logs is the table with data
		$t = mysqli_query ($dbh,$s) or die("what");
		$count = 0;
		while($r = mysqli_fetch_array($t)){ // loop to go through each column and display it
			$count+=1;
			print"<br>Message: $count<hr>";
			$s = $r["Severity"];
			print"Severity: $s";
			$s = $r["Time"];
			print"<br> Time: $s";
			$s = $r["Tag"];
			print"<br> Tag: $s";
			$s = $r["Description"];
			print"<br> Description: $s<br><hr><br>";
		};
?>
</body>
</html>
