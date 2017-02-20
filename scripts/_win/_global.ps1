if (-Not (Test-Path "$env:CWD\.env")) {
    throw "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
}

if (-Not (Test-Path "$env:CWD\docker-data\config")) {
    throw "docker-data\config is missing. Rename docker-data\config-dist to docker-data\config and customize it before starting this project."
}


$lines = cat .env
foreach ($line in $lines) {
    if (-Not ($line.StartsWith('#'))) {
        $parts = $line.Split('=')
        if ($parts.Length -eq 2) {
            [Environment]::SetEnvironmentVariable($parts[0], $parts[1])
        }
    }
}

if (-Not ($env:PROJECTNAME)) {
    $PROJECTNAME = gi $env:CWD | select -expand basename
    [Environment]::SetEnvironmentVariable("PROJECTNAME", $PROJECTNAME)
}

if (-Not ($env:PHPMYADMIN_VIRTUAL_HOST)) {
    [Environment]::SetEnvironmentVariable("PHPMYADMIN_VIRTUAL_HOST", "phpmyadmin." + $env:BASE_DOMAIN)
}

if (-Not ($env:PHP_VIRTUAL_HOST)) {
    [Environment]::SetEnvironmentVariable("PHP_VIRTUAL_HOST", "www." + $env:BASE_DOMAIN)
}

if (-Not ($env:MAIL_VIRTUAL_HOST)) {
    [Environment]::SetEnvironmentVariable("MAIL_VIRTUAL_HOST", "mail." + $env:BASE_DOMAIN)
}
