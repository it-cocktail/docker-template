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
            echo "checking out release $LATEST_TAG"
            mkdir "$CWD/.docker-update"
            cd "$CWD/.docker-update"
            git clone --branch release-$LATEST_TAG git@gitlab.orangehive.de:orangehive/docker-template.git .
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
                mv "$CWD/docker-data" "$CWD/docker-data.backup_$isodt"
                mkdir "$CWD/docker-data"

                if [ -d "$CWD/docker-data.backup_$isodt/volumes/mysql" ] && [ -d "$CWD/docker-data.backup_$isodt/volumes/mysql/data" ]; then
                    mkdir "$CWD/docker-data/volumes"
                    mkdir "$CWD/docker-data/volumes/mysql"
                    cp -R "$CWD/docker-data.backup_$isodt/volumes/mysql/data" "$CWD/docker-data/volumes/mysql"
                fi
            fi

            echo "updating"
            cp -R * "$CWD"
            cp -R .[^.]* "$CWD"

            echo "$LATEST_TAG" > "$CWD/.version"

            rm -Rf "$CWD/.docker-update"
            echo "done"
            echo "Please compare your .env file with the .env-dist file to add new or changed entries"
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
        echo checking out release %LATEST_TAG%
        mkdir "%cd%\.docker-update"
        git clone --branch release-%LATEST_TAG% git@gitlab.orangehive.de:orangehive/docker-template.git "%cd%\.docker-update"
        rmdir /s /q "%cd%\.docker-update\.git"

        if exist %cd%\docker-data\volumes\mysql\nul (
            if not exist %cd%\docker-data\volumes\mysql\data\nul (
                echo moving old MySQL volume
                mkdir "%cd%\docker-data\volumes\mysql\data"
                robocopy "%cd%\docker-data\volumes\mysql" "%cd%\docker-data\volumes\mysql\data" *.* /s /e /move /xd "%cd%\docker-data\volumes\mysql\data" > nul 2>&1
            )
        )

        if exist %cd%\docker-data\nul (
            echo backuping docker-data
            for /f "usebackq delims=" %%d in (`powershell.exe "& { (get-date -format 'yyyyMMddTHHmmss' | Out-String).toString() }"`) DO (
                robocopy "%cd%\docker-data" "%cd%\docker-data.backup_%%d" *.* /s /e /move > nul 2>&1
                mkdir "%cd%\docker-data"

                if exist %cd%\docker-data.backup_%%d\volumes\mysql\nul (
                    if exist %cd%\docker-data\volumes\mysql\data\nul (
                        mkdir "%cd%\docker-data\volumes"
                        mkdir "%cd%\docker-data\volumes\mysql"
                        mkdir "%cd%\docker-data\volumes\mysql\data"
                        robocopy "%cd%\docker-data.backup.backup_%%d\volumes\mysql\data" "%cd%\docker-data\volumes\mysql\data" *.* /s /e > nul 2>&1
                    )
                )

            )
        )

        echo updating
        (robocopy "%cd%\.docker-update" "%cd%" *.* /s /e > nul 2>&1) ^& (
            rmdir /s /q "%cd%\.docker-update"
            echo %LATEST_TAG%>"%cd%\.version"
            echo .
            echo Please compare your .env file with the .env-dist file to add new or changed entries
            goto End
        )

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