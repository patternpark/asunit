require 'sprout'
sprout 'as3'

##########################################
# Compile the Test Harness

mxmlc 'bin/AsUnit3Runner.swf' do |t|
  t.default_size = '1000 600'
  t.source_path << '../../framework/as3'
  t.input = 'AsUnitTestRunner.as'
end

##########################################
# Launch the Test Harness

desc "Compile and run the test harness"
flashplayer :run => 'bin/AsUnit3Runner.swf'

##########################################
# Set up task wrappers

task :default => :run

desc "Alias to the default task"
task :test => :run
