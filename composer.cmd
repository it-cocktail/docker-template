:; docker-compose exec php composer $@; exit $?
@ECHO OFF
docker-compose exec php composer %*
