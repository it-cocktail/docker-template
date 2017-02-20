
. $env:CWD\bin\_win\stop.ps1

$LATEST_TAG = (git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-template.git | Out-String).toString() -replace '.*refs/tags/release-','' -split '\n' | Where-object{$_} | Sort-Object { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -Last 1

if (Test-Path "$env:CWD\.version") {
    $CURRENT_VERSION = cat "$env:CWD\.version"
} else {
    $CURRENT_VERSION = "unknown"
}

if ($CURRENT_VERSION -eq $LATEST_TAG) {
    Write-Host "already on latest version ($LATEST_TAG)"
} else {
    $choice = (read-host 'Upgrade from $CURRENT_VERSION to $LATEST_TAG? [y/N] ' | Out-String).toString()
    if ($choice -eq "y" -Or $choice -eq "Y") {
        Write-Host "checking out release $LATEST_TAG"
        mkdir "$env:CWD\.docker-update"
        git clone --branch release-$LATEST_TAG git@gitlab.orangehive.de:orangehive/docker-template.git "$env:CWD\.docker-update"
        rmdir /s /q "$env:CWD\.docker-update\.git"

        if (Test-Path "$env:CWD\docker-data\volumes\mysql" {
            if (-Not (Test-Path "$env:CWD\docker-data\volumes\mysql\data")) {
                Write-Host "moving old MySQL volume"
                mkdir "$env:CWD\docker-data\volumes\mysql\data"
                robocopy "$env:CWD\docker-data\volumes\mysql" "$env:CWD\docker-data\volumes\mysql\data" *.* /s /e /move /xd "$env:CWD\docker-data\volumes\mysql\data" > nul 2>&1
            }
        }

        if (Test-Path "$env:CWD\docker-data") {
            Write-Host "backing up docker-data"
            $date = (get-date -format 'yyyyMMddTHHmmss' | Out-String).toString()
            robocopy "$env:CWD\docker-data" "$env:CWD\docker-data.backup_$date" *.* /s /e > nul 2>&1
            rmdir /s /q "$env:CWD\docker-data\config-dist"

                if (Test-Path "$env:CWD\docker-data\config-dist") {
                    rmdir /s /q "$env:CWD\docker-data\config-dist"
                }

                if (Test-Path "$env:CWD\docker-data\volumes\mysql\config") {
                    rmdir /s /q "$env:CWD\docker-data\volumes\mysql\config"
                }

                if (Test-Path "$env:CWD\docker-data\volumes\php") {
                    rmdir /s /q "$env:CWD\docker-data\volumes\php"
                }

                if (Test-Path "$env:CWD\docker-data\volumes\phpmyadmin") {
                    rmdir /s /q "$env:CWD\docker-data\volumes\phpmyadmin"
                }

        }

        Write-Host "updating"
        rmdir /s /q "$env:CWD\bin"
        robocopy "$env:CWD\.docker-update" "$env:CWD" *.* /s /e > nul 2>&1
        rmdir /s /q "$env:CWD\.docker-update"
        Set-Content -Path "$env:CWD\.version" -Value "$LATEST_TAG"
        Write-Host "`nPlease compare your .env file with the .env-dist file to add new or changed entries and look into the config-dist folder also."
    } else {
        Write-Host "not upgrading"
    }
}

exit