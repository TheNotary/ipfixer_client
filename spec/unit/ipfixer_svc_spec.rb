require 'spec_helper'

describe "IpFixer Svc" do
  
  it "should work", :current => true do
    d = IpfixerClient::DemoDaemon.new
    # d.service_main  #  only run this once... else it will run for ever and your tests can't pass
    #binding.pry
  end
  
  it "should read a config file and return a config object" do
    #IpfixerClient.get_configuration_settings.should eq true
  end
end
