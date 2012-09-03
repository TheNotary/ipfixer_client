require 'spec_helper'

describe "IpFixer Svc" do
  
  it "should work" do
    IpfixerClient.help.should eq "hello"
  end
end
