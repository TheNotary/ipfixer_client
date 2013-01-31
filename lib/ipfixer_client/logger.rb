module IpfixerClient
  module Logger
    def my_logger(text)
      create_the_log_folder if !Dir.exists? LOG_FOLDER
      File.open(LOG_FILE, "a"){ |f| f.puts text }
    end
    
    def create_the_log_folder
      logs_folder = LOG_FOLDER
      FileUtils.mkdir_p(logs_folder) unless File.directory?(logs_folder) 
    end
  end
end


