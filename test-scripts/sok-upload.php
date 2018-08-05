<?php
# Author: ServerOk.in
# Web: https://www.serverok.in
# Test PHP upload.

if(!empty($_FILES['uploaded_file'])) {
    $path = "uploads/";
    $path = $path . basename( $_FILES['uploaded_file']['name']);
    $move = move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $path);

    if ($move) {
      echo "The file ".  basename( $_FILES['uploaded_file']['name']). " has been uploaded";
    } else{
        echo "<pre>";
        var_dump($move);
        print_r($_FILES['uploaded_file']);
    }
    exit;
}

?>
<!DOCTYPE html>
<html>
<head>
<title>ServerOk Upload Tester</title>
</head>
<body>
<form enctype="multipart/form-data" action="" method="POST">
Slect file:  <input type="file" name="uploaded_file" />  <input type="submit" value="Upload" />
</form>
</body>
</html>