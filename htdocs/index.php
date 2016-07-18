<?php

$result = mail('t.duarte@orangehive.de', 'docker test', 'Das ist ein Mail-Test aus Docker heraus');

var_dump($result);

phpinfo();