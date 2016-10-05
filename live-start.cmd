:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

cp "$(pwd)/docker-data/config/docker-compose.yml" "$(pwd)/docker-compose.yml" >/dev/null

printf "updating container images if needed ...\n"
docker-compose -f docker-compose.live.yml pull 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -f docker-data/config/docker-compose.live.yml up -d

printf "\nApplication is listening on: "
docker-compose port nginx 80
exit

:CMDSCRIPT

COPY "%cd%\docker-data\config\docker-compose.yml" "%cd%\docker-compose.yml" >NUL

echo.
echo updating container images if needed ...
docker-compose -f docker-data/config/docker-compose.live.yml pull > nul 2>&1

echo.
echo starting services ...
docker-compose -f docker-compose.live.yml up -d

echo.
echo Application is listening on:
docker-compose port nginx 80
EXIT /B

