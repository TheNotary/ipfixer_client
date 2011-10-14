# Run this script with out any arguments and it will install IP Fixer
#
# ruby ipfixer_reg.rb will install the service (the other file should be in the .\lib directory)
# ruby ipfixer_reg.rb anyArgument will uninstall the service

require 'rubygems'
require 'win32/service'  # gem install win32-service
require 'rbconfig'
require 'fileutils'


include Win32

SERVICE_NAME = 'ipfixer_svc'
SERVICE_DESC = 'A service that helps keep track of remote infrastructure.'

ruby = File.join(Config::CONFIG["bindir"], Config::CONFIG["ruby_install_name"]) 
src_path = File.dirname(__FILE__)

service_to_install = "ipfixer_svc.rb"

target_folder = 'c:\it\ipfixer'
src_full_path = src_path + '\\lib\\' + service_to_install
dst_full_path = "#{target_folder}\\#{service_to_install}"

# net_stuff.rb too!
class FileMover
	attr_accessor :src_full_path, :target_folder, :dst_full_path

	def initialize(src_full_path, target_folder, dst_full_path)
		@src_full_path = src_full_path
		@target_folder = target_folder
		@dst_full_path = dst_full_path
		
		integrity_checks_out?
	end
	
	def integrity_checks_out?
		return true if File.exists?(@src_full_path) and File.exists?(@src_full_path)
		puts "Failed to find service to install.  Should have been: #{@src_full_path}"
		STDIN.gets
		rais "Required files were missing from the deploy directory."
	end
	
	def deploy!
		# Copy service file to install directory
		# 
		begin
			FileUtils.mkdir_p(@target_folder) unless File.exists?(@target_folder)
			File.delete(@dst_full_path) if File.exists?(@dst_full_path)
			FileUtils.cp(@src_full_path, @dst_full_path)
		rescue
			puts "Failed to move service file to proper location."
			puts "#{@src_full_path}"
			raise "Problem copying file into binary location."
		end
	end
end

fm_ipfixer_svc = FileMover.new(src_full_path, target_folder, dst_full_path)
fm_ipfixer_svc.deploy!

net_stuff_full_path_src = "#{src_path}\\lib\\net_stuff.rb"
net_stuff_full_path_dst = "#{target_folder}\\net_stuff.rb"

fm_net_stuff = FileMover.new(net_stuff_full_path_src, target_folder, net_stuff_full_path_dst)
fm_net_stuff.deploy!


# Example: 'c:\Ruby\bin\ruby.exe -C c:\temp ruby_example_service.rb'
binary_path = ruby + ' -C ' + target_folder + ' ' + service_to_install

install = ARGV.empty? # if you send an argument, no matter what it will trigger delete routine

if install
  # Create a new service
  Service.create({
    :service_name => SERVICE_NAME,
    :service_type => Service::WIN32_OWN_PROCESS,
    :description => SERVICE_DESC,
    :start_type => Service::AUTO_START,
    :error_control => Service::ERROR_NORMAL,
    :binary_path_name => binary_path,
    :load_order_group => 'Network',
    :dependencies => ['W32Time','Schedule'],
    :display_name => SERVICE_NAME
  })
else

  # delete the service
  # NOTE: if the services applet is up during this operation, the service won't be removed from that ui
  # unitil you close and reopen it (it gets marked for deletion)
  Service.delete(SERVICE_NAME)
end