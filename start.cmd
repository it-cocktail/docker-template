:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

docker-compose up -d --build
exit

:CMDSCRIPT
docker-compose up -d --build
EXIT /B
