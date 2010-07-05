require File.join(File.dirname(__FILE__), "test_helper")

class TestClassGeneratorTest < Test::Unit::TestCase
  include SproutTestCase

  context "a new test class generator" do

    setup do
      @fixtures = File.join('sprout', 'test', 'fixtures')
      @temp = File.join(fixtures, 'tmp')
      FileUtils.mkdir_p @temp

      @generator = AsUnit4::TestClassGenerator.new
      @generator.path = @temp
      @generator.logger = StringIO.new
    end

    teardown do
      remove_file @temp
    end

    should "work with a simple class" do
      @generator.input = 'utils.MathUtilTest'
      @generator.execute

      assert_file File.join(@temp, 'test', 'utils', 'MathUtilTest.as') do |content|
        assert_matches /class MathUtilTest \{/, content
        assert_matches /private var .*:MathUtil;/, content
        assert_matches /new MathUtil\(\);/, content
      end
      assert_file File.join(@temp, 'test', 'AllTests.as') do |content|
        assert_matches /import utils.MathUtilTest;/, content
        assert_matches /public var utils_MathUtilTest:utils\.MathUtilTest;/, content
      end
    end

    should "work without test suffix in the request" do
      @generator.input = 'utils.MathUtil'
      @generator.execute
      assert_file File.join(@temp, 'test', 'utils', 'MathUtilTest.as') do |content|
        assert_matches /class MathUtilTest \{/, content
        assert_matches /private var instance:MathUtil/, content
      end
      assert_file File.join(@temp, 'test', 'AllTests.as') do |content|
        assert_matches /import utils.MathUtilTest/, content
        assert_matches /public var utils_MathUtilTest:utils\.MathUtilTest;/, content
      end
    end
  end
end

