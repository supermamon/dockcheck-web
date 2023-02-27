<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php
            if (isset($_ENV['WINDOW_TITLE'])) {
                echo htmlspecialchars($_ENV['WINDOW_TITLE']);
            } else {
                echo 'Dockcheck';
            }
            ?></title>
    <link rel="stylesheet" href="bulma.min.css">
    <link rel="icon" href="favico.jpeg">
</head>
<body>
<section class="section">

    <div class="container">
        <h1 class="title">
            <a href=index.php><?php
                if (isset($_ENV['PAGE_TITLE'])) {
                    echo htmlspecialchars($_ENV['PAGE_TITLE']);
                } else {
                    echo 'Dockcheck';
                }
                ?>
            </a>
        </h1>
        <h2 class="subtitle">Image updates for your running containers.</h2>
    </div>

    <div class="container">
        <p>&nbsp;</p>
        <p><button id="cfu" type="button" class="button is-primary is-rounded">Check for updates</button></p>
        <p>&nbsp;</p>
    </div>

    <div class="container">
    <?
    $filename = '/data/containers';

    $conlatest_match = [];
    $conerror_match = [];
    $conupdate_match = [];

    if (filesize($filename) != 0) {

        $f = fopen($filename, 'r');

        if ($f) {
            $contents = fread($f, filesize($filename));
            fclose($f);
            preg_match("/(?<=Containers with errors, wont get updated:\n)(?s).*?(?=\n\n)/", $contents, $conerror_match); 
            $string_output_error = implode('', $conerror_match);
            $conerror_match = preg_split('`\n`', $string_output_error);

            preg_match("/(?<=Containers on latest version:\n)(?s).*?(?=\n\n)/", $contents, $conlatest_match);    
            $string_output_latest = implode('', $conlatest_match);
            $conlatest_match = preg_split('`\n`', $string_output_latest);

            preg_match("/(?<=Containers with updates available:\n)(?s).*?(?=\n\n)/", $contents, $conupdate_match);
            $string_output_update = implode('', $conupdate_match);
            $conupdate_match = preg_split('`\n`', $string_output_update);
        }


        $keyslatest = array_keys($conlatest_match);
        $arraysizelatest = count($conlatest_match); 

        $keyserror = array_keys($conerror_match);
        $arraysizeerror = count($conerror_match);


        $keysupdate = array_keys($conupdate_match);
        $arraysizeupdate = count($conupdate_match);
    }



    ?>
    <div class="columns">
        <div class="column">
            <span class="title is-size-4 has-text-success is-capitalized">Updates available</span>
            <table class="table is-narrow">
            <?php
            sort($conupdate_match);
            if(!empty($conupdate_match)) {
                    for($i=0; $i < $arraysizeupdate; $i++) {
                        echo '<tr>';
                        echo '<td>' . $conupdate_match[$keysupdate[$i]] . '</td>';
                        echo '</tr>';
                    }
            }
            ?>
            </table>

        </div>            
        <div class="column">
            <span class="title is-size-4 has-text-info is-capitalized">Up-to-date</span>
            <table class="table is-narrow">
            <?php
            sort($conlatest_match);
            if(!empty($conlatest_match)) {
                    for($i=0; $i < $arraysizelatest; $i++) {
                        echo '<tr>';
                        echo '<td>' . $conlatest_match[$keyslatest[$i]] . '</td>';
                        echo '</tr>';
                    }
            }
                ?>
            </table>
        </div>

        <div class="column">
            <span class="title is-size-4 has-text-danger is-capitalized">Will not be updated</span>
            <table class="table is-narrow">
            <?php
            sort($conerror_match);
                if(!empty($conerror_match)) {
                    for($i=0; $i < $arraysizeerror; $i++) {
                        echo '<tr>';
                        echo '<td>' . $conerror_match[$keyserror[$i]] . '</td>';
                        echo '</tr>';
                    }
                }
                ?>
            </table>
        </div>
    </div>
</section>

<script>
document.addEventListener('DOMContentLoaded', () => {
  // Functions to open and close a modal
  function setLoading($el) {
    $el.classList.add('is-loading');
  }

  function endLoading($el) {
    $el.classList.remove('is-loading');
  }

  const cfuButton = document.querySelector('#cfu')
  cfuButton.addEventListener('click', () => {
      setLoading(cfuButton);
      fetch('/check.php').then( r => r.text()).then( t => console.log(t))
      intervalId = window.setInterval(() => {
        fetch('/status.php')
        .then( r => r.json())
        .then( j => {
            if (!j.running) {
                location.reload()
                endLoading(cfuButton)
                window.clearInterval(intervalId);
            }
        })
      }, 1000);
    });

    fetch('/status.php')
    .then( r => r.json())
    .then( j => {
        if (j.running) {
            cfuButton.click()
        }
    })



});

</script>

</body>
</html>
