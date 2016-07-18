:; docker-compose exec php composer $@; exit $?
@ECHO OFF
docker exec -it %cd%_php_1 composer %*
