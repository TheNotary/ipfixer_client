require 'spec_helper'
require 'fileutils'

describe "installation/ uninstallation" do
  before :all do
    @virtual_service_name = "aaa-deleteme-test-service-ipfixer"
    @target_folder = "/tmp/it/ipfixer"
    #FileUtils.mkdir_p @target_folder
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
    @installer.stub!(:prompt_for_security_token).and_return(nil)
  end
  
  after :each do
    @installer.uninstall @virtual_service_name  # just make sure we don't already have an accidental installation in place
    
    @installer.unstub!(:prompt_for_target_server)
    @installer.unstub!(:prompt_for_port)
    @installer.unstub!(:prompt_for_ddns_url)
    @installer.unstub!(:prompt_for_security_token)
  end
  
  
  it "should install the service into windows and also uninstall it...", :current => true do
    @installer.install @virtual_service_name, @target_folder
    windows_service_installed?(@virtual_service_name).should be_true

    @installer.uninstall @virtual_service_name
    windows_service_installed?(@virtual_service_name).should be_false
  end
  
  it "should setup the log folder and files" do
    @installer.install @virtual_service_name, @target_folder
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
  
  describe "helper methods" do
    
    it "should return a valid path" do
      path = @installer.get_ipfixer_bin_path
      lambda {
        FileUtils.cd(path)
      }.should_not raise_error
    end
    
    
    describe "when service is uninstalled" do
      it "should know when the service is not installed" do
        @installer.service_installed?(@virtual_service_name).should be_false
      end
    end
    
    describe "when service is installed" do
      before :each do
        @installer.install @virtual_service_name, @target_folder
      end
      after :each do
        @installer.uninstall @virtual_service_name
      end
      
      it "should know when the service is installed" do
        @installer.service_installed?(@virtual_service_name).should be_true
      end
      
      it "should tell us when a service is STOPPED" do
        @installer.service_started?(@virtual_service_name).should be_false
      end
=begin
      # SOmetimes... this test will fail... it's not predictable...
      it ".start, .stop, .service_started?" do
        @installer.start @virtual_service_name
        @installer.service_started?(@virtual_service_name).should be_true
        
        @installer.stop @virtual_service_name
        # sleep 0.02  # you need to give it a moment to stop...
        @installer.service_started?(@virtual_service_name).should be_false
        
        sleep 0.5  # we need to sleep here so windows services can catch up
      end
=end
      
    end
    
    
    
  end
  
end
