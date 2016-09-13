:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

if [ ! -f "$(pwd)/docker-compose.live.yml " ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.live.yml" "$(pwd)/docker-compose.live.yml" >/dev/null
fi

printf "updating container images if needed ...\n"
docker-compose -f docker-compose.live.yml pull 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -f docker-compose.live.yml up -d

printf "\nApache is listening on: "
docker-compose -f docker-compose.live.yml port php 80
printf "PhpMyAdmin is listening on: "
docker-compose -f docker-compose.live.yml port phpmyadmin 80
exit

:CMDSCRIPT
IF NOT EXIST "%cd%\docker-compose.live.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.live.yml" "%cd%\docker-compose.live.yml" >NUL
)

echo.
echo updating container images if needed ...
docker-compose -f docker-compose.live.yml pull > nul 2>&1

echo.
echo starting services ...
docker-compose -f docker-compose.live.yml up -d

echo.
echo Apache is listening on:
docker-compose -f docker-compose.live.yml port php 80
echo PhpMyAdmin is listening on:
docker-compose -f docker-compose.live.yml port phpmyadmin 80
EXIT /B

