:; docker-compose exec php php $@; exit $?
@ECHO OFF
docker-compose exec php php %*
