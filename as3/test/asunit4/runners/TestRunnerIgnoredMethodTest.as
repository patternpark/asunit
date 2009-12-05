package asunit4.runners 
{
	import asunit.framework.TestCase;

	import asunit4.framework.Result;
	import asunit4.support.IgnoredMethodTest;

	import flash.events.Event;

	public class TestRunnerIgnoredMethodTest extends TestCase {
		private var runner:TestRunner;
		private var ignoredTest:IgnoredMethodTest;
		private var runnerResult:Result;
		
		public function TestRunnerIgnoredMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			ignoredTest = new IgnoredMethodTest();
			runnerResult = new Result();
		}

		protected override function tearDown():void {
			runner = null;
			ignoredTest = null;
			runnerResult = null;
		}

		//////
		public function test_run_with_ignored_method():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_has_one_ignored_method, 100));
			runner.run(ignoredTest, runnerResult);
		}
		
		private function check_Result_has_one_ignored_method(e:Event):void {
			assertTrue('runnerResult.wasSuccessful', runnerResult.wasSuccessful);
			assertEquals('one ignored test in result', 1, runnerResult.ignoredTests.length);
		}
		
	}
}
