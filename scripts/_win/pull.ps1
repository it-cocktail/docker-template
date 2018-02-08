$ADDITIONAL_CONFIGFILE = ""
if ($env:JAVA_SRC_FOLDER) {
    if (Test-Path "$env:JAVA_SRC_FOLDER") {
        $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.java.yml"
    }
}

if ($SFTP_ENABLED -eq 1) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.sftp.yml"
}

if ($RSYNC_ENABLED -eq 1) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.rsync.yml"
}

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

$ENV_SANATIZED = $env:ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'
if (Test-Path $env:CWD\docker-data\config\docker-compose.$ENV_SANATIZED.yml) {
    Write-Host "adding $env:ENVIRONMENT configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.$ENV_SANATIZED.yml"
}


Write-Host "`nupdating container images if needed ..."
Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

exit
