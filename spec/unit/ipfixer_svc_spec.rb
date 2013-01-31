require 'spec_helper'

describe "IpFixer Svc" do
  
  before :each do
    @d = IpfixerClient::DemoDaemon.new
    @d.stub!(:sleep).and_return(nil)
  end
  
  it "should work", :current => true do  # for debuging the daemon apparently...
    @d.return_hello.should eq "hello"
    # d.service_main  #  only run this once... else it will run for ever and your tests can't pass
    # binding.pry
  end
  
  it "should handle invalid IPs well" do
    @d.handle_invalid_ip("i'm invalid").should eq true
  end
end
