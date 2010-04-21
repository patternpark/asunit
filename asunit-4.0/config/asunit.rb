require File.dirname(__FILE__) + '/version'

module AsUnit
  include Sprout::Library
  
  add_file_target :universal do |t|
    t.add_library :swc, "bin/AsUnit-#{VERSION}.swc"
  end
end

