package asunit.runners {

	import asunit.framework.TestCase;

	import asunit.framework.IResult;
	import asunit.framework.Result;
	import asunit.framework.TestFailure;
	import asunit.support.ErrorInMethod;

	import flash.events.Event;

	public class TestRunnerErrorMethodTest extends TestCase {

		private var runner:TestRunner;
		private var testWithError:ErrorInMethod;

		public function TestRunnerErrorMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
            super.setUp();
			runner        = new TestRunner();
			testWithError = new ErrorInMethod();
		}

		protected override function tearDown():void {
            super.tearDown();
			runner        = null;
			testWithError = null;
		}

		public function testInstantiated():void {
			assertTrue("TestRunner instantiated", runner is TestRunner);
		}
		
		public function test_run_with_errors():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_has_one_error, 100));
			runner.run(ErrorInMethod);
		}
		
		private function check_Result_has_one_error(e:Event):void {
            var runnerResult:IResult = runner.result;
			assertFalse('runnerResult.wasSuccessful', runnerResult.wasSuccessful);
			
			assertEquals('one error in testResult',   1, runnerResult.errorCount);
			assertEquals('no failures in testResult', 0, runnerResult.failureCount);
			
			var failure0:TestFailure = runnerResult.errors[0] as TestFailure;
			assertTrue('thrownException is correct type', failure0.thrownException is ArgumentError);
			assertTrue('failedTest is an instance of the test class', failure0.failedTest is ErrorInMethod);
			assertSame('failedMethod name', 'throw_ArgumentError', failure0.failedMethod);
		}
	}
}

