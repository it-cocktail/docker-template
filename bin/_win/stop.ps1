
$ADDITIONAL_CONFIGFILE=""
if (Test-Path "$env:CWD\docker-data\config\docker-compose.custom.yml") {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\docker-compose.custom.yml"
}

docker-compose  -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml -f docker-data\config\base\docker-compose.java.yml $ADDITIONAL_CONFIGFILE down

exit
