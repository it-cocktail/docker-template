Get-ChildItem "$env:CWD\scripts\_win" -Filter *.ps1 |
Foreach-Object {
    $command = [io.path]::GetFileNameWithoutExtension($_.FullName)

    if (-Not ($command.StartsWith("_"))) {
        Write-Host -NoNewline "$command "
    }
}

exit
