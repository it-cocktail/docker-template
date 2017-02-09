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

export MAIL_VIRTUAL_HOST=
export PHP_VIRTUAL_HOST=
export PHPMYADMIN_VIRTUAL_HOST=

ADDITIONAL_CONFIGFILE=""
if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

if [ -z "$PROJECTNAME" ]; then
    PROJECTNAME="${PWD##*/}"
fi

docker-compose  -p "$PROJECTNAME" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.java.yml $ADDITIONAL_CONFIGFILE down

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

set MAIL_VIRTUAL_HOST=_
set PHP_VIRTUAL_HOST=_
set PHPMYADMIN_VIRTUAL_HOST=_

if [%PROJECTNAME%] EQU [] (
    set PROJECTNAME=%~dp0
    set PROJECTNAME=%PROJECTNAME:~0,-5%
    for %%* in (%PROJECTNAME%) do set PROJECTNAME=%%~nx*
    set PROJECTNAME=%PROJECTNAME: =%
    set PROJECTNAME=%PROJECTNAME:-=%
    set PROJECTNAME=%PROJECTNAME:.=%
)

SET ADDITIONAL_CONFIGFILE=
IF EXIST "%cd%\docker-data\config\docker-compose.custom.yml" (
    echo adding custom configuration
    SET ADDITIONAL_CONFIGFILE=%ADDITIONAL_CONFIGFILE% -f docker-data/config/docker-compose.custom.yml"
)


docker-compose  -p "%PROJECTNAME%" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.java.yml %ADDITIONAL_CONFIGFILE% down

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


