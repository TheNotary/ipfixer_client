# http://stackoverflow.com/questions/163497/running-a-ruby-program-as-a-windows-service
# Use the register
#
# $ gem install win32-service

# Point this at your hub
IP_FIXER_HUB = '192.168.0.11'
PORT = "3000"


LOG_FILE = "C:\\it\\logs\\ipfixer.log"
#LOG_FILE = "C:\\test.log"

LONG_DURATION = 1 # 1000
STANDARD_INTERVAL = 10

begin
	require 'rubygems'
	require 'win32/daemon'
	require "socket"
	require 'net/http' 
	require 'fileutils'
	load "net_stuff.rb"

	include Win32

	class DemoDaemon < Daemon
		
		
		def service_main
			create_the_log_folder
			host_name = Socket.gethostname
			last_ip = ''
			
			while running?
				
				current_ip = get_ip_address
				redo if invalid_ip?(current_ip)
				
				if current_ip != last_ip
					post_success = post_ip(host_name, current_ip)
					if post_success
						last_ip = current_ip
						my_logger "Successfully posted IP to mother server..."
					else
						my_logger "ERROR: Problem uploading new IP Address."
						my_logger "  current_ip: #{current_ip},  last_ip: #{last_ip}, post_result: #{post_result}"
					end
				else
					my_logger "#{Time.now}:  No change in IP, #{current_ip}"
				end
				
				#my_logger "Service is running #{Time.now}:  #{host_name}"
				sleep STANDARD_INTERVAL
			end
		end

		def service_stop
			File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
			exit!
		end
	end

	DemoDaemon.mainloop
rescue Exception => err
    File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
    raise
end
