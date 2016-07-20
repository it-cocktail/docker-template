:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d --build
exit

:CMDSCRIPT
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.debug.yml up -d --build
EXIT /B
