package asunit4.runners {
	import asunit.framework.TestCase;
	import asunit4.framework.Result;
	import flash.events.Event;
	import asunit4.support.ErrorInMethodTest;
	import asunit4.framework.IResult;
	import asunit4.framework.TestFailure;

	public class TestRunnerErrorMethodTest extends TestCase {
		private var runner:TestRunner;
		private var testWithError:ErrorInMethodTest;
		private var runnerResult:Result;
		
		public function TestRunnerErrorMethodTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			runner = new TestRunner();
			testWithError = new ErrorInMethodTest();
			runnerResult = new Result();
		}

		protected override function tearDown():void {
			runner = null;
			testWithError = null;
			runnerResult = null;
		}

		public function testInstantiated():void {
			assertTrue("TestRunner instantiated", runner is TestRunner);
		}
		
		//////
		public function test_run_with_errors():void {
			runner.addEventListener(Event.COMPLETE, addAsync(check_Result_has_one_error, 100));
			runner.run(testWithError, runnerResult);
		}
		
		private function check_Result_has_one_error(e:Event):void {
			assertFalse('runnerResult.wasSuccessful', runnerResult.wasSuccessful);
			
			assertEquals('one error in testResult',   1, runnerResult.errorCount);
			assertEquals('no failures in testResult', 0, runnerResult.failureCount);
			
			var failure0:TestFailure = runnerResult.errors[0] as TestFailure;
			assertTrue('thrownException is correct type', failure0.thrownException is ArgumentError);
			assertSame('failedTest reference', testWithError, failure0.failedTest);
			assertSame('failedMethod name', 'throw_ArgumentError', failure0.failedMethod);
		}
		
	}
}
