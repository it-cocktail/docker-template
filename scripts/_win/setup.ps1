
$PROXY_PORT = (((docker ps | Out-String) -split "`r`n" | Select-String "CONTAINER ID|jwilder/nginx-proxy") -replace "  +", "`t" | ConvertFrom-CSV -Delimiter "`t" | Select -expand PORTS | Out-String) -replace ".*0\.0\.0\.0:([0-9]+)->80.*`n", '$1'
if (-Not ($PROXY_PORT)) {
    throw "ERROR: Please start docker proxy. Project can be found on Github under https://github.com/orange-hive/docker-proxy"
}

if (-Not (Test-Path "$env:CWD\docker-data\config")) {
    Rename-Item -path "$env:CWD\docker-data\config-dist" -newName "$env:CWD\docker-data\config"
}

if (-Not (Test-Path "$env:CWD\.env")) {
    Copy-Item -path "$env:CWD\.env-dist" -Destination "$env:CWD\.env"

    do {
        $PROJECTNAME = Read-Host -Prompt 'PROJECTNAME'
        (Get-Content "$env:CWD\.env") -replace 'PROJECTNAME=.*', "PROJECTNAME=$PROJECTNAME" | Set-Content "$env:CWD\.env"
    } while (-Not ($PROJECTNAME))

    $php_versions = '5.3','5.5','5.6','7.0','7.1','7.2'
    do {
        $PHP_VERSION = Read-Host -Prompt 'PHP_VERSION (5.3, 5.5, 5.6, 7.0, 7.1, [7.2])'
        if (-Not ($PHP_VERSION)) {
            $PHP_VERSION = '7.2'
        }
        (Get-Content "$env:CWD\.env") -replace 'PHP_VERSION=.*', "PHP_VERSION=$PHP_VERSION" | Set-Content "$env:CWD\.env"
    } while (-Not ($php_versions -match $PHP_VERSION))

    $mysql_versions = '5.5','5.7','8.0'
    do {
        $MYSQL_VERSION = Read-Host -Prompt 'MYSQL_VERSION (5.5, [5.7], 8.0)'
        if (-Not ($MYSQL_VERSION)) {
            $MYSQL_VERSION = '5.7'
        }
        (Get-Content "$env:CWD\.env") -replace 'MYSQL_VERSION=.*', "MYSQL_VERSION=$MYSQL_VERSION" | Set-Content "$env:CWD\.env"
    } while (-Not ($mysql_versions -match $MYSQL_VERSION))

    do {
        $MYSQL_ROOT_PASSWORD = Read-Host -Prompt 'MYSQL_ROOT_PASSWORD'
        (Get-Content "$env:CWD\.env") -replace 'MYSQL_ROOT_PASSWORD=.*', "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" | Set-Content "$env:CWD\.env"
    } while (-Not ($MYSQL_ROOT_PASSWORD))

    $phpmyadmin_version = '4,6','4.7'
    do {
        $PHPMYADMIN_VERSION = Read-Host -Prompt 'PHPMYADMIN_VERSION (4.6, [4.7])'
        if (-Not ($PHPMYADMIN_VERSION)) {
            $PHPMYADMIN_VERSION = '4.7'
        }
        (Get-Content "$env:CWD\.env") -replace 'PHPMYADMIN_VERSION=.*', "PHPMYADMIN_VERSION=$PHPMYADMIN_VERSION" | Set-Content "$env:CWD\.env"
    } while (-Not ($phpmyadmin_version -match $PHPMYADMIN_VERSION))

    $boolean_values = '0','1'
    do {
        $PHPMYADMIN_RESTRICTION = Read-Host -Prompt 'PHPMYADMIN_RESTRICTION (1, [0])'
        if (-Not ($PHPMYADMIN_RESTRICTION)) {
            $PHPMYADMIN_RESTRICTION = '0'
        }
        (Get-Content "$env:CWD\.env") -replace 'PHPMYADMIN_RESTRICTION=.*', "PHPMYADMIN_RESTRICTION=$PHPMYADMIN_RESTRICTION" | Set-Content "$env:CWD\.env"
    } while (-Not $boolean_values -match $PHPMYADMIN_RESTRICTION)

    $boolean_values = '0','1'
    do {
        $AUTOPULL = Read-Host -Prompt 'AUTOPULL (1, [0])'
        if (-Not ($AUTOPULL)) {
            $AUTOPULL = '0'
        }
        (Get-Content "$env:CWD\.env") -replace 'AUTOPULL=.*', "AUTOPULL=$AUTOPULL" | Set-Content "$env:CWD\.env"
    } while (-Not $boolean_values -match $AUTOPULL)

    $environment_values = 'development', 'test', 'stage', 'production'
    do {
        $ENVIRONMENT = Read-Host -Prompt 'ENVIRONMENT ([development], test, stage, production)'
        if (-Not ($ENVIRONMENT)) {
            $ENVIRONMENT = 'development'
        }
        (Get-Content "$env:CWD\.env") -replace 'ENVIRONMENT=.*', "ENVIRONMENT=$ENVIRONMENT" | Set-Content "$env:CWD\.env"
    } while (-Not $environment_values -match $ENVIRONMENT)

    do {
        $BASE_DOMAIN = Read-Host -Prompt "BASE_DOMAIN [$PROJECTNAME.lvh.me]"
        if (-Not ($BASE_DOMAIN)) {
            $BASE_DOMAIN = "$PROJECTNAME.lvh.me"
        }
        (Get-Content "$env:CWD\.env") -replace 'BASE_DOMAIN=.*', "BASE_DOMAIN=$BASE_DOMAIN" | Set-Content "$env:CWD\.env"
    } while (-Not ($BASE_DOMAIN) -Or -Not ($BASE_DOMAIN.EndsWith('.lvh.me')))

    do {
        $HTDOCS_FOLDER = Read-Host -Prompt 'HTDOCS_FOLDER [htdocs] (directory must exists)'
        if (-Not ($HTDOCS_FOLDER)) {
            $HTDOCS_FOLDER = 'htdocs'
        }
        (Get-Content "$env:CWD\.env") -replace 'HTDOCS_FOLDER=.*', "HTDOCS_FOLDER=$HTDOCS_FOLDER" | Set-Content "$env:CWD\.env"
    } while (-Not (Test-Path "$env:CWD\$HTDOCS_FOLDER"))

    $DOCUMENT_ROOT = Read-Host -Prompt 'DOCUMENT_ROOT'
    (Get-Content "$env:CWD\.env") -replace 'DOCUMENT_ROOT=.*', "DOCUMENT_ROOT=$DOCUMENT_ROOT" | Set-Content "$env:CWD\.env"
}

Write-Host "setup complete"

exit