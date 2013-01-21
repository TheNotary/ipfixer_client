require 'spec_helper'

describe "net stuff" do
  before :each do
    @ip_valid = "192.168.244.244"
    @ip_with_letters = "192.168.244.24a"
    @ip_too_big = "192.168.255.2555"
    @ip_too_short = "1.1.2."
    @ip_too_many_decimals = "192.168.2.2."
    @ip_too_few_decimals = "192.168.2444"
  end
  
  describe "reject invalid IP addresses" do
    it "should reject IP addresses with letters in them" do
      IpfixerClient.invalid_ip?(@ip_with_letters).should be_true
    end
    
    it "should reject IP addresses that are way too long" do
      IpfixerClient.invalid_ip?(@ip_too_big).should be_true
    end
    
    it "should reject IP addresses that are way too short" do
      IpfixerClient.invalid_ip?(@ip_too_short).should be_true
    end
    
    it "should reject IP addresses that have too many decimal points" do
      IpfixerClient.invalid_ip?(@ip_too_many_decimals).should be_true
    end
    
    it "should reject IP addresses that have too few decimal points" do
      IpfixerClient.invalid_ip?(@ip_too_few_decimals).should be_true
    end
  end
  
  it "should accept a valid IP address" do
    IpfixerClient.invalid_ip?(@ip_valid).should be_false
  end
  

  it "should read a config file and return a config object" do
    #IpfixerClient.get_configuration_settings.should eq true
  end
end