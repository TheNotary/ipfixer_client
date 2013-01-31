require 'yaml'
require 'fileutils'

module IpfixerClient
  
  def self.get_configuration_settings(config_file_path = "C:\\it\\ipfixer\\conf\\config.yml")
    return default_config_settings unless File.exists? config_file_path
    config_file = get_config_file config_file_path
    
    conf_contents = config_file.read
    
    begin
      config = YAML.load_file(config_file)
    rescue Exception => e
      File.open(LOG_FILE,'a+'){ |f| f.puts " ***YAML FILE PROBLEM DETECTED, The file was likely malformed... Check on it, or delete it and reinstall."; f.puts e.message }
      exit!
    end
    
    return config
  end
  
  def self.get_config_file(file_path)
    if File.exists?(file_path)
      File.open(file_path, "rb")
    else
      StringIO.new('')
    end
  end
  
  def self.default_config_settings
    return {'target_server' => "192.168.0.11", 
      "port" => 80, 
      "ip_lookup_url" => "http://api.externalip.net/ip/",
      "security_token" => "secret pass"}
  end
end
