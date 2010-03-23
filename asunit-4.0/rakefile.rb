require 'sprout'
sprout 'as3'

ASUNIT_VERSION = '4.1'

test_input = "AsUnit4Runner"

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
# Compile the Test Harness

desc "Compile the test harness"
mxmlc "bin/#{test_input}.swf" do |t|
  t.default_size = '1000 600'
  t.source_path << 'src'
  t.library_path << 'lib/Reflection.swc'
  t.input = "test/#{test_input}.as"
  t.debug = true
  t.gem_name = 'sprout-flex4sdk-tool'
  t.static_link_runtime_shared_libraries = true

  apply_as3_meta_data_args(t)
end

##########################################
# Compile the SWC

compc 'bin/AsUnit4.swc' do |t|
  t.include_sources << 'src'
  t.source_path << 'src'
  t.library_path << 'lib/Reflection.swc'
  apply_as3_meta_data_args(t)
end

# TODO: The :swc task should also call
# this task to build the AIR-support
# version of the SWC
# Had trouble creating a SWC with 
# AIR dependencies without including
# a bunch of AIR-only classes.
compc 'bin/AsUnit4-AIR.swc' do |t|
  t.gem_name = 'sprout-flex4sdk-tool'
  t.include_sources << 'src'
  t.include_sources << 'air'
  t.source_path << 'src'
  t.source_path << 'air'
  
  # Include air swcs to avoid failures
  # on AirRunner:
  t.include_libraries << 'lib/airglobal.swc'
  t.include_libraries << 'lib/airframework.swc'

  t.static_link_runtime_shared_libraries = true

  apply_as3_meta_data_args(t)
end

desc "Compile the AsUnit swc"
#task :swc => ['bin/AsUnit4.swc', 'bin/AsUnit4-AIR.swc']
task :swc => 'bin/AsUnit4.swc'

##########################################
# Generate documentation

desc "Generate documentation"
asdoc 'doc' do |t|
  t.appended_args = '-examples-path=examples'
  t.source_path << 'src'
  t.doc_classes << 'AsUnit'
  t.library_path << 'lib/Reflection.swc'

  # Include air swcs to avoid failures
  # on AirRunner:
  t.library_path << 'lib/airglobal.swc'
  t.library_path << 'lib/airframework.swc'

  # Not on asdoc?
  #t.static_link_runtime_shared_libraries = true
end

##########################################
# Launch the Test Harness

desc "Compile and run the test harness"
flashplayer :run => "bin/#{test_input}.swf"

##########################################
# Package framework ZIPs

archive = "bin/AsUnit#{ASUNIT_VERSION}.zip"

# Create the dist package so that we can 
# distribute src and examples packages.
file 'dist' => :swc do
  FileUtils.mkdir_p 'dist'
  FileUtils.mkdir_p 'dist/libs'
  
  FileUtils.cp_r 'bin/AsUnit4.swc', 'dist/libs/'
  FileUtils.cp_r 'src', 'dist/src'
  FileUtils.cp_r 'lib/as3reflection/p2', 'dist/src'
  FileUtils.cp_r 'examples', 'dist/examples'
  FileUtils.cp_r 'air/asunit/textui/AirRunner.as', 'dist/src/asunit/textui/AirRunner.as'
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
task :zip => [:clean, 'dist', archive, :remove_dist]

##########################################
# Set up task wrappers

task :default => :test

desc "Alias to the default task"
task :test => :run
