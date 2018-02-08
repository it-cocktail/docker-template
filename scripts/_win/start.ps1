
$PROXY_PORT = (((docker ps | Out-String) -split "`r`n" | Select-String "CONTAINER ID|jwilder/nginx-proxy") -replace "  +", "`t" | ConvertFrom-CSV -Delimiter "`t" | Select -expand PORTS | Out-String) -replace ".*0\.0\.0\.0:([0-9]+)->80.*`n", '$1'
if (-Not ($PROXY_PORT)) {
    throw "ERROR: Please start docker proxy. Project can be found on Gitlab under http://gitlab.orangehive.de/orangehive/docker-proxy"
}

[Environment]::SetEnvironmentVariable("MAIL_VIRTUAL_HOST", "mail.$env:BASE_DOMAIN, mailhog.$env:BASE_DOMAIN")
[Environment]::SetEnvironmentVariable("PHPMYADMIN_VIRTUAL_HOST", "phpmyadmin.$env:BASE_DOMAIN")

$PHP_VIRTUAL_HOST = "www.$env:BASE_DOMAIN, $env:BASE_DOMAIN"
$PHP_APACHE_ALIAS = "localhost"
if (Test-Path $env:CWD\docker-data\config\container\php\apache2\aliases.txt) {
    $domains = cat docker-data\config\container\php\apache2\aliases.txt
    foreach ($domain in $domains) {
        $domain = $domain.Trim()
        if ($domain -And -Not ($domain.StartsWith('#'))) {
            $PHP_VIRTUAL_HOST = "$PHP_VIRTUAL_HOST, $domain"
            $PHP_APACHE_ALIAS = "$PHP_APACHE_ALIAS $domain"
        }
    }
}
[Environment]::SetEnvironmentVariable("PHP_VIRTUAL_HOST", $PHP_VIRTUAL_HOST)
[Environment]::SetEnvironmentVariable("PHP_APACHE_ALIAS", $PHP_APACHE_ALIAS)

$ADDITIONAL_CONFIGFILE = ""
$DEGUBGMODE = 0
for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[$i] -eq "-d") {
        $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.debug.yml"
        $localIP = (Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address).IPAddressToString
        [Environment]::SetEnvironmentVariable("LOCAL_DEBUG_IP", $localIP)
        Write-Host "***DEBUGMODE*** LOCAL_DEBUG_IP: $env:LOCAL_DEBUG_IP"
        $DEBUGMODE = 1
    } else {
        throw "invalid parameter " + $args[$i]
    }
}

$JAVADEBUGENABLED = 0
if ($env:JAVA_SRC_FOLDER) {
    if (Test-Path "$env:JAVA_SRC_FOLDER") {
        if ($DEBUGMODE -eq 1) {
            $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.java.yml -f docker-data\config\base\docker-compose.debug_java.yml"
            $JAVADEBUGENABLED = 1
            [Environment]::SetEnvironmentVariable("JAVA_VIRTUAL_HOST", "java.$env:BASE_DOMAIN")
        } else {
            $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.java.yml"
        }
        Write-Host ***Java Service will be activated***
    } else {
        Write-Host "JAVA_SRC_FOLDER not found"
        exit
    }
}

if ($SFTP_ENABLED -eq 1) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.sftp.yml"
}

if ($RSYNC_ENABLED -eq 1) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.rsync.yml"
}

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

$ENV_SANATIZED = $env:ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'
if (Test-Path $env:CWD\docker-data\config\docker-compose.$ENV_SANATIZED.yml) {
    Write-Host "adding $env:ENVIRONMENT configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.$ENV_SANATIZED.yml"
}

if ($env:AUTOPULL -eq "1") {
    Write-Host "`nupdating container images if needed ..."
    Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"
}

Write-Host "`nstarting services ..."
Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

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
