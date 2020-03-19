$global:cwdSanatized = $env:CWD -replace '\\', '/'
$global:cwdSanatized = $global:cwdSanatized.substring(0,1).tolower() + $global:cwdSanatized.substring(1)
$global:cwdSanatized = "/" + ($cwdSanatized -replace ':', '')
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
    $lines = $lines.replace("{`$CWD}", $cwdSanatized)

    return $lines
}

[Environment]::SetEnvironmentVariable('COMPOSE_CONVERT_WINDOWS_PATHS', 1)
