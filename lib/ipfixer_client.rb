require 'ipfixer_client/config_stuff'
require 'ipfixer_client/net_stuff'
require 'ipfixer_client/version'
require 'ipfixer_client/installer.rb'
require 'ipfixer_client/ipfixer_svc'

require 'pry' # development tool


module IpfixerClient
  def self.help
    puts "This is ipfixer_client, a little client... see the docs"
    return "hello"
  end
  
  def self.client_svc
    my_logger "trying to install"
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