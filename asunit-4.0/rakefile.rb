require 'sprout'
sprout 'as3'

ASUNIT_VERSION = '4.1.2'

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
  t.keep_generated_actionscript = true
  #t.use_fcsh = true
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
  t.library_path << 'lib/airglobal.swc'
  t.library_path << 'lib/airframework.swc'
  configure_test_task t
end

##########################################
# Launch the selected Test Harness

desc "Compile and run the test harness"
flashplayer :test_as3 => "bin/#{test_input}.swf"

desc "Compile and run the Flex 3 Harness"
flashplayer :text_flex3 => "bin/Flex3#{test_input}.swf"

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

compc "bin/AsUnit-#{ASUNIT_VERSION}.swc" do |t|
  configure_swc_task t
end

task :swc => "bin/AsUnit-#{ASUNIT_VERSION}.swc"

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

archive = "bin/AsUnit-#{ASUNIT_VERSION}.zip"

# Create the dist package so that we can 
# distribute src and examples packages.
file 'dist' => :swc do
  FileUtils.mkdir_p 'dist'
  FileUtils.mkdir_p 'dist/libs'
  
  FileUtils.cp_r 'bin/AsUnit-#{ASUNIT_VERSION}.swc', 'dist/libs/'
  FileUtils.cp_r 'src', 'dist/src'
  FileUtils.cp_r 'lib/as3reflection/p2', 'dist/src'
  FileUtils.cp_r 'examples', 'dist/examples'
end

# Remove the dist package
task :remove_dist do
  FileUtils.rm_rf 'dist'
end

zip archive do |t|
  t.input = 'dist'
end

CLEAN.add 'bin/*.zip'
CLEAN.add 'dist'

desc "Create zip archives"
task :zip => [:clean, :test_all, 'dist', archive, :remove_dist]

##########################################
# Set up task wrappers

task :default => :test

