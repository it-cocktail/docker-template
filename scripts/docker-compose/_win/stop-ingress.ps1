
Write-Host "`nstopping ingress ..."
Invoke-Expression "& { docker-compose -p `"ingress`" -f docker-compose\docker-compose-ingress.yml down 2>$null }"

exit
