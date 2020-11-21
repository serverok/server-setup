<?php
# Script to test MySQL connection using mysqli
# Author: ServerOk.in
# Web: https://serverok.in

$con = mysqli_connect("localhost","my_user","my_password","my_db");

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
} else {
    echo "Database connection sucessfull.";
}
