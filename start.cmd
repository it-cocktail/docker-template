:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

cp "$(pwd)/docker-data/config/docker-compose.yml" "$(pwd)/docker-compose.yml" >/dev/null
if [ ! -f "$(pwd)/docker-compose.override.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.override.yml" "$(pwd)/docker-compose.override.yml" >/dev/null
fi

printf "updating container images if needed ...\n"
docker-compose -f docker-compose.yml -f docker-compose.override.yml pull 1>/dev/null 2>&1

printf "updating proxy if needed ...\n"
docker network create proxy 1>/dev/null 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
exit

:CMDSCRIPT

COPY "%cd%\docker-data\config\docker-compose.yml" "%cd%\docker-compose.yml" >NUL
IF NOT EXIST "%cd%\docker-compose.override.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.override.yml" "%cd%\docker-compose.override.yml" >NUL
)

echo.
echo updating container images if needed ...
docker-compose -f docker-compose.yml -f docker-compose.override.yml pull > nul 2>&1

echo.
echo updating container images if needed ...
docker network create proxy > nul 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d > nul 2>&1

echo.
echo starting services ...
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
EXIT /B

