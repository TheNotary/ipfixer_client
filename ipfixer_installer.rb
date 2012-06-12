# Run this script with out any arguments and it will install IP Fixer
#
# ruby ipfixer_reg.rb will install the service (the other file should be in the .\lib directory)
# ruby ipfixer_reg.rb anyArgument will uninstall the service

require 'yaml'
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
@install_files = [ "\\conf\\config.yml", "\\lib\\ipfixer_svc.rb", "\\lib\\net_stuff.rb", "\\lib\\config_stuff.rb", "ipfixer_installer.rb" ]
target_folder = 'c:\it\ipfixer'

def prompt_for_installation_folder
	puts "Please specify an installation directory, or hit enter for default 'c:\\it\\ipfixer'"
	input = STDIN.gets.chomp

	if input == ""
		target_folder = 'c:\it\ipfixer'
	else
		target_folder = input
	end
end

def write_install_dir_to_registry
	# I decided not to impliment this because windows in obnoxious now-a-days about administration privs
end
def remove_install_dir_from_registry
end

def prompt_for_hostname_from_user
	puts "Please specify a host name"
	input = STDIN.gets.chomp

	if input == ""
		hostname = "default"
	else
		hostname = input
		# then it should be written to the yaml file...
	end
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
      make_directory_if_needed(@dst_full_path)
      
			# FileUtils.mkdir_p(@target_folder) unless File.exists?(@target_folder)
			File.delete(@dst_full_path) if File.exists?(@dst_full_path)
			FileUtils.cp(@src_full_path, @dst_full_path)
		rescue
			puts "Failed to move service file to proper location."
			puts "#{@src_full_path}"
			raise "Problem copying file into binary location."
		end
	end
	
	def make_directory_if_needed(file_path)
    path = get_folder_path(file_path)  # test if I broke this... yet...
    
    FileUtils.mkdir_p(path) unless File.exists?(path)
  end
	
end


def get_folder_path(file_path)
	file_name = File.basename(file_path)
    path = file_path[0..-(1+file_name.length)]
	return path
end

# this method copies a file from the installer's directory over to the destination install path
def install_file(target_folder, service_to_install)
	src_path = File.dirname(__FILE__)
	
	src_full_path = src_path + '\\' + service_to_install
	dst_full_path = "#{target_folder}\\#{service_to_install}"
  
	fm_ipfixer_svc = FileMover.new(src_full_path, target_folder, dst_full_path)
	fm_ipfixer_svc.deploy!
end

# this method deletes all the installation files
def delete_installed_files!(target_folder)
	return unless Dir.exists?(target_folder)
	
	install_files = @install_files
	install_files.each do |file|
		break if file == __FILE__   # make sure it doesn't try to delete itself...
	
		full_path = target_folder + file
		File.delete(full_path) if File.exists?(full_path)
		
		folder = get_folder_path(full_path)
		Dir.rmdir(folder) if is_dir_empty?(folder)
	end
	
	Dir.rmdir(target_folder) if is_dir_empty?(target_folder)
end

def is_dir_empty?(dirname)
	Dir.entries(dirname).join == "..." if Dir.exists?(dirname)
end

def create_uninstall_file(target_folder)
	uninstall_script = <<-HERE_DOC
@ECHO OFF
echo Removing ipfixer from the services list

sc stop ipfixer_svc
start /wait ruby ipfixer_installer.rb remove

DEL ipfixer_installer.rb

rem   remove even the uninstall script
DEL "%~f0"

pause
	HERE_DOC
	
	File.open(target_folder + '\uninstall.bat', 'w') {|f| f.write(uninstall_script) }
end


# this string is the argument for the service
# Example: 'c:\Ruby\bin\ruby.exe -C c:\temp ruby_example_service.rb'
binary_path = ruby + ' -C ' + target_folder + '\\lib' + ' ' + "#{service_to_install}"

install = ARGV.empty? # if you send an argument, no matter what it will trigger delete routine

if install
	target_server = prompt_for_target_server
	port = prompt_for_port
	ddns_update_url = prompt_for_ddns_url
	puts "Commencing installation..."
	
	@install_files.each do |file|
		install_file(target_folder, file)
	end
	create_uninstall_file(target_folder)
	
	update_yml_file(target_folder, target_server, port, ddns_update_url)
	
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
	delete_installed_files!(target_folder) # delete files before and after just incase the service was deleted manually (it will crash out there if so...)
	# delete the service
	# NOTE: if the services applet is up during this operation, the service won't be removed from that ui
	# unitil you close and reopen it (it gets marked for deletion)
	Service.delete(SERVICE_NAME)
	
	delete_installed_files!(target_folder)
end