:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

docker-compose down
exit

:CMDSCRIPT
docker-compose down
EXIT /B
