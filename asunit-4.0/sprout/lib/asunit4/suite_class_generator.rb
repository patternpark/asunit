module AsUnit4
  class SuiteClassGenerator < FlashSDK::ClassGenerator
    include FlashSDK::FlashHelper
    
    def initialize
      super
      self.input = 'AllTests.as'
    end

    def manifest
      directory test do
        template input, 'AsUnit4SuiteClass.as'
      end
    end
  end
end

