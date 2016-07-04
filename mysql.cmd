:; docker-compose exec db mysql $@; exit $?
@ECHO OFF
docker-compose exec db mysql %*
