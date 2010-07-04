# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'sprout', 'lib', 'asunit4')
require 'rake'

Gem::Specification.new do |s|
  s.name                      = AsUnit::NAME
  s.version                   = AsUnit::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Luke Bayes", "Ali Mills", "Robert Penner"]
  s.email                     = ["asunit-users@lists.sourceforge.net"]
  s.homepage                  = "http://asunit.org"
  s.summary                   = "The fastest and most flexible ActionScript unit test framework"
  s.description               = "AsUnit is the only ActionScript unit test framework that support every development and runtime environment that is currently available. This includes Flex 2, 3, 4, AIR 1 and 2, Flash Lite, and of course the Flash Authoring tool"
  s.rubyforge_project         = "sprout"
  s.required_rubygems_version = ">= 1.3.6"
  s.require_path              = "sprout/lib"
  s.files                     = FileList["**/*"].exclude /docs|.DS_Store|generated|.svn|.git|airglobal.swc|airframework.swc/
end

