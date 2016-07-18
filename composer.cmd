:; docker-compose exec php composer $@; exit $?
@ECHO OFF
for %%* in (.) do set CurrDirName=%%~nx*
docker exec -it %CurrDirName%_php_1 composer %*
