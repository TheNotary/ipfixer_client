require 'ipfixer_client'

def windows_service_installed?(service_name)
  response = `sc query #{service_name}` if WINDOWS
  response = `ps -A |grep ` if LINUX   # FIXME:  Write working linux routine
  return false if response =~ /FAILED 1060/i if WINDOWS
  return true
end

def delete_all_testing_files(target_folder)
  FileUtils.rm_rf target_folder # if RUBY_PLATFORM =~ /mingw32/
  # FileUtils.rm_rf target_folder if RUBY_PLATFORM =~ /linux/
end

def get_project_dir_from_tests
  File.expand_path Dir.new("#{File.dirname(__FILE__)}/..").path
end
