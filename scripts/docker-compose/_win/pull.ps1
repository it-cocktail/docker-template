$ADDITIONAL_CONFIGFILE = ""
if (Test-Path $env:CWD\docker-compose\docker-compose.custom.yml) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.custom.yml"
}

$ENV_SANATIZED = $env:ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'
if (Test-Path $env:CWD\docker-compose\docker-compose.$ENV_SANATIZED.yml) {
    Write-Host "adding $env:ENVIRONMENT configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.$ENV_SANATIZED.yml"
}


Write-Host "`nupdating container images if needed ..."
Invoke-Expression "& { docker compose --project-directory `"$env:CWD`" --env-file `"$env:CWD\.env`" -p `"$env:PROJECTNAME`" -f docker-compose\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

exit
