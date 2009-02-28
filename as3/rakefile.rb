require 'sprout'
sprout 'as3'

##########################################
# Compile the Test Harness

mxmlc 'bin/AsUnitRunner.swf' do |t|
  t.default_size = '1000 600'
  t.source_path << 'src'
  t.input = 'test/AsUnitRunner.as'
end

##########################################
# Launch the Test Harness

desc "Compile and run the test harness"
flashplayer :run => 'bin/AsUnitRunner.swf'

##########################################
# Set up task wrappers

task :default => :run

desc "Alias to the default task"
task :test => :run
