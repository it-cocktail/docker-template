:<<"::CMDLITERAL"
@ECHO OFF
SETLOCAL
GOTO :CMDSCRIPT
::CMDLITERAL

if [ ! -f "$(pwd)/docker-compose.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.yml" "$(pwd)/docker-compose.yml" >/dev/null
fi
if [ ! -f "$(pwd)/docker-compose.override.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.override.yml" "$(pwd)/docker-compose.override.yml" >/dev/null
fi
if [ ! -f "$(pwd)/docker-compose.debug.yml" ]; then
    LOCALIP=$(ipconfig getifaddr en0)
    cp "$(pwd)/docker-data/config-dist/docker-compose.debug.yml" "$(pwd)/docker-compose.debug.yml" >/dev/null
    sed -i '' "s/localhost/$LOCALIP/" "$(pwd)/docker-compose.debug.yml"
fi
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d --build
exit

:CMDSCRIPT
IF NOT EXIST "%cd%\docker-compose.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.yml" "%cd%\docker-compose.yml" >NUL
)
IF NOT EXIST "%cd%\docker-compose.override.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.override.yml" "%cd%\docker-compose.override.yml" >NUL
)
IF NOT EXIST "%cd%\docker-compose.debug.yml" (
    FOR /F "tokens=4 delims= " %%i IN ('route print ^| find " 0.0.0.0"') DO (
        powershell -Command "(gc '%cd%\docker-data\config-dist\docker-compose.debug.yml') -replace 'localhost', '%%i' | Set-Content '%cd%\docker-compose.debug.yml'"
    )
)
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d --build
EXIT /B

