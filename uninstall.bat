@ECHO OFF
echo Removing ipfixer from the services list

sc stop ipfixer_svc
ruby ipfixer_installer.rb remove


rem   remove even the uninstall script


rem   DEL "%~f0"

pause