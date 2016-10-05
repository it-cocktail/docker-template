:<<"::CMDLITERAL"
@ECHO OFF
SETLOCAL
GOTO :CMDSCRIPT
::CMDLITERAL

cp "$(pwd)/docker-data/config-dist/docker-compose.yml" "$(pwd)/docker-compose.yml" >/dev/null
if [ ! -f "$(pwd)/docker-compose.override.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.override.yml" "$(pwd)/docker-compose.override.yml" >/dev/null
fi
if [ ! -f "$(pwd)/docker-compose.debug.yml" ]; then
    LOCALIP=$(ipconfig getifaddr en0)
    cp "$(pwd)/docker-data/config-dist/docker-compose.debug.yml" "$(pwd)/docker-compose.debug.yml" >/dev/null
    sed -i '' "s/localhost/$LOCALIP/" "$(pwd)/docker-compose.debug.yml"
fi

printf "updating container images if needed ...\n"
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml pull 1>/dev/null 2>&1

printf "updating proxy if needed ...\n"
docker network create proxy 1>/dev/null 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d
exit

:CMDSCRIPT
COPY "%cd%\docker-data\config-dist\docker-compose.yml" "%cd%\docker-compose.yml" >NUL
IF NOT EXIST "%cd%\docker-compose.override.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.override.yml" "%cd%\docker-compose.override.yml" >NUL
)
IF NOT EXIST "%cd%\docker-compose.debug.yml" (
    FOR /F "tokens=4 delims= " %%i IN ('route print ^| find " 0.0.0.0"') DO (
        powershell -Command "(gc '%cd%\docker-data\config-dist\docker-compose.debug.yml') -replace 'localhost', '%%i' | Set-Content '%cd%\docker-compose.debug.yml'"
    )
)

echo.
echo updating container images if needed ...
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml pull > nul 2>&1

echo.
echo updating container images if needed ...
docker network create proxy > nul 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml -H tcp://127.0.0.1:2375 up -d > nul 2>&1

echo.
echo starting services ...
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d
EXIT /B

