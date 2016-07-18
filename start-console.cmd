:; docker-compose exec php bash; exit $?
@ECHO OFF
docker exec -it %cd%_php_1 bash
