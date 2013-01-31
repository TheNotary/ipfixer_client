require 'ipfixer_client/config_stuff'
require 'ipfixer_client/net_stuff'
require 'ipfixer_client/version'
require 'ipfixer_client/installer.rb'
require 'ipfixer_client/ipfixer_svc'

LOG_FILE = "C:\\it\\logs\\ipfixer.log"
LONG_DURATION = 1000
STANDARD_INTERVAL = 500

config = IpfixerClient.get_configuration_settings

# Point this at your hub
IP_FIXER_HUB = config["target_server"].nil? ? nil : config["target_server"].dup                          # '192.168.1.1'
PORT = config["port"].nil? ? "80" : config["port"].to_s.dup                                              # "3000"
IP_LOOKUP_URL = config["ip_lookup_url"].nil? ? nil : config["ip_lookup_url"].dup                         # 'http://automation.whatismyip.com/n09230945.asp'
DDNS_UPDATE_URL = config["ddns_update_url"].nil? ? nil : config["ddns_update_url"].dup
SECURITY_TOKEN = config["security_token"].nil? ? nil : config["security_token"].dup
DEBUG_MODE = config["debug"].nil? || config["debug"] == false ? false : true
#DEBUG_MODE = true





module IpfixerClient
  def self.help
    puts "This is ipfixer_client, a little client... see the docs"
  end
  
  def self.client_svc
    DemoDaemon.mainloop
  end
  
  def self.install
    i = Installer.new 
    i.install 
  end
  
  def self.uninstall
    i = Installer.new
    i.uninstall
  end
  
end