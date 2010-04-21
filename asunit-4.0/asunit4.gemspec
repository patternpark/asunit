# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/config/version'
require 'rake'

# This file is actually executed from dist/
# Check the rakefile.rb for more information.

Gem::Specification.new do |s|
  s.name        = "sprout-asunit4"
  s.version     = AsUnit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luke Bayes, Ali Mills and Robert Penner"]
  s.email       = ["asunit-users@lists.sourceforge.net"]
  s.homepage    = "http://asunit.org"
  s.summary     = "The fastest and most flexible ActionScript unit test framework"
  s.description = "AsUnit is the only ActionScript unit test framework that support every development and runtime environment that is currently available. This includes Flex 2, 3, 4, AIR 1 and 2, Flash Lite, and of course the Flash Authoring tool"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "sprout"

  included_files = FileList["**/*"].exclude /.DS_Store|generated|.svn|.git|airglobal.swc|airframework.swc/

  s.files        = included_files
  s.require_path = 'config'
end
