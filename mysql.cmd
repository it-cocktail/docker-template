:; docker-compose exec db mysql $@; exit $?
@ECHO OFF
for %%* in (.) do set CurrDirName=%%~nx*
docker exec -it %CurrDirName%_db_1 mysql %*
