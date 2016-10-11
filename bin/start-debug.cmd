:<<"::CMDLITERAL"
@ECHO OFF
SETLOCAL
GOTO :CMDSCRIPT
::CMDLITERAL

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

LOCALIP=$(ipconfig getifaddr en0)
sed -i '' "s/LOCAL_DEBUG_IP=localhost/LOCAL_DEBUG_IP=$LOCALIP/" "$(pwd)/.env"

printf "updating container images if needed ...\n"
docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.debug.yml pull 1>/dev/null 2>&1

printf "updating proxy if needed ...\n"
docker network create proxy 1>/dev/null 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml up -d 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -p "${PWD##*/}" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.debug.yml up -d
exit

:CMDSCRIPT
IF NOT EXIST "%cd%\.env" (
    echo Environment File missing. Rename .env-dist to .env and customize it before starting this project.
    EXIT /B
)

for %%* in (.) do set CurrDirName=%%~nx*
call:toLower CurrDirName
set CurrDirName=%CurrDirName: =%
set CurrDirName=%CurrDirName:-=%

FOR /F "tokens=4 delims= " %%i IN ('route print ^| find " 0.0.0.0"') DO (
    powershell -Command "(gc '%cd%\.env') -replace 'LOCAL_DEBUG_IP=localhost', 'LOCAL_DEBUG_IP=%%i' | Set-Content '%cd%\.env'"
)

echo.
echo updating container images if needed ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.debug.yml pull > nul 2>&1

echo.
echo updating container images if needed ...
docker network create proxy > nul 2>&1
docker-compose -f docker-data/config/docker-compose.proxy.yml -H tcp://127.0.0.1:2375 up -d > nul 2>&1

echo.
echo starting services ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.yml -f docker-data/config/docker-compose.debug.yml up -d
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

