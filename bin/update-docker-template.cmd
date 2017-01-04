:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

LATEST_TAG=$(git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-template.git | awk -F/ ' { print $3 }' | sed "s/release-//" | sort -t. -s -k 1,1n -k 2,2n -k 3,3n | tail -n 1)

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

            if [ -d "$CWD/docker-data/volumes/mysql" ] && [ ! -d "$CWD/docker-data/volumes/mysql/data" ]; then
                echo "moving old MySQL volume"
                mkdir "$CWD/docker-data/volumes/mysql/data"
                cd "$CWD/docker-data/volumes/mysql"
                mv * data 1> /dev/null 2>&1
                cd "$CWD/.docker-update"
            fi
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
setlocal

SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"

for /f "usebackq delims=" %%v in (`powershell.exe "& { (git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-template.git | Out-String).toString() -replace '.*refs/tags/release-','' -split '\n' | Where-object{$_} | Sort-Object { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -Last 1 }"`) DO set "LATEST_TAG=%%v"

if exist "%cd%/.version" (
    set /p CURRENT_VERSION=<"%cd%/.version"
) else (
    set CURRENT_VERSION=unknown
)

if "%CURRENT_VERSION%" == "%LATEST_TAG%" (
    echo already on latest version ^(%LATEST_TAG%^)
) else (
    set choice=n
    for /f "usebackq delims=" %%c in (`powershell.exe "& { (read-host 'Upgrade from %CURRENT_VERSION% to %LATEST_TAG%? [y/N] ' | Out-String).toString() }"`) DO (
        if "%%c" == "y" goto Yes
        if "%%c" == "Y" goto Yes

        echo not upgrading

        Goto End

        :Yes
        echo updating...
        mkdir "%cd%\.docker-update"
        git clone --branch release-%LATEST_TAG% git@gitlab.orangehive.de:orangehive/docker-template.git "%cd%\.docker-update" > nul 2>&1
        rmdir /s /q "%cd%\.docker-update\.git"

        if exist %cd%\docker-data\volumes\mysql\nul (
            if not exist %cd%\docker-data\volumes\mysql\data\nul (
                echo moving old MySQL volume
                mkdir "%cd%\docker-data\volumes\mysql\data"
                robocopy "%cd%\docker-data\volumes\mysql" "%cd%\docker-data\volumes\mysql\data" *.* /s /e /move /xd "%cd%\docker-data\volumes\mysql\data" > nul 2>&1
            )
        )
        robocopy "%cd%\.docker-update" "%cd%" *.* /s /e  > nul 2>&1

        echo %LATEST_TAG%>"%cd%\.version"

        rmdir /s /q "%CWD%\.docker-update"

        :End
        echo done
    )

)

CD "%OLDCWD%"

endlocal
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