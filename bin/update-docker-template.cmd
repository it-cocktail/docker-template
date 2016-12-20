:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

LATEST_TAG=$(git ls-remote --tags git@gitlab.orangehive.de:orangehive/docker-template.git | grep -v "\^" | awk -F/ ' { print $3 }' | sed "s/release-//" | sort -t. -s -k 1,1n -k 2,2n -k 3,3n | tail -n 1)

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
            echo updating...
            mkdir "$CWD/.docker-update"
            cd "$CWD/.docker-update"
            git clone --branch release-$LATEST_TAG git@gitlab.orangehive.de:orangehive/docker-template.git . 1> /dev/null 2>&1
            rm -Rf .git
            cp -R * "$CWD"
            cp -R .[^.]* "$CWD"

            echo "$LATEST_TAG" > "$CWD/.version"

            rm -Rf "$CWD/.docker-update"
            echo "done"
            ;;
        *)
            echo "not updating"
            ;;
    esac
fi

cd "$OLDCWD"
exit

:CMDSCRIPT
SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"


CD "%OLDCWD%"
EXIT /B
