:; docker-compose exec php bash; exit $?
@ECHO OFF
for %%* in (.) do set CurrDirName=%%~nx*
docker exec -it %CurrDirName%_php_1 bash
