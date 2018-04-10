
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

if ($env:AUTOPULL -eq "1") {
    Write-Host "`nupdating container images if needed ..."
    Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"
}

Write-Host "`nstarting services ..."
Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

Write-Host "`n"

if ($PROXY_PORT -eq "80") {
    Write-Host "Services:`n"
    Write-Host "http://www.$env:BASE_DOMAIN"
    Write-Host "http://phpmyadmin.$env:BASE_DOMAIN"
    if ($ENV_SANATIZED -eq "development") {
        Write-Host "http://mail.$env:BASE_DOMAIN"
    }
} else {
    Write-Host "Services:`n"
    Write-Host "http://www.$env:BASE_DOMAIN`:$PROXY_PORT"
    Write-Host "http://phpmyadmin.$env:BASE_DOMAIN`:$PROXY_PORT"
    if ($ENV_SANATIZED -eq "development") {
        Write-Host "http://mail.$env:BASE_DOMAIN`:$PROXY_PORT"
    }
}

exit
