:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
cd "$CWD"

COMMAND=$1
shift

if [ "$COMMAND" == "" ]; then
    COMMAND="help"
fi

if [ ! -e "$CWD/scripts/_unix/$COMMAND.sh" ]; then
    echo "Error: Command $COMMAND not found. Use help to see available commands."
    exit
fi

# setting permissions
chmod 755 scripts/_unix/*.sh

. scripts/_unix/_global.sh
. scripts/_unix/$COMMAND.sh

cd "$OLDCWD"
exit

:CMDSCRIPT
SET OLDCWD=%cd%
SET CWD=%~dp0
CD "%CWD%"

SET COMMAND=%1

IF "%COMMAND%" EQU "" (
    SET COMMAND=help
)

IF NOT EXIST "%cd%\scripts\_win\%COMMAND%.ps1" (
    ECHO Error: Command %COMMAND% not found. Use help to see available commands.
    EXIT /B
)

FOR /F "tokens=1,* delims= " %%a IN ("%*") DO SET ARGS=%%b

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& { try { . "%cd%\scripts\_win\_global.ps1"; "%cd%\scripts\_win\%COMMAND%.ps1" %ARGS% } catch { Write-Host "$_.Exception.Message" } }"

CD "%OLDCWD%"
EXIT /B
