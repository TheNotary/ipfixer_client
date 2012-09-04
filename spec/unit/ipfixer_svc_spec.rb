require 'spec_helper'

describe "IpFixer Svc" do
  
  it "should work" do
    IpfixerClient.help.should eq "hello"
  end
  
  it "should read a config file and return a config object" do
    #IpfixerClient.get_configuration_settings.should eq true
  end
end
