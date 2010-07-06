require 'flashsdk'

$:.unshift File.dirname(__FILE__)

module AsUnit
  NAME    = 'asunit4'
  VERSION = '4.2.2.pre'
end

require 'asunit4/test_class_generator'
require 'asunit4/suite_class_generator'

Sprout::Specification.new do |s|
  s.name    = AsUnit::NAME
  s.version = AsUnit::VERSION
  s.add_file_target do |f|
    f.add_library :swc, File.join('..', '..', 'bin', "AsUnit-#{AsUnit::VERSION}.swc")
    # Removed the src compilation for now, b/c it requires additional compiler
    # configuration - like keep-as3-metadata...
    #f.add_library :src, [File.join(path, 'src'), File.join(path, 'vendor/as3reflection')]
  end
end

