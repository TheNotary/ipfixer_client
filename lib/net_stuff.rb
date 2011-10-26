# You need to wait 300 seconds before using this function
def get_ip_address
	http_response = Net::HTTP.get_response(URI.parse('http://automation.whatismyip.com/n09230945.asp'))
	
	if http_response.code == "200"
		return http_response.body
	else
		return http_response.body + http_response.code # not very ellegant huh...
	end
end


# Returns true if the string supplied wasn't actually a valid ip (very low cpu usage testing)
# >> If it's not a valid IP the thread will sleep for LONG_DURATION
def invalid_ip?(ip)
	
	if ip_malformed?(ip)
		my_logger "**ERROR:  Recieved an invalid ip."
		my_logger "  current_ip:  #{current_ip}"
		sleep LONG_DURATION
		return true
	else
		return false
	end
end


# Returns true or false depending if the string had 3 decimal points in it
def ip_malformed?(ip)
	l1 = ip.length # Get length of IP address
	l2 = ip.gsub(".", "").length; # remove decimal points and get new length
	
	if l2 - l1  == 3  # were there 3 decimal points?  That means it worked!
		did_find_valid_ip = true
	else
		did_find_valid_ip = false
	end
	
	return did_find_valid_ip
end


# POST /ipfixes
# { "ipfix": { "host":"Host Name", "ip":"192.168.0.1" } }
def post_ip(host_name, ip)
	username = 'test'
	password = 'testing'
	
	server = IP_FIXER_HUB
	port = PORT
	path = '/ipfixes.json'

	http = Net::HTTP.new(server, port)

	req = Net::HTTP::Post.new(path)
	req.content_type = 'application/json'	# specify json

	#req.basic_auth username, password                          # TODO:  Sort this out down the road
	req.body = '"ipfix":{ "host":"' + host_name + '", "ip":"' + ip + '" }'

	
	begin
		response = http.start {|http| http.request(req) }
	rescue
		my_logger "FAILURE TO POST TO ADDRESS:  Check if address and port are operational."
		return false
	end

	my_logger "DEBUGGER:  In Post_IP"
	my_logger "  host_name:  #{host_name}"
	my_logger "  ip:         #{ip}"
	my_logger "  Response:  #{response}"
	my_logger "  Req body:  #{req.body}"
	
	return true if response.code == "200"
	return response.code
end


def my_logger(text)
	File.open(LOG_FILE, "a"){ |f| f.puts text }
end


def create_the_log_folder
	logs_folder = "C:\\it\\logs"
	FileUtils.mkdir_p(logs_folder) unless File.directory?(logs_folder) 
end