<?php
    $create_file_update = fopen("/var/www/html/update.txt", "w") or die("Unable to open file!");
    $txt = '1';
    fwrite($create_file_update, $txt);
    echo "received"
?>