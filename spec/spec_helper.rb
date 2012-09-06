require 'ipfixer_client'

def windows_service_installed?(service_name)
  response = `sc query #{service_name}`
  return false if response =~ /FAILED 1060/i
  return true
end