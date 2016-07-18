:; docker-compose exec php php $@; exit $?
@ECHO OFF
docker exec -it %cd%_php_1 php %*
