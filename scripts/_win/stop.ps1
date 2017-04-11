
$ADDITIONAL_CONFIGFILE = ""
if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE down }"

exit
