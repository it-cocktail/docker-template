:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.java.yml logs -f $1

cd "$OLDCWD"
exit

:CMDSCRIPT
SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"

set Projectname=%~dp0
set Projectname=%Projectname:~0,-5%
for %%* in (%Projectname%) do set Projectname=%%~nx*
set Projectname=%Projectname: =%
set Projectname=%Projectname:-=%
set Projectname=%Projectname:.=%

start docker-compose -p "%Projectname%" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.java.yml logs -f %1

CD "%OLDCWD%"

:EOF
EXIT /B
