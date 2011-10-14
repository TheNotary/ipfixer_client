@ECHO OFF
echo # Removing ipfixer from the services list

sc stop ipfixer_svc
ruby ipfixer_reg.rb remove