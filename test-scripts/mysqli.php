<?php

$con = mysqli_connect("localhost","my_user","my_password","my_db");

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
