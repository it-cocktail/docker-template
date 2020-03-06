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

$envHash.PROJECTNAME = $envHash.PROJECTNAME.toLower() -replace '[/\\.:,]', '-'
$envHash.ENVIRONMENT = $envHash.ENVIRONMENT.toLower() -replace '[/\\.:,]', '-'

function global:Parse-File([String] $file) {
    $lines = Get-Content -Path "$file"
    foreach ($placeholder in $envHash.keys) {
        $lines = $lines.replace("{`$$placeholder}", $envHash[$placeholder])
    }
    $lines = $lines.replace("{`$CWD}", $env:CWD)

    return $lines
}

[Environment]::SetEnvironmentVariable('COMPOSE_CONVERT_WINDOWS_PATHS', 1)
