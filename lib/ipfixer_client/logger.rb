module IpfixerClient
  
  def self.my_logger(text)
    create_the_log_folder if !Dir.exists? LOG_FOLDER
    File.open(LOG_FILE, "a"){ |f| f.puts text }
  end
  
  def self.create_the_log_folder
    logs_folder = LOG_FOLDER
    FileUtils.mkdir_p(logs_folder) unless File.directory?(logs_folder) 
  end
    
  module Logger
=begin
    def my_logger(text)
      create_the_log_folder if !Dir.exists? LOG_FOLDER
      File.open(LOG_FILE, "a"){ |f| f.puts text }
    end

    def create_the_log_folder
      logs_folder = LOG_FOLDER
      FileUtils.mkdir_p(logs_folder) unless File.directory?(logs_folder) 
    end
=end

    # I moved this here so I'd have all debug output in the same file...
    # But wouldn't it be better to have a module named Dbg.post_ip instead?
    def dbg_post_ip(host_name, ip, response, body)
      my_logger "DEBUGGER:  In Post_IP"
      my_logger "  host_name:  #{host_name}"
      my_logger "  ip:         #{ip}"
      my_logger "  Response:  #{response}"
      my_logger "  Req body:  #{body}"
    end
    
    def dbg_tell_ddns_our_new_ip(code)
      my_logger "Sent msg to ddns... response code was...#{code}.   #{Time.now}"
    end
    
    def err_getting_ip(ip_lookup_url, message)
      my_logger "**ERROR:  Something went wrong trying to get current IP Address"
      my_logger "ip_lookup_url: #{ip_lookup_url}"
      my_logger "Exception:  #{message}"
    end
    
    def err_tell_ddns_our_new_ip(ddns_update_url)
      my_logger "Exception occured whil trying to tell_ddns_our_new_ip..."
      my_logger "Url was #{ddns_update_url}"
    end
    
    def err_ddns_gave_wrong_response_code
      my_logger "failed to properly tell ddns our new ip..."
      false
    end
  end
end


