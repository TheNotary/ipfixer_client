require 'spec_helper'

describe "IpFixer Svc" do
  
  before :each do
    @d = IpfixerClient::DemoDaemon.new
    @d.stub!(:sleep).and_return(nil)
    @d.stub!(:my_logger).and_return(nil)
  end
  
  after :each do
    @d.unstub!(:sleep)
    @d.unstub!(:my_logger)
  end
  
  it "should work" do  # for debuging the daemon apparently...
    @d.return_hello.should eq "hello"
    # d.service_main  #  only run this once... else it will run for ever and your tests can't pass
    # binding.pry
  end
  
  it "should handle invalid IPs well" do
    @d.handle_invalid_ip("i'm invalid").should eq true
  end
  
  it "should initialize the service, yielding the hostname" do
    a = @d.init_service
    a.first.should be_an_instance_of(String)
    a.last.should be_an_instance_of(String)
    a.length.should eq 2
  end
  
  it "should work" do
    #binding.pry
  end
end
