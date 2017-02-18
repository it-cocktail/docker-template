
$PROXY_PORT = (docker ps | findstr /R "nginx-proxy" | Out-String).toString() -replace '.*0\.0\.0\.0:([0-9]*)->80\/tcp.*','$1' | Select-Object -Last 1
if (-Not ($PROXY_PORT)) {
    throw "ERROR: Please start docker proxy. Project can be found on Gitlab under http://gitlab.orangehive.de/orangehive/docker-proxy"
}

if ($env:SECONDARY_DOMAIN) {
    [Environment]::SetEnvironmentVariable("MAIL_VIRTUAL_HOST", "mail.$env:BASE_DOMAIN, mail.$env:SECONDARY_DOMAIN, mailhog.$env:BASE_DOMAIN, mailhog.$env:SECONDARY_DOMAIN")
    [Environment]::SetEnvironmentVariable("PHP_VIRTUAL_HOST", "www.$env:BASE_DOMAIN, www.$env:SECONDARY_DOMAIN, $env:BASE_DOMAIN, $env:SECONDARY_DOMAIN")
    [Environment]::SetEnvironmentVariable("PHPMYADMIN_VIRTUAL_HOST", "phpmyadmin.$env:BASE_DOMAIN, phpmyadmin.$env:SECONDARY_DOMAIN")
} else {
    [Environment]::SetEnvironmentVariable("SECONDARY_DOMAIN", "$env:BASE_DOMAIN")
    [Environment]::SetEnvironmentVariable("MAIL_VIRTUAL_HOST", "mail.$env:BASE_DOMAIN, mailhog.$env:BASE_DOMAIN")
    [Environment]::SetEnvironmentVariable("PHP_VIRTUAL_HOST", "www.$env:BASE_DOMAIN, $env:BASE_DOMAIN")
    [Environment]::SetEnvironmentVariable("PHPMYADMIN_VIRTUAL_HOST", "phpmyadmin.$env:BASE_DOMAIN")
}

$ADDITIONAL_CONFIGFILE = ""
$DEGUBGMODE = 0
for ( $i = 0; $i -lt $args.count; $i++ ) {
    SET PARAMETER=%%P
    if ($args[$i] -eq "-d") {
        $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\base\docker-compose.debug.yml"
        $localIP = (Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address).IPAddressToString
        [Environment]::SetEnvironmentVariable("LOCAL_DEBUG_IP", $localIP)
        Write-Host "***DEBUGMODE*** LOCAL_DEBUG_IP: $env:LOCAL_DEBUG_IP"
        $DEBUGMODE = 1
    } else {
        throw "invalid parameter $args[$i]"
    }
}

$JAVADEBUGENABLED = 0
if ($env:JAVA_SRC_FOLDER) {
    if (Test-Path "$env:JAVA_SRC_FOLDER") {
        if ($DEBUGMODE -eq 1) {
            $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\base\docker-compose.java.yml -f docker-data\config\base\docker-compose.debug_java.yml"
            $JAVADEBUGENABLED = 1
            [Environment]::SetEnvironmentVariable("JAVA_VIRTUAL_HOST", "java.$env:BASE_DOMAIN, java.$env:SECONDARY_DOMAIN")
        } else {
            $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\base\docker-compose.java.yml"
        }
        Write-Host ***Java Service will be activated***
    } else {
        Write-Host "JAVA_SRC_FOLDER not found"
        exit
    }
}

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\docker-compose.custom.yml"
}

Write-Host "`nupdating container images if needed ..."
docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull 2>&1 | findstr /R "^Status ^Pulling"

Write-Host "`nstarting services ..."
docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

Write-Host "`n"

if ($PROXY_PORT -eq "80") {
    Write-Host "Services:`n"
    Write-Host "http://www.$env:BASE_DOMAIN"
    Write-Host "http://phpmyadmin.$env:BASE_DOMAIN"
    Write-Host "http://mail.$env:BASE_DOMAIN"
    if ($JAVADEBUGENABLED -eq 1) {
        Write-Host "http://java.$env:BASE_DOMAIN"
    }
} else {
    Write-Host "Services:`n"
    Write-Host "http://www.$env:BASE_DOMAIN`:$PROXY_PORT"
    Write-Host "http://phpmyadmin.$env:BASE_DOMAIN`:$PROXY_PORT"
    Write-Host "http://mail.$env:BASE_DOMAIN`:$PROXY_PORT"
    if ($JAVADEBUGENABLED -eq 1) {
        Write-host "http://java.$env:BASE_DOMAIN`:$PROXY_PORT"
    }
}

exit