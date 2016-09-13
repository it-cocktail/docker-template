:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

docker-compose -f docker-compose.live.yml down
exit

:CMDSCRIPT
docker-compose -f docker-compose.live.yml down
EXIT /B

