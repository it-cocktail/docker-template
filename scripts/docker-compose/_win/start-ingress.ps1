
Invoke-Expression "& { docker compose -p `"ingress`" -f docker-compose\docker-compose-ingress.yml pull }"

Write-Host "`nstarting ingress ..."
Invoke-Expression "& { docker compose -p `"ingress`" -f docker-compose\docker-compose-ingress.yml up -d }"

exit
