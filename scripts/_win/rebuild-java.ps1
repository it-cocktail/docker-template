if (-Not (Test-Path "$env:JAVA_SRC_FOLDER")) {
    throw "No JAVA_SRC_FOLDER specified"
}

docker-compose -p "$env:PROJECTNAME" -f docker-data\config\base\docker-compose.yml -f docker-data\config\base\docker-compose.java.yml exec java /restart.sh

exit
