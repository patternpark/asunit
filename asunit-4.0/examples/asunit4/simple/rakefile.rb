require 'sprout'
sprout 'as3'

mxmlc 'bin/ExampleRunner.swf' do |t|
  t.input = 'src/ExampleRunner.as'
  t.source_path << 'test'
  t.library_path << 'lib/AsUnit4.swc'
end

desc 'Build and run the ExampleRunner.swf'
flashplayer :test => 'bin/ExampleRunner.swf' do |t|
  t.swf = 'bin/ExampleRunner.swf'
end

# set up the default rake task
task :default => :test
