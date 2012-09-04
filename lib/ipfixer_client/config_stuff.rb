require 'yaml'

def read_config_file
	config = YAML.load_file("C:\\it\\ipfixer\\conf\\config.yml")
	return config
end