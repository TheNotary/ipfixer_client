require 'spec_helper'
require 'ipfixer_client'

describe "installation/ uninstallation" do
  before :all do
    @virtual_service_name = "aaa-deleteme-test-service-ipfixer"
    @target_folder = "/tmp/it/ipfixer"
    delete_all_testing_files(@target_folder)
  end
  after :all do
    delete_all_testing_files(@target_folder)
  end
  
  
  before :each do
    @installer = IpfixerClient::Installer.new
    @installer.stub!(:prompt_for_target_server).and_return(nil)
    @installer.stub!(:prompt_for_port).and_return(nil)
    @installer.stub!(:prompt_for_ddns_url).and_return(nil)
  end
  
  after :each do
    @installer.uninstall @virtual_service_name  # just make sure we don't already have an accidental installation in place
    
    @installer.unstub!(:prompt_for_target_server)
    @installer.unstub!(:prompt_for_port)
    @installer.unstub!(:prompt_for_ddns_url)
  end
  
  
  it "should install the service into windows and also uninstall it..." do
    @installer.install @virtual_service_name
    windows_service_installed?(@virtual_service_name).should be_true
    #require 'pry'; binding.pry
    @installer.uninstall @virtual_service_name
    windows_service_installed?(@virtual_service_name).should be_false
  end
  
  it "should setup the log folder and files" do
    @installer.install @virtual_service_name
  end
  
  it "should be able to launch the daemon loop" do
    # IpfixerClient.client_svc
  end
  
  it "should be able to find the root of the gem when it's installed" do
    @installer.get_root_of_gem.should eq(get_project_dir_from_tests)  # this test is a bit silly...
  end
  
  it "should be able to create it's log files" do
    @installer.create_installation_files(@target_folder)
    
    File.exists?(@target_folder+"/conf/config.yml").should be_true
  end
  
end
