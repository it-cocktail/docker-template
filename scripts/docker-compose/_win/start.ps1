
[Environment]::SetEnvironmentVariable("MAIL_VIRTUAL_HOST", "mail.$env:BASE_DOMAIN, mailhog.$env:BASE_DOMAIN")
[Environment]::SetEnvironmentVariable("PHPMYADMIN_VIRTUAL_HOST", "phpmyadmin.$env:BASE_DOMAIN")

$PHP_VIRTUAL_HOST = "www.$env:BASE_DOMAIN, $env:BASE_DOMAIN"
$PHP_APACHE_ALIAS = "localhost"
if (Test-Path $env:CWD\docker-compose\container\php\apache2\aliases.txt) {
    $domains = cat docker-compose\container\php\apache2\aliases.txt
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

if (Test-Path $env:CWD\docker-compose\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.custom.yml"
}

$ENV_SANATIZED = $env:ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'
if (Test-Path $env:CWD\docker-compose\docker-compose.$ENV_SANATIZED.yml) {
    Write-Host "adding $env:ENVIRONMENT configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-compose\docker-compose.$ENV_SANATIZED.yml"
}

Invoke-Expression "& { docker compose --project-directory `"$env:CWD`" --env-file `"$env:CWD\.env`" -p `"$env:PROJECTNAME`" -f docker-compose\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

Write-Host "`nstarting services ..."
Invoke-Expression "& { docker compose --project-directory `"$env:CWD`" --env-file `"$env:CWD\.env`" -p `"$env:PROJECTNAME`" -f docker-compose\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

exit
