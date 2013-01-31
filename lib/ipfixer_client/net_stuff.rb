module IpfixerClient
  # You need to wait 300 seconds before using this function
  def self.get_ip_address(ip_lookup_url)
    begin
      http_response = Net::HTTP.get_response(URI.parse(ip_lookup_url))
    rescue Exception => e 
      err_getting_ip(ip_lookup_url, e.message)
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
    path = '/ipfixes.json'
  
    http = Net::HTTP.new(IP_FIXER_HUB, PORT)
  
    req = Net::HTTP::Post.new(path)
    req.content_type = 'application/json'  # specify json
  
    json_string = "{ 'ipfix': { 'host': '#{host_name}', 'ip': '#{ip}', 'security_token': '#{security_token}' } }"
    req.body = json_string.gsub("'", '"')        # json doesn't accept the single quote symbol
    
    
    begin
      response = http.start {|htp| htp.request(req) }
    rescue
      my_logger "FAILURE TO POST TO ADDRESS:  Check if address and port are operational."
      return false
    end
    
    dbg_post_ip(host_name, ip, response, req.body) if DEBUG_MODE
    
    return true if response.code == "200" || response.code == "201"
    return response.code
  end
  
  def self.tell_ddns_our_new_ip(ddns_update_url)
    begin
      http_response = Net::HTTP.get_response(URI.parse(ddns_update_url))
      dbg_tell_ddns_our_new_ip(http_response.code) if DEBUG_MODE
    rescue
      err_tell_ddns_our_new_ip(ddns_update_url)
    end
  
    if http_response.code == "200"
      true
    else
      err_ddns_gave_wrong_response_code
    end
  end

end