require 'sprout'
sprout 'as3'

require File.dirname(__FILE__) + '/config/version'

test_input = "AsUnitRunner"

##########################################
# To build from this file, install Ruby (http://ruby-lang.org)
# and RubyGems (http://rubygems.org/), then run:
#   gem install rake
#   gem install sprout
#   rake
# This should walk you through the installation
# of required gems, compilers and vms

##########################################
# Define the known Meta Data tags:

def apply_as3_meta_data_args(t)
  [
    "After",
    "AfterClass",
    "Before",
    "BeforeClass",
    "Ignore",
    "Inject",
    "RunWith",
    "Suite",
    "Test"
  ].each do |arg|
    t.keep_as3_metadata << arg
  end
end

##########################################
# Configure a Test Build:

def configure_test_task(t)
  t.default_size = '1000 600'
  t.source_path << 'src'
  t.library_path << 'lib/Reflection.swc'
  t.debug = true
  t.static_link_runtime_shared_libraries = true
  apply_as3_meta_data_args(t)
end

##########################################
# Compile the Test Harness(es)

desc "Compile the ActionScript test harness"
mxmlc "bin/#{test_input}.swf" do |t|
  t.input = "test/AsUnitRunner.as"
  t.gem_name = 'sprout-flex4sdk-tool'
  configure_test_task t
end

desc "Compile the Flex 3 test harness"
mxmlc "bin/Flex3#{test_input}.swf" do |t|
  t.input = "test/Flex3Runner.mxml"
  t.gem_name = 'sprout-flex3sdk-tool'
  configure_test_task t
end

desc "Compile the Flex 4 test harness"
mxmlc "bin/Flex4#{test_input}.swf" do |t|
  t.input = "test/Flex4Runner.mxml"
  t.gem_name = 'sprout-flex4sdk-tool'
  configure_test_task t
end

desc "Compile the Flex 4 test harness"
mxmlc "bin/AIR2#{test_input}.swf" do |t|
  t.input = "air/AIR2Runner.mxml"
  t.gem_name = 'sprout-flex4sdk-tool'
  t.source_path << 'air'
  t.source_path << 'test'
  t.library_path << 'lib/airglobal.swc'
  t.library_path << 'lib/airframework.swc'
  configure_test_task t
end

##########################################
# Launch the selected Test Harness

desc "Compile and run the test harness"
flashplayer :test_as3 => "bin/#{test_input}.swf"

desc "Compile and run the Flex 3 Harness"
flashplayer :test_flex3 => "bin/Flex3#{test_input}.swf"

desc "Compile and run the Flex 4 Harness"
flashplayer :test_flex4 => "bin/Flex4#{test_input}.swf"

desc "Compile and run the AIR 2 Harness"
adl :test_air2 => "bin/AIR2#{test_input}.swf" do |t|
  t.gem_name = "sprout-flex4sdk-tool"
  t.root_directory = Dir.pwd
  t.application_descriptor = "air/AIR2RunnerDescriptor.xml"
end

desc "Compile and run the ActionScript 3 test harness"
task :test => :test_as3

desc "Compile and run test harnesses for all supported environments"
task :test_all => [:test_as3, :test_flex3, :test_flex4, :test_air2]

##########################################
# Compile the SWC

def configure_swc_task(t)
  t.gem_name = 'sprout-flex4sdk-tool'
  t.include_sources << 'src'
  t.source_path << 'src'
  t.library_path << 'lib/Reflection.swc'
  t.static_link_runtime_shared_libraries = true
  apply_as3_meta_data_args(t)
end

compc "bin/AsUnit-#{AsUnit::VERSION}.swc" do |t|
  configure_swc_task t
end

task :swc => "bin/AsUnit-#{AsUnit::VERSION}.swc"

##########################################
# Generate documentation

desc "Generate documentation"
asdoc 'doc' do |t|
  t.appended_args = '-examples-path=examples'
  t.source_path << 'src'
  t.doc_classes << 'AsUnit'
  t.library_path << 'lib/Reflection.swc'

  # Not on asdoc?
  #t.static_link_runtime_shared_libraries = true
end

##########################################
# Package framework ZIPs


desc "Create the gem package"
task :package_gem => :swc do
  sh "gem build asunit4.gemspec"
end

CLEAN.add '*.gem'

archive = "AsUnit-#{AsUnit::VERSION}.zip"

zip archive do |t|
  t.input = './*'
end

CLEAN.add '*.zip'

desc "Create zip archives"
task :zip => [:clean, :test_all, archive]

##########################################
# Set up task wrappers

task :default => :test

