:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

COMMAND=$(echo $0 | sed "s/bin\/\(.*\)\.cmd/bin\/_unix\/\\1.sh/")
. bin/_unix/_global.sh
. $COMMAND

cd "$OLDCWD"
exit

:CMDSCRIPT
SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"

set COMMAND=%0
set COMMAND=%COMMAND:cmd=ps1%
set COMMAND=%COMMAND:bin\=bin\_win\%

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& { try { . %cd%\bin\_win\_global.ps1; %cd%\%COMMAND% %* } catch { Write-Host "$_.Exception.Message" } }"

CD "%OLDCWD%"
EXIT /B
