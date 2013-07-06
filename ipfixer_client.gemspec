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
  s.add_dependency 'win32-service' if RUBY_PLATFORM =~ /mingw32/
  s.add_development_dependency 'win32console' if RUBY_PLATFORM =~ /mingw32/
  s.add_development_dependency 'wdm' if RUBY_PLATFORM =~ /mingw32/
  
  s.add_dependency 'daemons' if RUBY_PLATFORM =~ /linux/

  
  s.add_development_dependency('rake', '0.9.2')
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  
  #s.add_development_dependency('rake-compiler', '0.7.9')
  #s.add_development_dependency('archive-tar-minitar', '0.5.2')  # this might be another secret dependency
  #s.add_development_dependency('debugger-ruby_core_source', '1.1.3') # dep dep
  #s.add_development_dependency('ruby_core_source', '0.1.5') # SECRET DEPENDENCY OF LINECACHE!!! MAYBE...
  #s.add_development_dependency('ruby-debug19') # installing manually, this gem is able to install linecache19 successfully 
  #s.add_development_dependency('debugger-linecache', '1.1.2') # depdep
  
  #s.add_development_dependency('linecache19', '0.5.12') # dep dep, very problematic one...
  s.add_development_dependency 'debugger' if RUBY_PLATFORM =~ /linux/
  #s.add_development_dependency 'guard'
  #s.add_development_dependency 'guard-rspec'
  
  #s.add_development_dependency 'autotest'
end
