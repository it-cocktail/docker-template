if (-Not (Test-Path "$env:CWD\.env")) {
    throw "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
}

$global:envHash = @{}

$lines = Get-Content -Path .env
foreach ($line in $lines) {
    if (-Not ($line.StartsWith('#'))) {
        $parts = $line.Split('=')
        if ($parts.Length -eq 2) {
            $envHash[$parts[0]] = $parts[1]
        }
    }
}

if ("$RUNTIME" -eq "docker-compose")
{
    if ( -Not("$($envHash.MYSQL_PORT)" -Eq "") )
    {
        $envHash.MYSQL_PORT = $envHash.MYSQL_PORT + ":  3306"
    } else {
        $envHash.MYSQL_PORT = "3306"
    }
}

$COMMAND, $args = $args

if (-Not ($COMMAND)) {
    $COMMAND = 'help'
}

$RUNTIME = $envHash.RUNTIME

if (-Not (Test-Path "$env:CWD\scripts\$RUNTIME\_win\$COMMAND.ps1")) {
    throw "Error: Command $COMMAND not found. Use help to see available commands."
}

. scripts/$RUNTIME/_win/_global.ps1
. scripts/$RUNTIME/_win/$COMMAND.ps1

