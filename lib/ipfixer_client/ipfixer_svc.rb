require 'rubygems'
require 'win32/daemon'
require 'socket'
require 'net/http' 
require 'fileutils'

module IpfixerClient
  include Win32
  
  begin
    class DemoDaemon < Daemon  # http://stackoverflow.com/questions/163497/running-a-ruby-program-as-a-windows-service
      
      def service_main
        host_name, last_ip = init_service

        while running?
          current_ip = IpfixerClient.get_ip_address(IP_LOOKUP_URL)
          handle_invalid_ip(current_ip) and redo if IpfixerClient.invalid_ip?(current_ip)
          ip_changed = current_ip != last_ip
          
          if ip_changed
            last_ip = handle_ip_change(host_name, current_ip, last_ip)
          else
            IpfixerClient.my_logger "#{Time.now}:  No change in IP, #{current_ip}" if DEBUG_MODE
          end
          
          #my_logger "Service is running #{Time.now}:  #{host_name}"
          sleep STANDARD_INTERVAL
        end
      end

      def service_stop
        File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
        exit!  # the guy I took the code from might have found the exit! command useful... I can't find a use for it.  Wait.. I think it can't stop if you leave it out now...
      end
      
      # Does initialization preparations for the service.  
      # returns an array of [host_name, '']
      def init_service
        handle_missing_specifications and exit! if missing_specifications_detected
        
        host_name = Socket.gethostname
        last_ip = ''
        [host_name, last_ip]
      end
      
      # To run, the daemon needs to have an IP Lookup address, and
      # an IP_FIXER_HUB specified in the config.  If those aren't 
      # found, we need to exit
      def missing_specifications_detected
        (IP_FIXER_HUB.nil? || IP_LOOKUP_URL.nil?) ? true : false
      end
      
      def handle_missing_specifications
        File.open(LOG_FILE,'a+') do |f|
          f.puts " ***YAML FILE PROBLEM DETECTED, IP_FIXER_HUB or IP_LOOKUP_URL was nil.  You can't run this service with out a server to contact, or a way of looking up your IP: " 
          f.puts "#{IP_FIXER_HUB} ... #{IP_LOOKUP_URL}" 
          f.puts "Check your conf file at c:\\it\\ipfixer\\conf\\conf.yml"
        end
        true
      end

      def handle_invalid_ip(current_ip)
        IpfixerClient.my_logger "**ERROR:  Recieved an invalid ip."
        IpfixerClient.my_logger "  current_ip:  #{current_ip}"
        sleep STANDARD_INTERVAL
        true
      end
      
      def handle_ip_change(host_name, current_ip, last_ip)
        IpfixerClient.tell_ddns_our_new_ip(DDNS_UPDATE_URL) unless DDNS_UPDATE_URL.nil?

        post_result = IpfixerClient.post_ip(host_name, current_ip, SECURITY_TOKEN)
        if post_result == true
          last_ip = current_ip
          IpfixerClient.my_logger "Successfully posted IP to mother server... #{current_ip}"
        else
          handle_failed_ip_post(current_ip, last_ip, post_result)
        end

        last_ip
      end

      def handle_failed_ip_post(current_ip, last_ip, post_result)
        IpfixerClient.my_logger "ERROR: Problem uploading new IP Address."
        IpfixerClient.my_logger "  current_ip: #{current_ip},  last_ip: #{last_ip}, post_result: #{post_result}"
        sleep LONG_DURATION
      end

      def return_hello
        IpfixerClient.my_logger "hello"
        sleep 1000
        "hello"
      end

      def sleep(x) # for stub testing...
        Kernel.sleep x
      end

    end


  rescue Exception => err
    File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
    raise
  end

end
