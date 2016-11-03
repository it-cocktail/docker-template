<!doctype html>
<html>
<head>
    <link href="/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/print.css" media="print" rel="stylesheet" type="text/css" />
    <!--[if IE]>
    <link href="/stylesheets/ie.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <![endif]-->
</head>
<body>
    <hr />
    <?php

    if (!empty($_GET['java'])) {
        $cp = curl_init();
        $my_url = "http://java";
        curl_setopt($cp, CURLOPT_URL, $my_url);
        curl_setopt($cp, CURLOPT_RETURNTRANSFER, 1);
        $result = curl_exec($cp);
        curl_close($cp);
        echo "<p style=\"text-align: center\">Java Result: $result</p>";
    }
    echo "<hr />";

    $sent = mail('t.duarte@orangehive.de', 'docker test', 'Das ist ein Mail-Test aus Docker heraus');

    if ($sent) {
        echo "<p style=\"text-align: center\">Test-Mail was sent</p>";
    } else {
        echo "<p style=\"text-align: center\">Test-Mail was not sent</p>";
    }
    echo "<hr />";

    phpinfo();
    ?>
</body>
</html>