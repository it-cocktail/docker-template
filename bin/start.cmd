:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

if [ -z "$SECONDARY_DOMAIN" ]; then
    SECONDARY_DOMAIN=$BASE_DOMAIN
fi

DEBUGMODE=0
for PARAMETER in "$@"; do
    case "$PARAMETER" in
        "-d")
            ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.debug.yml"
            DEBUGMODE=1
            printf "***DEBUGMODE***\n\n"
            ;;
        *)
            echo "invalid parameter $PARAMETER"
            exit
            ;;
    esac
done

if [ -d "$JAVA_SRC_FOLDER" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.java.yml"
    printf "***Java Service will be activated***\n\n"
else
    echo "JAVA_SRC_FOLDER not found"
    exit 1
fi


printf "updating container images if needed ...\n"
docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE pull

printf "updating proxy if needed ...\n"
docker network create proxy 1>/dev/null 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d 1>/dev/null 2>&1

printf "\nstarting services ...\n"
export LOCAL_DEBUG_IP=$(ipconfig getifaddr en0) && docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

if [[ "80" == "$PROXY_PORT" ]]; then
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN"
    echo "http://phpmyadmin.$BASE_DOMAIN"
    echo "http://mail.$BASE_DOMAIN"
    if [ -d "$JAVA_SRC_FOLDER" ] && [ "$DEBUGMODE" == "1" ]; then
        echo "http://java.$BASE_DOMAIN"
    fi
else
    printf "\nServices:\n\n"
    echo "http://www.$BASE_DOMAIN:$PROXY_PORT"
    echo "http://phpmyadmin.$BASE_DOMAIN:$PROXY_PORT"
    echo "http://mail.$BASE_DOMAIN:$PROXY_PORT"
    if [ -d "$JAVA_SRC_FOLDER" ] && [ "$DEBUGMODE" == "1" ]; then
        echo "http://java.$BASE_DOMAIN:$PROXY_PORT"
    fi
fi

cd "$OLDCWD"
exit

:CMDSCRIPT

SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"

IF NOT EXIST "%cd%\.env" (
    echo Environment File missing. Rename .env-dist to .env and customize it before starting this project.
    EXIT /B
)

for /f "delims== tokens=1,2" %%G in (%cd%\.env) do (
    call :startsWith "%%G" "#" || SET %%G=%%H
)
if [%SECONDARY_DOMAIN%] == [] (
    SET SECONDARY_DOMAIN=%BASE_DOMAIN%
)

set ADDITIONAL_CONFIGFILE=
set DEGUBGMODE=0
for %%P in (%*) do (
    SET PARAMETER=%%P
    if "%PARAMETER%" == "-d" (
        SET ADDITIONAL_CONFIGFILE=%ADDITIONAL_CONFIGFILE% -f docker-data/config/docker-compose.debug.yml
        echo ***DEBUGMODE***
        set DEBUGMODE=1
    ) else if "%PARAMETER%" == "--with-java" (
        echo --with-java is deprecated. Java will start automatically if JAVA_SRC_FOLDER exists.
    ) else (
        echo invalid parameter %PARAMETER%
        EXIT /B
    )
)

if exist %JAVA_SRC_FOLDER%\nul (
    SET ADDITIONAL_CONFIGFILE=%ADDITIONAL_CONFIGFILE% -f docker-data/config/docker-compose.java.yml
    echo ***Java Service will be activated***
) else (
    echo JAVA_SRC_FOLDER not found
)


set LOCAL_DEBUG_IP=localhost
for /f "delims=[] tokens=2" %%a in ('ping -4 %computername% -n 1 ^| findstr "["') do (
    set LOCAL_DEBUG_IP=%%a
)

set Projectname=%~dp0
set Projectname=%Projectname:~0,-5%
for %%* in (%Projectname%) do set Projectname=%%~nx*
set Projectname=%Projectname: =%
set Projectname=%Projectname:-=%
set Projectname=%Projectname:.=%

echo.
echo updating container images if needed ...
docker-compose -p "%Projectname%" -f docker-data/config/docker-compose.yml %ADDITIONAL_CONFIGFILE% pull

echo.
echo updating proxy if needed ...
docker network create proxy > nul 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml -H tcp://127.0.0.1:2375 up -d > nul 2>&1

echo.
echo starting services ...
docker-compose -p "%Projectname%" -f docker-data/config/docker-compose.yml %ADDITIONAL_CONFIGFILE% up -d

echo.

if "%PROXY_PORT%" == "80" (
    echo Services:
    echo.
    echo http://www.%BASE_DOMAIN%
    echo http://phpmyadmin.%BASE_DOMAIN%
    echo http://mail.%BASE_DOMAIN%
    if exist %JAVA_SRC_FOLDER%\nul (
        if "%DEBUGMODE%"=="1" (
            echo http://java.%BASE_DOMAIN%
        )
    )
) else (
    echo Services:
    echo.
    echo http://www.%BASE_DOMAIN%:%PROXY_PORT%
    echo http://phpmyadmin.%BASE_DOMAIN%:%PROXY_PORT%
    echo http://mail.%BASE_DOMAIN%:%PROXY_PORT%
    if exist %JAVA_SRC_FOLDER%\nul (
        if "%DEBUGMODE%"=="1" (
            echo http://java.%BASE_DOMAIN%:%PROXY_PORT%
        )
    )
)

CD "%OLDCWD%"
EXIT /B

:toLower str -- converts uppercase character to lowercase
::           -- str [in,out] - valref of string variable to be converted
:$created 20060101 :$changed 20080219 :$categories StringManipulation
:$source http://www.dostips.com
if not defined %~1 EXIT /B
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "Ä=ä"
            "Ö=ö" "Ü=ü") do (
    call set %~1=%%%~1:%%~a%%
)
EXIT /B

:startsWith text string -- Tests if a text starts with a given string
::                      -- [IN] text   - text to be searched
::                      -- [IN] string - string to be tested for
:$created 20080320 :$changed 20080320 :$categories StringOperation,Condition
:$source http://www.dostips.com
SETLOCAL
set "txt=%~1"
set "str=%~2"
if defined str call set "s=%str%%%txt:*%str%=%%"
if /i "%txt%" NEQ "%s%" set=2>NUL
EXIT /B

