module IpfixerClient
  # You need to wait 300 seconds before using this function
  def self.get_ip_address(ip_lookup_url)
    begin
      http_response = Net::HTTP.get_response(URI.parse(ip_lookup_url))
    rescue Exception => e 
      my_logger "**ERROR:  Something went wrong trying to get current IP Address"
      my_logger "ip_lookup_url: #{ip_lookup_url}"
      my_logger "Exception:  #{e.message}"
      return "failedToGetAddress"
    end


    if http_response.code == "200"
      return http_response.body
    else
      return http_response.body + http_response.code # not very ellegant huh...
    end
  end
  
  
  # Returns true if the string supplied wasn't actually a valid ip
  def self.invalid_ip?(ip)
    is_invalid = (ip =~ /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/).nil? ? true : false
  end
  
  
  # POST /ipfixes
  # { "ipfix": { "host":"Host Name", "ip":"192.168.0.1" } }
  def self.post_ip(host_name, ip, security_token = nil)
    security_token = security_token.nil? ? "secret pass" : security_token
    
    server = IP_FIXER_HUB.gsub(/^https?:\/\//, '')
    port = PORT
    path = '/ipfixes.json'
  
    http = Net::HTTP.new(server, port)
  
    req = Net::HTTP::Post.new(path)
    req.content_type = 'application/json'  # specify json
  
    #req.basic_auth username, password                          # TODO:  Sort this out down the road
    json_string = "{ 'ipfix': { 'host': '#{host_name}', 'ip': '#{ip}', 'security_token': '#{security_token}' } }"
    req.body = json_string.gsub("'", '"')        # json doesn't accept the single quote symbol
    
    
    begin
      response = http.start {|htp| htp.request(req) }
    rescue
      my_logger "FAILURE TO POST TO ADDRESS:  Check if address and port are operational."
      return false
    end
    
    if DEBUG_MODE
      my_logger "DEBUGGER:  In Post_IP"
      my_logger "  host_name:  #{host_name}"
      my_logger "  ip:         #{ip}"
      my_logger "  Response:  #{response}"
      my_logger "  Req body:  #{req.body}"
    end
    
    return true if response.code == "200" || response.code == "201"
    return response.code
  end
  
  def self.tell_ddns_our_new_ip(ddns_update_url)
    begin
      http_response = Net::HTTP.get_response(URI.parse(ddns_update_url))
      
      my_logger "Sent msg to ddns... response code was...#{http_response.code}.   #{Time.now}" if DEBUG_MODE
      
    rescue
      my_logger "Exception occured whil trying to tell_ddns_our_new_ip..."
      my_logger "Url was #{ddns_update_url}"
    end
  
    if http_response.code == "200"
      return true
    else
      my_logger "failed to properly tell ddns our new ip..."
      return false
    end
  end

  
  
  
################## This stuff should be split off into another file named "logger_stuff" or something...
  
  def self.my_logger(text)
    File.open(LOG_FILE, "a"){ |f| f.puts text }
  end
  
  def self.create_the_log_folder
    logs_folder = "C:\\it\\logs"
    FileUtils.mkdir_p(logs_folder) unless File.directory?(logs_folder) 
  end
  
end