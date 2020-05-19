:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
cd "$CWD"

. scripts/_unix/bootstrap.sh

cd "$OLDCWD"
exit

:CMDSCRIPT
SET OLDCWD=%cd%
SET CWD=%~dp0
CD "%CWD%"
IF %CWD:~-1%==\ SET CWD=%CWD:~0,-1%

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& { try { . "%cd%\scripts\_win\bootstrap.ps1" %* } catch { Write-Host "$_.Exception.Message" } }"

CD "%OLDCWD%"
EXIT /B
