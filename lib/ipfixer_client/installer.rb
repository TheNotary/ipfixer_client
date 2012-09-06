module IpfixerClient
  require 'yaml'
  require 'rubygems'
  require 'win32/service'  # gem install win32-service
  require 'rbconfig'
  require 'fileutils'
  
  SERVICE_NAME = 'ipfixer_svc'
  SERVICE_DESC = 'A service that helps keep track of remote infrastructure.'

  class Installer
    include Win32
    
    def initialize
    end
    
    def install(service_name = SERVICE_NAME)
      uninstall(service_name)   #  uninstalls service if it's already installed
      
      ruby = File.join(Config::CONFIG["bindir"], Config::CONFIG["ruby_install_name"])
      gem_path = Gem.bin_path('ipfixer_client', 'ipfixer')
      
      target_folder = 'c:\it\ipfixer'
      service_to_install = 'ipfixer' # "ipfixer_svc.rb"
      
      # this string is the argument for the service
      # Example: 'c:\Ruby\bin\ruby.exe -C c:\temp ruby_example_service.rb'
      binary_path = ruby + " -C #{gem_path} client_svc"   # target_folder + '\\lib' + ' ' + "#{service_to_install}"
      
      target_server = prompt_for_target_server
      port = prompt_for_port
      ddns_update_url = prompt_for_ddns_url
      
      #@install_files.each do |file|
      #  install_file(target_folder, file)
      #end
      
      # update_yml_file(target_folder, target_server, port, ddns_update_url)
      
      # Create a new service
      Service.create({
        :service_name => service_name,
        :service_type => Service::WIN32_OWN_PROCESS,
        :description => SERVICE_DESC,
        :start_type => Service::AUTO_START,
        :error_control => Service::ERROR_NORMAL,
        :binary_path_name => binary_path,
        :load_order_group => 'Network',
        :dependencies => ['W32Time','Schedule'],
        :display_name => service_name
      })
      
      
      #`sc start ipfixer_svc`
    end
    
    
    def uninstall(service_name = SERVICE_NAME)
      Service.delete(service_name) if service_installed? service_name
    end
    
    
    
    
    #private
    
    def service_installed?(service_name)
      return false if `sc query #{service_name}` =~ /FAILED 1060/i
      true
    end
    
    
    def prompt_for_target_server
      puts "Please specify a target server name"
      puts "[192.168.0.11]"
      input = STDIN.gets.chomp
      
      if input == ""
        return nil
      else
        return input
      end
    end
    
    def prompt_for_port
      puts "Please specify a port"
      puts "[80]"
      input = STDIN.gets.chomp
      
      if input == ""
        return nil
      else
        return input.to_i
      end
    end
    
    def prompt_for_ddns_url
      puts "If you have a ddns direct URL to set your IP address, you may specify that now, else hit enter"
      puts "ex:  www.example.com/ipsetter.php?lkajsdflkjsdf"
      input = STDIN.gets.chomp
      
      if input == ""
        return nil
      else
        return input
      end
    end
    
    # writes a new yaml file out of the data entered, unless there was no data entered, 
    # in which case it will leave that yaml file untouched and with full comments....
    def update_yml_file(target_folder, target_server, port, ddns_update_url)
      return if target_server.nil? and port.nil? and ddns_update_url.nil?
      config = YAML.load_file("C:\\it\\ipfixer\\conf\\config.yml")
      
      config["target_server"] = target_server unless target_server.nil?
      config["port"] = port unless port.nil?
      config["ddns_update_url"] = ddns_update_url
      
      File.open(target_folder + '\conf\config.yml', "w") {|f| f.write(config.to_yaml) }
    end
      
  end
  
  
end