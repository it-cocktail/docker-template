#!/bin/sh

scripts/_unix/stop.sh

LATEST_TAG=$(git ls-remote --tags --refs https://github.com/orange-hive/docker-template.git | awk -F/ ' { print $3 }' | sed "s/release-//" | sort -t. -s -k 1,1n -k 2,2n -k 3,3n | tail -n 1)

if [ -e "$CWD/.version" ]; then
    CURRENT_VERSION=$(cat "$CWD/.version")
else
    CURRENT_VERSION="unknown"
fi

if [ "$CURRENT_VERSION" == "$LATEST_TAG" ]; then
    echo "already on latest version ($LATEST_TAG)"
else
    read -r -p "Upgrade from $CURRENT_VERSION to $LATEST_TAG? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            echo "checking out release $LATEST_TAG"
            mkdir "$CWD/.docker-update"
            cd "$CWD/.docker-update"
            git clone --branch release-$LATEST_TAG https://github.com/orange-hive/docker-template.git .
            rm -Rf .git

            if [ -d "$CWD/docker-data/volumes/mysql" ] && [ ! -d "$CWD/docker-data/volumes/mysql/data" ]; then
                echo "moving old MySQL volume"
                mkdir "$CWD/docker-data/volumes/mysql/data"
                cd "$CWD/docker-data/volumes/mysql"
                mv * data 1> /dev/null 2>&1
                cd "$CWD/.docker-update"
            fi

            if [ -d "$CWD/docker-data" ]; then
                echo "backuping docker-data"
                isodt=$(date "+%Y-%m-%dT%H:%M:%S")
                cp -R "$CWD/docker-data" "$CWD/docker-data.backup_$isodt"


                if [ -d "$CWD/docker-data/config-dist" ]; then
                    rm -Rf "$CWD/docker-data/config-dist"
                fi

                if [ -d "$CWD/docker-data/volumes/mysql/config" ]; then
                    rm -Rf "$CWD/docker-data/volumes/mysql/config"
                fi

                if [ -d "$CWD/docker-data/volumes/php" ]; then
                    rm -Rf "$CWD/docker-data/volumes/php"
                fi

                if [ -d "$CWD/docker-data/volumes/phpmyadmin" ]; then
                    rm -Rf "$CWD/docker-data/volumes/phpmyadmin"
                fi
            fi

            echo "updating"
            if [ -d "$CWD/bin" ]; then
                rm -Rf "$CWD/bin"
            fi
            if [ -d "$CWD/scripts" ]; then
                rm -Rf "$CWD/scripts"
            fi
            cp -R * "$CWD"
            cp -R .[^.]* "$CWD"

            echo "$LATEST_TAG" > "$CWD/.version"

            rm -Rf "$CWD/.docker-update"
            echo "done"
            echo "Please compare your .env file with the .env-dist file to add new or changed entries and look into the config-dist folder also."
            ;;
        *)
            echo "not updating"
            ;;
    esac
fi

exit
