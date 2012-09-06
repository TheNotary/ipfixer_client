require 'spec_helper'
require 'ipfixer_client'

describe "installation/ uninstallation" do
  
  before :each do
    @virtual_service_name = "aaa-deleteme-test-service-ipfixer"
    
    @installer = IpfixerClient::Installer.new
    @installer.stub!(:prompt_for_target_server).and_return(nil)
    @installer.stub!(:prompt_for_port).and_return(nil)
    @installer.stub!(:prompt_for_ddns_url).and_return(nil)
  end
  
  after :each do
    @installer.uninstall @virtual_service_name
  end
  
  
  it "should install the service into windows and also uninstall it..." do
    @installer.install @virtual_service_name
    windows_service_installed?(@virtual_service_name).should be_true
    require 'pry'; binding.pry
    @installer.uninstall @virtual_service_name
    windows_service_installed?(@virtual_service_name).should be_false
  end
  
  it "should setup the log folder and files" do
    @installer.install @virtual_service_name
  end
  
  it "should be able to launch the daemon loop" do
    # IpfixerClient.client_svc
  end
  
end
