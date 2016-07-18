:; docker-compose exec db mysql $@; exit $?
@ECHO OFF
docker exec -it %cd%_db_1 mysql %*
