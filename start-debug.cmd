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
if [ ! -f "$(pwd)/docker-compose.debug.yml" ]; then
    cp "$(pwd)/docker-data/config-dist/docker-compose.debug.yml" "$(pwd)/docker-compose.debug.yml" >/dev/null
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
    COPY "%cd%\docker-data\config-dist\docker-compose.debug.yml" "%cd%\docker-compose.debug.yml" >NUL
)
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d --build
EXIT /B

