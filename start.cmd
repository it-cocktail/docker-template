:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

if [ ! -f "$(pwd)/docker-compose.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.yml" "$(pwd)/docker-compose.yml" >/dev/null
fi
if [ ! -f "$(pwd)/docker-compose.override.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.override.yml" "$(pwd)/docker-compose.override.yml" >/dev/null
fi

printf "updating container images if needed ...\n"
docker-compose pull 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose up -d

printf "\nApache is listening on: "
docker-compose port php 80
printf "PhpMyAdmin is listening on: "
docker-compose port phpmyadmin 80
printf "MailHog is listening on: "
docker-compose port mail 8025
exit

:CMDSCRIPT
IF NOT EXIST "%cd%\docker-compose.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.yml" "%cd%\docker-compose.yml" >NUL
)
IF NOT EXIST "%cd%\docker-compose.override.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.override.yml" "%cd%\docker-compose.override.yml" >NUL
)

echo.
echo updating container images if needed ...
docker-compose pull > nul 2>&1

echo.
echo starting services ...
docker-compose up -d

echo.
echo Apache is listening on:
docker-compose port php 80
echo PhpMyAdmin is listening on:
docker-compose port phpmyadmin 80
echo MailHog is listening on:
docker-compose port mail 8025
EXIT /B

