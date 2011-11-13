@ECHO OFF
REM Before running, make sure you run "gem install win32-service"
REM Also, make sure you run it as administrator
pause

ruby -v|findstr /r "ruby" >nul

IF %errorlevel% == 0 goto beginwork

echo ********************************************
echo * ALERT  ALERT  ALERT  ALERT  ALERT  ALERT *
echo ********************************************
echo * Operation canceled! Ruby not installed!  *
echo ********************************************
pause
goto finished

:beginwork


REM Check if service by this name is already installed

sc query ipfixer_svc >nul

REM 0 means we have a service by that name and we should Then we we'll need to run over :unregister... man, I can't believe it works this way...

if %errorlevel% == 1060 goto register   



:unregister
echo
echo #### Removing ipfixer from the services list
sc stop ipfixer_svc
ruby ipfixer_reg.rb remove




:register
echo
echo #### Installing and running ipfixer

ruby ipfixer_reg.rb

sc start ipfixer_svc



:finished
