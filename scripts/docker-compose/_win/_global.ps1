if (-Not ($envHash.PROJECTNAME)) {
    $envHash.PROJECTNAME = $cwdSanatized
}

if (-Not ($envHash.PHPMYADMIN_VIRTUAL_HOST)) {
    $envHash.PHPMYADMIN_VIRTUAL_HOST = "phpmyadmin." + $envHash.BASE_DOMAIN
}

if (-Not ($envHash.PHP_VIRTUAL_HOST)) {
    $envHash.PHP_VIRTUAL_HOST = "www." + $envHash.BASE_DOMAIN
}

if (-Not ($envHash.MAIL_VIRTUAL_HOST)) {
    $envHash.MAIL_VIRTUAL_HOST = "mail." + $envHash.BASE_DOMAIN
}

foreach ($key in $envHash.keys) {
    [Environment]::SetEnvironmentVariable($key, $envHash[$key])
}


