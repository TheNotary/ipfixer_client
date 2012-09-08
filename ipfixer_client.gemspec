# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ipfixer_client/version"

Gem::Specification.new do |s|
  s.name        = "ipfixer_client"
  s.version     = IpfixerClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TheNotary"]
  s.email       = ["no@email.plz"]
  s.homepage    = ""
  s.summary     = %q{ This gem is used to keep track of remote infrastructure }
  s.description = %q{ You install this service on a windows machine, and it will keep it's IP address posted to a rails application specified and also updates subdomain status at afraid.org.  }

  s.rubyforge_project = "ipfixer_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'thor'
  s.add_dependency 'win32-service'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'wdm'
  #s.add_development_dependency 'autotest'
  s.add_development_dependency 'win32console'
end
