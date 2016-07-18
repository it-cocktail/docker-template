<?php

$result = mail('docker@daniel-sabisch.de', 'docker test', 'Das ist ein Mail-Test aus Docker heraus', 'From:info@daniel-sabisch.de'.chr(10));

//$result = mail('t.duarte@orangehive.de', 'docker test', 'Das ist ein Mail-Test aus Docker heraus');

var_dump($result);

phpinfo();