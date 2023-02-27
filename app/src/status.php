<?php
header("Content-Type: application/json; charset=UTF-8");

class UpdateStatus {
  public $running; 
}

$status = new UpdateStatus;

$status->running = false;
$content = file_get_contents('/var/www/html/update.txt');

if ($content == '1') {
    $status->running = true;
}
$jsonStr = json_encode($status);
echo $jsonStr;

?>