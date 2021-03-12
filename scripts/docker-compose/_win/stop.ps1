$ADDITIONAL_CONFIGFILE = ""
if (Test-Path $env:CWD\docker-compose\docker-compose.custom.yml) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.custom.yml"
}

$ENV_SANATIZED = $env:ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'
if (Test-Path $env:CWD\docker-compose\docker-compose.$ENV_SANATIZED.yml) {
    Write-Host "adding $env:ENVIRONMENT configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.$ENV_SANATIZED.yml"
}

Invoke-Expression "& { docker-compose --project-directory `"$env:CWD`" -p `"$env:PROJECTNAME`" -f docker-compose\docker-compose.yml $ADDITIONAL_CONFIGFILE down 2>null }"

exit
