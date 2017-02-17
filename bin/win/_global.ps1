$lines = cat .env

foreach ($line in $lines) {
    if (-Not ($line.StartsWith('#'))) {
        $parts = $line.Split('=')
        if ($parts.Length -eq 2) {
            [Environment]::SetEnvironmentVariable($parts[0], $parts[1])
        }
    }
}

if (-Not $env:PROJECTNAME) {
    $PROJECTNAME = ($env:CWD.ToLower() -replace "^.*\\","" | Out-String).ToString() -replace "[ -\.]",""
    [Environment]::SetEnvironmentVariable("PROJECTNAME", $PROJECTNAME)
}