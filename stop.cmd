:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

docker-compose -f docker-compose.yml -f docker-compose.override.yml down
exit

:CMDSCRIPT
docker-compose -f docker-compose.yml -f docker-compose.override.yml down
EXIT /B

