module IpfixerClient
  # http://stackoverflow.com/questions/163497/running-a-ruby-program-as-a-windows-service
  # Use the register
  #
  # $ gem install win32-service
  
  # allows us to read yaml files
  # load "config_stuff.rb" # requires 'yaml'
  config = get_configuration_settings
  
  
  # Point this at your hub
  IP_FIXER_HUB = config["target_server"].gsub(/^http:\/\//, '').dup unless config["target_server"].nil?  # '192.168.0.11'
  PORT = config["port"].to_s.dup unless config["port"].nil?  # "3000"
  IP_LOOKUP_URL = config["ip_lookup_url"].dup unless config["ip_lookup_url"].nil?  # 'http://automation.whatismyip.com/n09230945.asp'
  DDNS_UPDATE_URL = config["ddns_update_url"].dup unless config["ddns_update_url"].nil?
  
  LOG_FILE = "C:\\it\\logs\\ipfixer.log"
  
  LONG_DURATION = 1000
  STANDARD_INTERVAL = 500
  
  begin
  	require 'rubygems'
  	require 'win32/daemon'
  	require 'socket'
  	require 'net/http' 
  	require 'fileutils'
  
  	include Win32
  
  	class DemoDaemon < Daemon
  		
  		def service_main
  			IpfixerClient.create_the_log_folder
  			host_name = Socket.gethostname
  			last_ip = ''
  			
  			while running?
  				
  				current_ip = IpfixerClient.get_ip_address(IP_LOOKUP_URL)
				if IpfixerClient.invalid_ip?(current_ip)
					sleep STANDARD_INTERVAL
					redo 
  				end
				
  				if current_ip != last_ip
  					IpfixerClient.tell_ddns_our_new_ip(DDNS_UPDATE_URL) unless DDNS_UPDATE_URL.nil?
  					
  					post_result = IpfixerClient.post_ip(host_name, current_ip)
  					if post_result == true
  						last_ip = current_ip
  						IpfixerClient.my_logger "Successfully posted IP to mother server..."
  					else
  						IpfixerClient.my_logger "ERROR: Problem uploading new IP Address."
  						IpfixerClient.my_logger "  current_ip: #{current_ip},  last_ip: #{last_ip}, post_result: #{post_result}"
  						sleep LONG_DURATION
  					end
  				else
  					IpfixerClient.my_logger "#{Time.now}:  No change in IP, #{current_ip}"
  				end
  				
  				#my_logger "Service is running #{Time.now}:  #{host_name}"
  				sleep STANDARD_INTERVAL
  			end
  		end
  
  		def service_stop
  			File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
  			exit!  # the guy I took the code from might have found the exit! command useful... I can't find a use for it.
  		end
  	end
  
  	
  rescue Exception => err
    IpfixerClient.my_logger "I ACTUALLY HAD A DAEMON ERROR!!! err=#{err}"
    File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
    raise
  end

end