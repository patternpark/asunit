require 'sprout'
sprout 'as2'

##########################################
# To build from this file, install Ruby (http://ruby-lang.org)
# and RubyGems (http://rubygems.org/), then run:
#   gem install sprout
#   gem install rake
#   rake
# This should walk you through the installation
# of required gems, compilers and vms

##########################################
# Compile the Test Harness

desc "Compile the test harness"
mtasc 'bin/AsUnitRunner.swf' do |t|
  t.main = true
  t.header = '1000:600:24'
  t.cp << 'src'
  t.cp << 'test'
  t.input = 'test/AsUnitRunner.as'
end

##########################################
# Generate documentation

# desc "Generate documentation"
# asdoc 'doc' do |t|
#   t.source_path << 'src'
#   t.doc_classes << 'AsUnit'
# end

##########################################
# Launch the Test Harness

desc "Compile and run the test harness"
flashplayer :run => 'bin/AsUnitRunner.swf'

##########################################
# Set up task wrappers

task :default => :run

desc "Alias to the default task"
task :test => :run






# def to_class_name(file)
#   parts = file.split('/')
#   parts.shift
#   name = parts.pop
#   name.split('.').shift
# end
# 
# def to_var_name(file)
#   parts = file.split('/')
#   parts.shift
#   name = parts.pop
#   name = name.split('.').shift
#   name[0, 1].downcase + name[1, name.size]
# end
# 
# Dir.glob('src/**/**/*').each do |file|
#   if(!File.directory?(file))
#     puts "private var #{to_var_name file}:#{to_class_name file};"
#   end
# end

