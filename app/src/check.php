<?php
if (file_exists('/data/running')) {
    echo "already in progress";
} else {
    $create_file_update = fopen("/var/www/html/update.txt", "w") or die("Unable to open file!");
    fwrite($create_file_update, "1");
    echo "check initiated";
}
?>