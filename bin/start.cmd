:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

for PARAMETER in "$@"; do
    case "$PARAMETER" in
        "-d")   ADDITIONAL_CONFIGFILE="-f docker-data/config/docker-compose.debug.yml"
                break
                ;;
    esac
done

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

# Read .env file
eval $(cat "$(pwd)/.env" | grep -v ^# | sed 's/^([^$])/export $1/')

# Update debug IP
LOCALIP=$(ipconfig getifaddr en0)
sed -i '' "s/LOCAL_DEBUG_IP=.*$/LOCAL_DEBUG_IP=$LOCALIP/" "$(pwd)/.env"

printf "updating container images if needed ...\n"
docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE pull 1>/dev/null 2>&1

printf "updating proxy if needed ...\n"
docker network create proxy 1>/dev/null 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

printf "\nopening default browser (with 5s delay) ...\n"
sleep 5

if [[ "80" == "$PROXY_PORT" ]]; then
    open "http://www.$BASE_DOMAIN"
else
    open "http://www.$BASE_DOMAIN:$PROXY_PORT"
fi
exit

:CMDSCRIPT

set ADDITIONAL_CONFIGFILE=
for %%P in (%*) do (
    SET PARAMETER=%%P
    if "%PARAMETER%" == "-d" (
        SET ADDITIONAL_CONFIGFILE=-f docker-data/config/docker-compose.debug.yml
    )
)

IF NOT EXIST "%cd%\.env" (
    echo Environment File missing. Rename .env-dist to .env and customize it before starting this project.
    EXIT /B
)

for /f "delims== tokens=1,2" %%G in (%cd%\.env) do (
    call :startsWith "%%G" "#" || SET %%G=%%H
)

set thisip=localhost
for /f "delims=[] tokens=2" %%a in ('ping -4 %computername% -n 1 ^| findstr "["') do (
    set thisip=%%a
)
powershell -Command "(gc '%cd%\.env') -replace 'LOCAL_DEBUG_IP=.*$', 'LOCAL_DEBUG_IP=%thisip%' | Set-Content '%cd%\.env'"

for %%* in (.) do set CurrDirName=%%~nx*
call:toLower CurrDirName
set CurrDirName=%CurrDirName: =%
set CurrDirName=%CurrDirName:-=%

echo.
echo updating container images if needed ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.yml %ADDITIONAL_CONFIGFILE% pull 

echo.
echo updating proxy if needed ...
docker network create proxy > nul 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml -H tcp://127.0.0.1:2375 up -d > nul 2>&1

echo.
echo starting services ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.yml %ADDITIONAL_CONFIGFILE% up -d

echo.
echo opening default browser (with 5s delay) ...
timeout 5 > NUL

if "%PROXY_PORT%" == "80" (
    start http://www.%BASE_DOMAIN%
) else (
    start http://www.%BASE_DOMAIN%:%PROXY_PORT%
)
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

