<?php

session_start();

if (isset($_SESSION["serverok_test"])) {
    $_SESSION["serverok_test"] += 1;
} else {
    $_SESSION["serverok_test"] = 1;
}

echo "You have reloaded this page " . $_SESSION["serverok_test"] . " times";
