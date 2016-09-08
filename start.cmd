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
docker-compose pull
docker-compose up -d
exit

:CMDSCRIPT
IF NOT EXIST "%cd%\docker-compose.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.yml" "%cd%\docker-compose.yml" >NUL
)
IF NOT EXIST "%cd%\docker-compose.override.yml" (
    COPY "%cd%\docker-data\config-dist\docker-compose.override.yml" "%cd%\docker-compose.override.yml" >NUL
)
docker-compose pull
docker-compose up -d --build
EXIT /B

