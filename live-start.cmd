:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

printf "updating container images if needed ...\n"
docker-compose -f docker-compose.live.yml pull 1>/dev/null 2>&1

printf "\nstarting services ...\n"
docker-compose -f docker-data/config/docker-compose.live.yml up -d
exit

:CMDSCRIPT
for %%* in (.) do set CurrDirName=%%~nx*
call:toLower CurrDirName
set CurrDirName=%CurrDirName: =%
set CurrDirName=%CurrDirName:-=%

echo.
echo updating container images if needed ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.live.yml pull > nul 2>&1

echo.
echo starting services ...
docker-compose -p "%CurrDirName%" -f docker-data/config/docker-compose.live.yml up -d
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

